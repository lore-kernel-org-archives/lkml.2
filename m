Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1CBH7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:59:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab1CBH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:59:47 -0500
Date: Wed, 2 Mar 2011 08:59:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: denys@visp.net.lb
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NMI received for unknown reason, 2.6.38-rc6 regression?
Message-ID: <20110302075931.GD15665@elte.hu>
References: <950d04b27ce43565cdef24e4072d7e71@visp.net.lb>
 <4D6D1A0B.3050903@gmail.com>
 <9f4d7fae5845b91debc86a65d51bf96a@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4d7fae5845b91debc86a65d51bf96a@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_00,URIBL_SBL autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.5 URIBL_SBL              Contains an URL listed in the SBL blocklist
	[URIs: nuclearcat.com]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* denys@visp.net.lb <denys@visp.net.lb> wrote:

> On Tue, 01 Mar 2011 19:08:43 +0300, Cyrill Gorcunov wrote:
> >On 03/01/2011 06:03 PM, denys@visp.net.lb wrote:
> >>I upgrade around 140 hosts (from 2.6.33 till 2.6.37), and got on
> >>many of them error/warining, flooding kernel log. Here is short
> >>snapshot:
> >>
> >>[ 1882.057474] Uhhuh. NMI received for unknown reason 3c on CPU 0.
> >>[ 1882.057576] Do you have a strange power saving mode enabled?
> >>[ 1882.057672] Dazed and confused, but trying to continue
> >>[ 2421.419732] Uhhuh. NMI received for unknown reason 3c on CPU 0.
> >>[ 2421.419835] Do you have a strange power saving mode enabled?
> >>[ 2421.419930] Dazed and confused, but trying to continue
> >>[ 2636.016831] Uhhuh. NMI received for unknown reason 2c on CPU 1.
> >>[ 2636.016934] Do you have a strange power saving mode enabled?
> >>[ 2636.017003] Dazed and confused, but trying to continue
> >>
> >>Full dmesg from 2 machines:
> >>http://www.nuclearcat.com/dmesg1.txt
> >>http://www.nuclearcat.com/dmesg2.txt
> >>I can provide more, if required.
> >>
> >>It seems nmi_watchdog is enabled by default, and it is causing
> >>issue. I am checking now with nmi_watchdog=0, but i need more
> >>time to confirm that.
> >>Also i am experiencing some problem with ppp users(all of them
> >>is pppoe servers), but i am not sure it is related to that, so
> >>maybe this NMI warning is just cosmetic regression.
> >>
> >>All systems is x86, same kernel config.
> >>If you need more information - let me know.
> >>
> >
> >nmi_watchdog=0 should help here, actually a nit was fixed by
> >https://patchwork.kernel.org/patch/566611/
> >which is not in 2.6.38-rc6 but I rather suspect it'll be in -rc7 or
> >final .38. If you have an ability
> >to pickup it and test -- this would be great!
> I test it, and it seems helps. At least on one host, and yes, seems
> all of them P4.

Mind checking -rc7, does it work 'out of box', without requiring any workarounds? 
-rc7 already has this fix included:

 7d44ec193d95: perf, x86: P4 PMU: Fix spurious NMI messages

-rc6 did not have it yet.

Thanks,

	Ingo
