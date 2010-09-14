Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0INUSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:18:24 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:40201 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0INUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:18:23 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Artur Skawina <art.08.09@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix>
	<alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
	<alpine.LFD.2.00.1009141207310.2416@localhost6.localdomain6>
From: Nix <nix@esperi.org.uk>
Emacs: a real time environment for simulating molasses-based life forms.
Date: Tue, 14 Sep 2010 21:17:59 +0100
In-Reply-To: <alpine.LFD.2.00.1009141207310.2416@localhost6.localdomain6> (Thomas Gleixner's message of "Tue, 14 Sep 2010 12:09:57 +0200 (CEST)")
Message-ID: <878w34qdu0.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Sep 2010, Thomas Gleixner said:

> On Fri, 10 Sep 2010, Thomas Gleixner wrote:
>> On Fri, 10 Sep 2010, Nix wrote:
>> > 
>> > I suspect current_clocksource doesn't do what we think it does, or the
>> > clocksource and 'clock event device' are not the same.)
>> 
>> Right, they are not the same. clocksource provides us a read out
>> device for timekeeping (usually a simple increasing counter). clock
>> event device is used to generate timer interrupts.
>> 
>> HPET provides both functionalities.
>> 
>> The patch you bisected is affecting the clock events part of the
>> HPET. So yes, it's not a clock source problem.
>
> Another question. If you add hpet=verbose (or revert that commit) does
> the printk_once in hpet_set_next_event() show up in dmesg ?
>
>     "hpet: compare register read back failed."

Well, given that I reverted that commit in the past (during the
bisection) and also added hpet=verbose[1], I'd have expected it to turn
up in my past syslogs. There is no sign of it, in syslogs back to 2009.


[1] and indeed am running 2.6.35.4 with hpet=verbose and no symptoms
    on the affected system *now* -- a mystery because I thought the
    hpet=verbose-turns-it-off code was removed, but turning on verbose
    still seems to quash the bug?! or perhaps it's slightly
    intermittent and every N boots I'm lucky enough to miss it. I'm
    slightly chary of rebooting to find out ;}
