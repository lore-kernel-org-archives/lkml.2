Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0IJHmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:42:12 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:39946 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0IJHmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:42:11 -0400
To: Artur Skawina <art.08.09@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette> <87iq2gyllg.fsf@spindle.srvr.nix>
	<87wrqu8s1u.fsf_-_@spindle.srvr.nix> <4C8982EF.8030705@gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: is that a Lisp interpreter in your editor, or are you just happy to see me?
Date: Fri, 10 Sep 2010 08:42:00 +0100
In-Reply-To: <4C8982EF.8030705@gmail.com> (Artur Skawina's message of "Fri, 10 Sep 2010 02:59:27 +0200")
Message-ID: <87eid282pj.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010, Artur Skawina spake thusly:
> I'm seeing this too, except here it happens every couple of days of uptime,
> lasts for a few minutes, and then goes away. Which made bisecting a bit
> impractical... Thank you for doing it. 

I just happened to be the lucky sod for whom it was consistently going
wrong. :)

> HW is similar; x64 and X58/82801JI/ICH10, tsc clocksrc.
> Did that printk trigger?

No.

(hm, odd.

spindle:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

spindle:~# grep -i tsc /proc/timer_list
spindle:~# grep -i hpet /proc/timer_list
Clock Event Device: hpet
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode

I suspect current_clocksource doesn't do what we think it does, or the
clocksource and 'clock event device' are not the same.)
