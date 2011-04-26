Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1DZDX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:23:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35907 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab1DZDXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:23:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 26 Apr 2011 12:17:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use oom_killer_disabled in all oom pathes
Message-Id: <20110426121719.95894bc5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTino+9_GEb28gfZYSu-R0JW44M1mqQ@mail.gmail.com>
References: <20110426115902.F374.A69D9226@jp.fujitsu.com>
	<BANLkTimpidn07YRmm0gNDice3xo-tC8kow@mail.gmail.com>
	<20110426121555.F378.A69D9226@jp.fujitsu.com>
	<BANLkTino+9_GEb28gfZYSu-R0JW44M1mqQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 11:19:22 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> On Tue, Apr 26, 2011 at 11:14 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> On Tue, Apr 26, 2011 at 10:57 AM, KOSAKI Motohiro
> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >> oom_killer_disable should be a global switch, also fit for oom paths
> >> >> other than __alloc_pages_slowpath
> >> >>
> >> >> Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.
> >> >
> >> > Can you please explain more? Why should? Now oom_killer_disabled is used
> >> > only hibernation path. so, Why pagefault and memcg allocation will be happen?
> >>
> >> Indeed I'm using it in virtio balloon test, oom killer triggered when
> >> memory pressure is high.
> >>
> >> literally oom_killer_disabled scope should be global, isn't it?
> >
> > ok. virtio baloon seems fair usage. if you add new usage of oom_killer_disabled
> > into the patch description, I'll ack this one.
> 
> Thanks, then I will resend the virtio balloon patch along with this.
> 

Amount of free memory doesn't affect memory cgroup's OOM because it just works
against the limit. So, the code for memcg isn't necessary.


Thanks,
-Kame

