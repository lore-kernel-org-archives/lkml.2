Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2GRPaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:30:15 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:20639 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751162Ab2GRPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:30:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: W8U.2.AVM1lCCByp_hBIWXn6VTcyFiG7lS7zm9qyM5SEZ32
 gwGGH.7S.pS_svu1KIMJpU3TP6KaGlQP7BSg9sM6WyndMbLnvWXj1qsNrM3V
 cTlfFT1YZsfa_e3VdvtQrZ0BAtSpJkOLKlgTI34ucVcbHrP_x5861h3VUSEM
 XUXEMLfNnXw3a_ZexyoVOIAWuM3CzYKYSUee50V2owxATtrK5ildGV.HjI6C
 7bO36HkYvnamVX.WnprvjySJ8jRccCFuCfsgxUBwu3molbAOyug3CFqzPsSu
 FAZLs4_fHoorzKMMgn9dLrv12MfPYvnD0Cc5ZMEmDtbM_TsheKiBBEm4sgAx
 NFaGd_ZOU6v7qOmz8cBwKMWA1rYUwUudLsuY1Dkuk8HNQf5yjD5Ey1_FRrYS
 yZ.QUodgF8UvGxEXB6ScdGpP2F.G_LPMN5Qb1
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 18 Jul 2012 10:30:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Luck, Tony" <tony.luck@intel.com>
cc: Jiang Liu <liuj97@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Jianguo Wu <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1936AB66@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1207181029480.22907@router.home>
References: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207171237320.15177@router.home> <3908561D78D1C84285E8C5FCA982C28F1936AB66@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Luck, Tony wrote:

> > This suggests that a call to early_kmem_cache_node_alloc was not needed
> > because the per node structure already existed. Lets fix that instead.
>
> Perhaps by just having one API for users to call? It seems odd to force users
> to figure out whether they are called before some magic time during boot
> and use the "early...()" call. Shouldn't we hide this sort of detail from them?

The early_ calls are internal to the allocator and not exposed to the
user.
