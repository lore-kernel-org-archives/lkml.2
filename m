Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab0KRXcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:32:45 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8456 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab0KRXco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:32:44 -0500
Subject: Re: divide error in select_task_rq_fair()
From: Myron Stowe <myron.stowe@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, rjenties@google.com
In-Reply-To: <AANLkTikUnLc8L_0+CQOwPgr-oifws=sqnFPxWz46MTCi@mail.gmail.com>
References: <20101104041236.GA9389@helgaas.com>
	 <1288937844.3234.1.camel@edumazet-laptop> <1289500084.2698.12.camel@zim>
	 <201011121152.30204.knikanth@suse.de> <1289756161.2814.29.camel@zim>
	 <AANLkTikUnLc8L_0+CQOwPgr-oifws=sqnFPxWz46MTCi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 16:32:41 -0700
Message-ID: <1290123161.2447.27.camel@zim>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 11:11 -0800, Yinghai Lu wrote:
> On Sun, Nov 14, 2010 at 9:36 AM, Myron Stowe <myron.stowe@hp.com> wrote:
> >
> > I got the same divide error with this latest patch (see attachment).  If
> > I revert commit 50f2d7f682f9, the platform boots successfully.
> 
> please check patch in
> http://lkml.org/lkml/2010/11/13/181

I was able to test this patch and with it applied the system did boot
successfully.

While I think you are on the correct path with respect to this issue I
could not make any sense out of the patch heading and description.
Worse - I'm thinking that it is even mis-leading as currently written
(especially the patch heading).

Thanks,

Myron
> 
> BTW, you also need to ask your BIOS guys to fix the SRAT table.
> If you only have 128 cpu entries in MADT, SRAT table should have 128
> cpu entries instead of 256 cpu entries
> otherwise, RHEL 5.5 could have problem. it will throw away last cpu
> entry in SRAT,
>  (NR_CPUS is 255..., and last entry still could point the right cpu in MADT)
> Also BIOS should keep cpu entries in SRAT have same order to that in MADT.
> 
> Thanks
> 
> Yinghai
> 


-- 
Myron Stowe                             Linux Kernel Developer
Fort Collins, CO                        Office of Corporate Strategy and Technology

