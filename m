Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2GFNx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:53:28 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36053 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750770Ab2GFNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:53:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XdKRvtAVM1nl_FTM4HvCu3kGYEIXwfQZHKRDDX4q6PMLHB2
 R9siMeqsQ0RdeYE7yh_p2d9poGw7vimg0ArNybRebaR9qAgo84rC8UDJvs5Z
 wHXeBnvyF5CJUN2OJ9PKO_o9phKPReHN5dbTMcl0aE4Wiguesjq1Hx9dzue3
 q5ZOv6lcwQZEqiPw0JLtG5s_JqKPDoJAsGt07RAjI_TzL8O5sp_yGtwpLNTG
 A.WNywKL7uGt5dAuTe6UbpN.sLb_f02QByoPCWl8yC_Ra5rYjBBoipCAciPj
 Srxt7GMAsDXnbm.OrAPbv15M_GtOBH6uNHFLRzpG5plzhYAX8QVdRBGsD09n
 6y5c0Kte8nhbUA6pnasiHPMsrKFDHnAU8HMQVw8uG1Lw0QUzAvPTtuGD5PPw
 wllkF_kgyMSjxhMXHkv6fAUsPV.2QgIKnimcd
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 08:53:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <jiang.liu@huawei.com>
cc: Jiang Liu <liuj97@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] mm: make consistent use of PG_slab flag
In-Reply-To: <4FF6A21C.9010509@huawei.com>
Message-ID: <alpine.DEB.2.00.1207060851310.26441@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <1341287837-7904-2-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207050945310.4984@router.home> <4FF5BD9D.9040101@gmail.com> <alpine.DEB.2.00.1207051236310.8670@router.home>
 <4FF6A21C.9010509@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Jiang Liu wrote:

> 	This patch is not for hotplug, but is to fix some issues in current
> kernel, such as:
> 	1) make show_mem() on ARM and unicore32 report consistent information
> no matter which slab allocator is used.

The information is only different because allocations do not go through
the slab allocators for SLUB/SLOB.

> 	2) make /proc/kpagecount and /proc/kpageflags return accurate information.

Fix the compound handling in those and the numbers will be correct. This
is also good for other issues that may arise because the flags in the
compound head are not considered.

> 	3) Get rid of risks in mm/memory_failure.c and arch/ia64/kernel/mca_drv.c

Assuming that a slab allocation fits into a page is a dangerous
assumption. There are arches with much large page sizes. Please fix the
code.


