Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0FWS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:29:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34141 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0FWS3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vF5Wdu9Wtg5mXDvMNuWE/qT/Mhh/fQOOscdLp6jrz95TLbLxNVJotSBF957v0iB7eV
         n9gjXVEEuuJiQleLbKWkPIb/+JPwl+gZv2+rojgFn4MmwPuKZ8qg3myiGzDM1u9eIVYM
         7boYwQB/0j7W0TfkGDO53OqvvuzIHI2tFDtgs=
MIME-Version: 1.0
In-Reply-To: <877hlpfwlh.fsf@old-tantale.fifi.org>
References: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
	<87bpb1fxwg.fsf@old-tantale.fifi.org>
	<AANLkTinm1ZXybaAgCUGGPkK_YKaGmO9k2mduoy9ThnQ3@mail.gmail.com>
	<877hlpfwlh.fsf@old-tantale.fifi.org>
Date: Wed, 23 Jun 2010 14:29:44 -0400
X-Google-Sender-Auth: Yzcf6uHOUz4hGVKoq-ErPRO_co0
Message-ID: <AANLkTim6IiHbd6tN6bfS2kppRPaIzoGLC6nAl5IF3dOj@mail.gmail.com>
Subject: Re: i915: Dell E6410 Ironlake LVDS detection
From: Ben Guthro <ben@guthro.net>
To: Philippe Troin <phil@fifi.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 2:11 PM, Philippe Troin <phil@fifi.org> wrote:
> Ben Guthro <ben@guthro.net> writes:
>
>> On Wed, Jun 23, 2010 at 1:42 PM, Philippe Troin <phil@fifi.org> wrote:
>> > I am seeing similar problems with an HP Elitebook 2540p.
>> >
>> > 2.6.32 works for me.
>> > 2.6.33.5 does not.
>>
>> I have tried ubuntu mainline builds of:
>>
>> 2.6.32.21
>> 2.6.32.22
>> 2.6.34-rc3
>> 2.6.35-rc1
>> 2.6.34-drm-intel-next
>>
>> None have worked yet...
>
> Tried a vanilla kernel?

Yes, both mainline, and the drm-intel branch. Both boot to the black screen,

>
>> > I was able to turn on an external display connected via VGA with
>> > xrandr and it seemed to be working fine?
>>
>> When I boot without the external display, I am never able to ssh in -
>> and I do not get the sound that typically plays when X is booted.
>>
>> I've put this onto a serial line, and it seems to hang sometime in
>> init...with some indicators that it is when it switches over to the
>> higher resolution console...but the screen is black, so this is really
>> just a gut feel.
>
> Then it might be a different problem.  For me, X definitely boots.
>
> Can you boot with nomodeset?

It seemed to reboot the system at some point in the boot process (panic?)

> What does lspci report for you?


00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 02)
	Subsystem: Dell Device 040a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 40b0 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0a00c  Data: 4191
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCIe advanced features <?>
	Kernel driver in use: i915
	Kernel modules: i915



I booted with the external VGA connected, and drm.debug=0x06, and got
the following message that looked interesting:

[    9.203990] [drm:intel_lvds_init], LVDS is not present in VBT


I'm not sure why yet....but it seems like a reasonable string to pull on...
