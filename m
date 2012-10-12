Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2JLHS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:18:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59339 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2JLHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <CADCVGbRTYecZrv+pH3QUHEQsAkar8XNaKhDLWm-K72f9hUCVOg@mail.gmail.com>
References: <CADCVGbRTYecZrv+pH3QUHEQsAkar8XNaKhDLWm-K72f9hUCVOg@mail.gmail.com>
Date: Fri, 12 Oct 2012 03:18:56 -0400
Message-ID: <CAHdPZaNj+Ji+cgt+3myE8vE_dX9rAR_jpGH=jjmbw0sLdcr2aw@mail.gmail.com>
Subject: Re: Using ps to display process information never exit, and can't be killed
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Cyberman Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 1:56 AM, Cyberman Wu <cypher.w@gmail.com> wrote:
> Sorry to use that big mail list account since I don't know any
> specific mail list account should be used for that problem.
>
> We're running Linux box on Gx platform from Tilera. The kernel use
> some vendor specific patches, but most of them
> are the same as standard kernel.
>
> We encounter a problem occasionally, that I'm trying to resolve it.
> But while I used 'ps' to get process information,
> the new launched ps print out nothing and can't exit, ^C doesn't work.
> I find out its pid under /proc, and it's in RUNNING
> state:
> # cat status
> Name:   ps
> State:  R (running)
> Tgid:   1298
> Pid:    1298
> PPid:   1
> TracerPid:      0
> Uid:    0       0       0       0
> Gid:    0       0       0       0
> FDSize: 64
> Groups: 0 1 2 3 4 6 10 489
> VmPeak:     3776 kB
> VmSize:     3712 kB
> VmLck:         0 kB
> VmHWM:      2624 kB
> VmRSS:      2624 kB
> VmData:      832 kB
> VmStk:       256 kB
> VmExe:       192 kB
> VmLib:      2176 kB
> VmPTE:         6 kB
> VmSwap:        0 kB
> Threads:        1
> SigQ:   7/8113
> SigPnd: 0000000000000100
> ShdPnd: 00000000000a0103
> SigBlk: 0000000000000000
> SigIgn: 0000000000000004
> SigCgt: 0000000073d3fef9
> CapInh: 0000000000000000
> CapPrm: ffffffffffffffff
> CapEff: ffffffffffffffff
> CapBnd: ffffffffffffffff
> Cpus_allowed:   f,ffffffff
> Cpus_allowed_list:      0-35
> Mems_allowed:   3
> Mems_allowed_list:      0-1
> voluntary_ctxt_switches:        1
> nonvoluntary_ctxt_switches:     0
>
> And it can't be killed even using SIGKILL.
>
> Since it's under *RUNNING* status, its stack can't be dumped. Is there
> any exist mechanism can be used to
> get it stack, or other information, to help me figure out what's the
> cause of ps pend on *RUNNING*?
>
My answer may be silly, but did you tried running with strace?

>
> System information:
> # uname -a
> Linux localhost 2.6.38.8-MDE-4.0.0.141101 #7 SMP Fri Sep 28 21:46:08
> CST 2012 tilegx GNU/Linux
>
>
>
> Best regards.
>
> --
> Cyberman Wu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
