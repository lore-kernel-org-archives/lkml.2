Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0IJUNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:13:37 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:46547 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0IJUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:13:36 -0400
To: Artur Skawina <art.08.09@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix>
	<alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
	<4C89FD56.6060505@gmail.com> <4C8A3131.7030003@gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: a compelling argument for pencil and paper.
Date: Fri, 10 Sep 2010 21:13:19 +0100
In-Reply-To: <4C8A3131.7030003@gmail.com> (Artur Skawina's message of "Fri, 10 Sep 2010 15:22:57 +0200")
Message-ID: <8762yd8ihs.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=9 Fuz1=9 Fuz2=9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010, Artur Skawina outgrape:

> On 09/10/10 11:41, Jiri Slaby wrote:
>> AFAIU, clocksource=jiffies shouldn't fix this issue. If that's the case
>> we have another 2.6.32->2.6.33 regression (and I will report it
>> separately). People report the system is unusable (sleepers are not
>> woken), unless clocksource=jiffies, clocksource=tsc or nolapic_timer is
>> used or a key pressed (i.e. some HW interrupt):
>> https://bugzilla.novell.com/show_bug.cgi?id=579932
>> (there is also a report with 2.6.35.3 vanilla)
>
> I saw this first in v2.6.35-rc4. The symptom is that suddenly everything
> stops and the only way to make things progress is to generate some events.
> Apps that are waiting for a timeout aren't woken up unless you press a key
> etc. After a few minutes (and lots of key presses ;) ) the machine usually
> recovers, leaving no trace in logs.

In NOHZ mode, my (consistently affected) system never recovers. In !NOHZ
mode, it never locks up, although timings are shot all to hell.
