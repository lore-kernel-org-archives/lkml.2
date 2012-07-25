Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190Ab2GYPb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:31:58 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:47188 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750911Ab2GYPb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:31:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SvhBseIVM1n25sBjr8XGCMPBn4PuWs7TFLuT2x6Yznmo5na
 2vLXdkVxkDcHuwp5FV.DJHFuolimco1dB4VDCjSkzCIn7_glMbnLaHel7Hnw
 9bRgX2eAZt8_Zs4wR09BEnZAMVgOaqKiav4uqvJnxuQqMHcZnhCEBmSKiAff
 U8ow51g6sg1zicivaJjJhBhdyOOhLy0dHoujxKwM53EF7DHiAeWN_NhlSsRU
 3_zKobN7IAws03YWreoC_bKOjmFjnwatXCgaGwuvPkcFr3XqIOcMa08flBv4
 cfP4vsbDQK9ZWSqcKTw0ZkIqsD1zyZ6Q9YHH.2PtS8K9Rbw2nQleIj04CvZm
 yeGaBZavhuT5vQLy4QFQ0TeuqBRlymDXL8r0O6co_NIvc0oKJKmUfXCEwlDk
 .PYnoBfPb8mLLQ8tAoQFgPkC_7ni0ixNLvGgMCwftKz9sL3JRFQkK
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 25 Jul 2012 10:31:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <liuj97@gmail.com>
cc: Jiang Liu <jiang.liu@huawei.com>, WuJianguo <wujianguo@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] SLUB: enhance slub to handle memory nodes without
 normal memory
In-Reply-To: <500ED4B5.4010104@gmail.com>
Message-ID: <alpine.DEB.2.00.1207251029190.32678@router.home>
References: <alpine.DEB.2.00.1207181349370.22907@router.home> <1343123710-4972-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207240931560.29808@router.home> <500ED4B5.4010104@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Jiang Liu wrote:

> > There is already a N_NORMAL_MEMORY node map that contains a list of node
> > that have *normal* memory usable by slab allocators etc. I think the
> > cleanest solution would be to clear the corresponding node bits for your
> > special movable only zones. Then you wont be needing to modify other
> > subsystems anymore.
> >
> Hi Chris,
> 	Thanks for your comments! I have thought about the solution mentioned,
> but seems it doesn't work. We have node masks for both N_NORMAL_MEMORY and
> N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
> But we still don't have such a mechanism to distinguish between "normal" and "movable"
> memory. So for memory nodes with only movable zones, we still set N_NORMAL_MEMORY for
> them. One possible solution is to add a node mask for "N_NORMAL_OR_MOVABLE_MEMORY",
> but haven't tried that yet. Will have a try for that.

Hmmm... Maybe add another N_LRU_MEMORY bitmask and replace those
N_NORMAL_MEMORY uses with N_LRU_MEMORY as needed? Use N_NORMAL_MEMORY for
subsystems that need to do regular (non LRU) allocations that are not
movable?
_
