Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2GEOrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:47:21 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:47123 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932779Ab2GEOrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:47:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zxzopNIVM1lZDC_LAHiQBY6PirexcY5D_JC0iQL2dGOBtMV
 7TYI_b0oq4jxj4E5DH4gFVPFiaFdhjxtQJaMaulJQJ665.D2jYheAdHBfPot
 .LOtGFZ1KL5ccookJ0GnlYt2pqZ16b1HKsBdC7XCr8fLEDg.KGxKUSxy_Maj
 CfVIf7WxoWwXpOie7V50nk37yT0MDJQvOpVeRaJAZzkfgySBYqOL.I707kvf
 H_YriYDh0iZ1EMPePpqkIcqNQyw6JtwmWCyDjm0Ys2xK8guI0.AaoVpv840B
 25CMuyfBzN.GNkuF8TDTWzdZ1gz0U8yyL_SS0cgQkMjOk.pgnLrQnpXunFLb
 UBb3kquo2CPcx1QC9GVO8U.z7AhHx8PWGfN7L78ihwmBdp04B2pLMIeDHo6D
 J
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 09:47:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <jiang.liu@huawei.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH 2/4] mm: make consistent use of PG_slab flag
In-Reply-To: <1341287837-7904-2-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.DEB.2.00.1207050945310.4984@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <1341287837-7904-2-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Jiang Liu wrote:

> PG_slabobject:	mark whether a (compound) page hosts SLUB/SLOB objects.

Any subsystem may allocate a compound page to store metadata.

The compound pages used by SLOB and SLUB are not managed in any way but
the calls to kfree and kmalloc are converted to calls to the page
allocator. There is no "management" by the slab allocators for these
cases and its inaccurate to say that these are SLUB/SLOB objects since the
allocators never deal with these objects.
