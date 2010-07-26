Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0GZWaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:30:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51214 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0GZWaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iXyac1gs9Cgab4vDIDD2H6vmYVf5eo7myDzLxpAWRFiIZvgD2PvVbSpBXDSfe0qaAt
         Pd4mtxjOmjyNCpxawyNNm8DHThRIO2YhV5SxNxWdlCamaDbOHpv8KsjHz2EVwvhUPGIx
         Q3iKcdJjw9QJm9YdEDDJiVvP4mqkjYSXYcDUI=
MIME-Version: 1.0
In-Reply-To: <20100726222451.GB6487@srcf.ucam.org>
References: <1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop> 
	<1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> 
	<1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux> 
	<20100726211424.GA5197@srcf.ucam.org> <AANLkTimn1XvpfUrgdgkO-E3kX55fz7N8w+_24Lz1ySLn@mail.gmail.com> 
	<20100726222451.GB6487@srcf.ucam.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Jul 2010 15:29:55 -0700
X-Google-Sender-Auth: y_XK-EW2mdNzg74J-gTyCzzhuaQ
Message-ID: <AANLkTi=WdWshDx2t0X1oLpZ1WweCJNYxgH8o71BDOOYc@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Quan <David.Quan@atheros.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 3:24 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jul 26, 2010 at 03:20:23PM -0700, Luis R. Rodriguez wrote:
>> On Mon, Jul 26, 2010 at 2:14 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > On Mon, Jul 26, 2010 at 02:06:51PM -0700, Luis R. Rodriguez wrote:
>> >
>> >> No, ASPM must be enabled by the Systems Integrator through the BIOS, there are
>> >> other settings that have to be taken care of like modifying some PCI entrance and
>> >> exit latency timers, the number of FTS packets we send to exit L0s, amongst
>> >> other things. If a user selectively enables L1 but the BIOS had it disabled on
>> >> the device it may not work correctly.
>> >
>> > That's really the job of the driver.
>>
>> The problem is that sometimes tweaks need to be done on the PCI
>> controller/root complex, not the PCIE device/endpoint. Today these
>> sort of changes *are* handled by the respective  systems
>> integrator/BIOS team and varies depending on the root complex used.
>> Atheros does not handle these at all in the driver.
>
> Really? Your Windows drivers declare that they support ASPM for some
> parts, which will trigger Vista and later to program L0s and L1
> (depending on system config) without further reference to the driver. If
> we need hooks in the kernel for drivers to provide further feedback to
> make sure this works correctly then we can certainly provide them...

Sure, agreed, I'm just pointing out today there are other changes made
and even Microsoft does not get involved with them, so it is the same
for us. However I do agree if the kernel can expose API to tweak
things then great.

>> > If the ASPM policy is set to
>> > powersave, the fadt doesn't indicate that ASPM should be disabled and
>> > the bus's _OSC method grants full control then the kernel will enable
>> > whatever combination of L states meet the latency constraints. If the
>> > hardware has additional constraints then the hardware-specific driver
>> > needs to handle them.
>>
>> This makes sense but Is there an API for this?
>
> Right now, no. What do you need?

Not sure, let me check internally and see if I can get the exact details.

>> > We don't rely on the BIOS to set up ASPM states. Nor does Windows.
>>
>> Understood, but today some tweaks seem to be done on the BIOS
>> depending on the endpoint / root complex.
>
> The current situation is that we won't modify anything that the BIOS has
> done, other than the link and clock pm bits. So if the BIOS has done
> something for us, we won't (currently) step on it.

Sure, understood.

  Luis
