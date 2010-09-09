Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0IIX5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:57:30 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:59887 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab0IIX51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:57:27 -0400
To: John Drescher <drescherjm@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette> <87iq2gyllg.fsf@spindle.srvr.nix>
	<87wrqu8s1u.fsf_-_@spindle.srvr.nix>
	<AANLkTinSr0xoRrtZ6R+sRyQbf0LXhqBJisQTcdHc+A8+@mail.gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: because you deserve a brk today.
Date: Fri, 10 Sep 2010 00:57:19 +0100
In-Reply-To: <AANLkTinSr0xoRrtZ6R+sRyQbf0LXhqBJisQTcdHc+A8+@mail.gmail.com> (John Drescher's message of "Thu, 9 Sep 2010 19:44:55 -0400")
Message-ID: <87iq2e8o80.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010, John Drescher spake thusly:

>> John, Damien, you seem to be experiencing this: are you using HPET as
>> your clocksource? Do you also have ICH10 82801JIs, or is this more
>> widespread?
>>
> I am not using hpet as my clocksource.
>
> jmd1 ~ # uname -a
> Linux jmd1 2.6.35-std160-amd64 #2 SMP Fri Aug 13 18:42:02 UTC 2010
> x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
> jmd1 ~ # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc

Hm, interesting. Perhaps the HPET is needed anyway? (That would explain
why my other system, with identical specs to those above and using tsc
as clocksource, was seeing intermittent problems in this area.)

But 82801JI looks like a common factor.
