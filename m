Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0FWSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:11:12 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:35941 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0FWSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:11:10 -0400
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: Dell E6410 Ironlake LVDS detection
References: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
	<87bpb1fxwg.fsf@old-tantale.fifi.org>
	<AANLkTinm1ZXybaAgCUGGPkK_YKaGmO9k2mduoy9ThnQ3@mail.gmail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 23 Jun 2010 11:11:06 -0700
In-Reply-To: <AANLkTinm1ZXybaAgCUGGPkK_YKaGmO9k2mduoy9ThnQ3@mail.gmail.com>
Message-ID: <877hlpfwlh.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Guthro <ben@guthro.net> writes:

> On Wed, Jun 23, 2010 at 1:42 PM, Philippe Troin <phil@fifi.org> wrote:
> > I am seeing similar problems with an HP Elitebook 2540p.
> >
> > 2.6.32 works for me.
> > 2.6.33.5 does not.
> 
> I have tried ubuntu mainline builds of:
> 
> 2.6.32.21
> 2.6.32.22
> 2.6.34-rc3
> 2.6.35-rc1
> 2.6.34-drm-intel-next
>
> None have worked yet...

Tried a vanilla kernel?

> > I was able to turn on an external display connected via VGA with
> > xrandr and it seemed to be working fine?
> 
> When I boot without the external display, I am never able to ssh in -
> and I do not get the sound that typically plays when X is booted.
> 
> I've put this onto a serial line, and it seems to hang sometime in
> init...with some indicators that it is when it switches over to the
> higher resolution console...but the screen is black, so this is really
> just a gut feel.

Then it might be a different problem.  For me, X definitely boots.

Can you boot with nomodeset?

X will refuse to start, but then maybe you can set up your laptop so
that the network comes up without needing X.

Then you could try to reboot with i915+modeset and see if the machine
is still alive (and it's just a connector issue) or if the machine is
dead (then it's a deeper driver issue).

What does lspci report for you?

Mine says:

00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 7008
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 34
        Region 0: Memory at d0000000 (64-bit, non-prefetchable)
[size=4M]
        Region 2: Memory at c0000000 (64-bit, prefetchable)
[size=256M]
        Region 4: I/O ports at 5078 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915

Phil.
