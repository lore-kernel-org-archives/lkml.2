Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0IJUMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:12:45 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:46533 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0IJUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:12:43 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Artur Skawina <art.08.09@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix>
	<alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
	<4C89FD56.6060505@gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: because editing your files should be a traumatic experience.
Date: Fri, 10 Sep 2010 21:12:21 +0100
In-Reply-To: <4C89FD56.6060505@gmail.com> (Jiri Slaby's message of "Fri, 10 Sep 2010 11:41:42 +0200")
Message-ID: <87aanp8ije.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=9 Fuz1=9 Fuz2=9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010, Jiri Slaby spake thusly:

> On 09/10/2010 10:37 AM, Thomas Gleixner wrote:
>> HPET provides both functionalities.
>> 
>> The patch you bisected is affecting the clock events part of the
>> HPET. So yes, it's not a clock source problem.
>
> AFAIU, clocksource=jiffies shouldn't fix this issue. If that's the case
> we have another 2.6.32->2.6.33 regression (and I will report it

What? This is a 2.6.35 regression from 2.6.34 (and all previous kernels).
clocksource=jiffies has never yet been mentioned (I could try it, but
I think I know what the result would be).

2.6.32 and 2.6.33 both worked fine.

> separately). People report the system is unusable (sleepers are not
> woken), unless clocksource=jiffies, clocksource=tsc or nolapic_timer is
> used or a key pressed (i.e. some HW interrupt):
> https://bugzilla.novell.com/show_bug.cgi?id=579932

This is similar, but not identical: this particular bug is only fixed by
keypresses in the early stages (in NOHZ mode) and *interferes* with all
responsiveness including keystroke response both in NOHZ and !NOHZ mode.

It's probably another HPET timer problem, though, but that doesn't mean
it necessarily has the same cause.
