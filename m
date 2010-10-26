Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab0JZN6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:58:15 -0400
Received: from smtp-out-226.synserver.de ([212.40.180.226]:1081 "HELO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755175Ab0JZN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:58:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 32257
Date: Tue, 26 Oct 2010 15:58:08 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026135808.GB1672@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026131843.GC17852@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> On Tue, Oct 26, 2010 at 07:20:52AM -0400, Markus Trippelsdorf wrote:
> > On my AMD system the following kernel messages are sometimes printed
> > after several hours of uptime:
> > Clocksource tsc unstable (delta = -8589361717 ns)
> > Switching to clocksource hpet
> 
> This is strange, tsc is actually stable on your F10h revC.

Yes. constant_tsc is among the CPU flags.

> > This happened several times already:
> > # grep "Clocksource" kernel.*
> > kernel.log:Oct 24 18:31:17 arch kernel: Clocksource tsc unstable (delta = -8591703466 ns)
> > kernel.log:Oct 26 12:54:38 arch kernel: Clocksource tsc unstable (delta = -8589361717 ns)
> > kernel.log.1:Oct 22 21:43:51 arch kernel: Clocksource tsc unstable (delta = -25772316650 ns)
> 
> Do you have any warnings/oopses before that, can we have the whole dmesg
> with the above messages?

No warning/oopses. The whole dmesg is attached.

> 
> > The computer is nearly unusable afterwards (second long delays, that
> > seem to grow larger and larger) and only a prompt reboot can fix the
> > problem.
> > I'm running the latest git kernel. Version 2.6.36 does not show these
> > symptoms.
> > 
> > Dmesg and kernel config are attached.
> > 
> > -- 
> > Markus
> 
> > Initializing cgroup subsys cpu
> > Linux version 2.6.36-05618-gb18cae4-dirty (markus@arch.trippelsdorf.de) (gcc version 4.5.1 (GCC) ) #41 SMP PREEMPT Tue Oct 26 06:51:47 CEST 2010
> 
>  ...-dirty means you have some changes ontop of b18cae4. What are those?

The SCHED_AUTOGROUP patches from Mike Galbraith.

> > Command line: root=/dev/sdb2 fbcon=rotate:3 quiet kexec_jump_back_entry=0x23d64482b7e72bb7
> > BIOS-provided physical RAM map:
> 
> otherwise, I don't see anything strange in your dmesg. Unless tglx has a
> better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
> much but I don't know, if the issue appears every several hours it could
> still be tedious.

That would be a several week long process, as the issue appears ~ every
2 days here on this machine running 24/7.

-- 
Markus
