Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0GLAYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 20:24:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57932 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0GLAYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 20:24:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Jul 2010 09:20:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nauman Rafique <nauman@google.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-Id: <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100710132417.GA2752@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
	<20100709134546.GC3672@redhat.com>
	<4C37BC1A.20102@ds.jp.nec.com>
	<AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
	<20100710132417.GA2752@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jul 2010 09:24:17 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jul 09, 2010 at 05:55:23PM -0700, Nauman Rafique wrote:
> 
> [..]
> > > Well, right.  I agree.
> > > But I think we can work parallel.  I will try to struggle on both.
> > 
> > IMHO, we have a classic chicken and egg problem here. We should try to
> > merge pieces as they become available. If we get to agree on patches
> > that do async IO tracking for IO controller, we should go ahead with
> > them instead of trying to wait for per cgroup dirty ratios.
> > 
> > In terms of getting numbers, we have been using patches that add per
> > cpuset dirty ratios on top of NUMA_EMU, and we get good
> > differentiation between buffered writes as well as buffered writes vs.
> > reads.
> > 
> > It is really obvious that as long as flusher threads ,etc are not
> > cgroup aware, differentiation for buffered writes would not be perfect
> > in all cases, but this is a step in the right direction and we should
> > go for it.
> 
> Working parallel on two separate pieces is fine. But pushing second piece
> in first does not make much sense to me because second piece does not work
> if first piece is not in. There is no way to test it. What's the point of
> pushing a code in kernel which only compiles but does not achieve intented
> purposes because some other pieces are missing.
> 
> Per cgroup dirty ratio is a little hard problem and few attempts have
> already been made at it. IMHO, we need to first work on that piece and
> get it inside the kernel and then work on IO tracking patches. Lets
> fix the hard problem first that is necessary to make second set of patches
> work.
> 

I've just waited for dirty-ratio patches because I know someone is working on.
But, hmm, I'll consider to start work by myself.

(Off-topic)
BTW, why io-cgroup's hierarchy level is limited to 2 ?
Because of that limitation, libvirt can't work well...

Thanks,
-Kame

