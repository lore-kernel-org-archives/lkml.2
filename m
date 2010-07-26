Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0GZWOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:14:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36820 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0GZWOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=p6MdTdx1Dnl3I0GuUt3E3H+DlhLWYrjF06wOxjn8aCf6H9oSEgpCxnyOOsMFl5AKMw
         PlBfpKN7U3nQDR4fbG6hKmYmn/Xmw8rZFWl6+qtszv1sQ4ik61+CL2U7kT1+ivIoWbWC
         SfswzgKQx2+y+DzzVa5PoUhhZOCFmZZUTbjqc=
MIME-Version: 1.0
In-Reply-To: <1280179033.3721.15.camel@maxim-laptop>
References: <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> 
	<1276859156.19554.2.camel@maxim-laptop> <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop> 
	<1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> 
	<1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux> 
	<1280179033.3721.15.camel@maxim-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Jul 2010 15:13:42 -0700
X-Google-Sender-Auth: zn8mYpDHpYBOelJrB0OsQ7WMxBA
Message-ID: <AANLkTi=x9Q9q6nDnyHCGdyWy1UL6_BrS512-xYfnOGUm@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        David Quan <David.Quan@atheros.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
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

On Mon, Jul 26, 2010 at 2:17 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Mon, 2010-07-26 at 14:06 -0700, Luis R. Rodriguez wrote:
>> On Mon, Jul 26, 2010 at 01:49:22PM -0700, Maxim Levitsky wrote:
>> > On Mon, 2010-07-26 at 13:13 -0700, Luis R. Rodriguez wrote:
>> > > On Sat, Jun 19, 2010 at 08:32:44AM -0700, Maxim Levitsky wrote:
>> > > > On Sat, 2010-06-19 at 16:02 +0300, Maxim Levitsky wrote:
>> > > > > On Sat, 2010-06-19 at 08:38 -0400, Bob Copeland wrote:
>> > > > > > On Sat, Jun 19, 2010 at 10:49:34AM +0300, Maxim Levitsky wrote:
>> > > > > > > How this patch?
>> > > > > >
>> > > > > > Looks fine to me.  Some nitpicking below but feel free to add my
>> > > > > >
>> > > > > > Acked-by: Bob Copeland <me@bobcopeland.com>
>> > > > > >
>> > > > Done.
>> > > >
>> > > > Best regards,
>> > > > Maxim Levitsky
>> > > >
>> > > > ---
>> > > >
>> > > > commit 616afa397b3e843f2aba06be12a30e72dfff7740
>> > > > Author: Maxim Levitsky <maximlevitsky@gmail.com>
>> > > > Date:   Thu Jun 17 23:21:42 2010 +0300
>> > > >
>> > > >     ath5k: disable ASPM
>> > > >
>> > > >     Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>> > > >     Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>> > > >     enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>> > > >     'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
>> > > >     these problems.
>> > > >     Also card sends a storm of RXORN interrupts even though medium is idle.
>> > > >
>> > > >     Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
>> > > >     both ends (usually stalls within seconds).
>> > > >
>> > > >     Unfortunately BIOS enables ASPM on this card by default on these machines
>> > > >     This means that, problem shows up (less often) without pcie_aspm=force too.
>> > > >     Therefore to benefit from this fix you need to _enable_ CONFIG_PCIEASPM
>> > > >
>> > > >
>> > > >     All credit for this patch goes to Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> > > >     for finding and fixing this bug.
>> > > >
>> > > >     Based on patch that is
>> > > >     From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> > > >
>> > > >
>> > > >     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>> > > >     Acked-by: Bob Copeland <me@bobcopeland.com>
>> > >
>> > > Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> > >
>> > > But please resubmit and completley modify the commit log to indicate
>> > > ath5k cards support ASPM but L0s must be disabled, only L1
>> > > works correctly.
>> > >
>> > > The comments about ASPM force should be removed as it would
>> > > lead others to try to use the same and the fact of the matter is
>> > > that ASPM force should never be used. As was clarified out of
>> > > some of these discussions worth noting also is that in newer
>> > > kernels CONFIG_PCIEASPM=y will always become the default, for
>> > > older kernels this was never the default and some distributions
>> > > (Ubunutu) do not have this enabled, the benefit of having it
>> > > enabled is it will disable ASPM for these cases:
>> > >
>> > > (a) the PCIE device is pre PCIE 1.1
>> > > (b) the firmware has the FADT flag set to tell you not to and
>> > > (c) the firmware doesn't grant control via _OSC. The powersave policy will
>> > > enable ASPM even if the BIOS didn't, but only if something else doesn't
>> > > tell us not to.
>> > >
>> > > The last two checks were only recently added by Mathew and forcing
>> > > CONFIG_PCIEASPM=y was also only recently made default.
>> > >
>> > > In short, Linux distributions should also start enabling
>> > > CONFIG_PCIEASPM=y on older kernels.
>> >
>> >
>> > Just one note that since at least my ath5k device is pre 1.1, and you
>> > say that L1 can be enabled, and should, I probably need to enable L1
>> > explicitly in the driver.
>> >
>> > OK?
>>
>> No, ASPM must be enabled by the Systems Integrator through the BIOS, there are
>> other settings that have to be taken care of like modifying some PCI entrance and
>> exit latency timers, the number of FTS packets we send to exit L0s, amongst
>> other things. If a user selectively enables L1 but the BIOS had it disabled on
>> the device it may not work correctly.
>>
>> In other words leave the settings as-is on your card unless you developing
>> for a company to enable ASPM yourself or you are willing to take the risks.
>> Tweaks like force enabling a device to use ASPM should only then be done in
>> userspace and by an end user. This is not something Linux distributions should
>> let users tweak. Its a hacker task.
>>
>> However, it is reasonable to force disable L0s, for example, completley on
>> the driver if it is known that L0s does not work for all chisets supported
>> on that driver.
>
> You didn't understand me.
>
>
> On my notebook, the AR5001 device is marked as pre 1.1 PCIE device.
>
> ASPM *is* enabled for both L0s and L1 by BIOS.
>
> Linux disables ASPM because the device is pre 1.1, and things work fine
> with no more patching (assuming that CONFIG_PCIEASPM is set)
>
>
> However, it is possible, (and that what I asked you) that some ath5k
> devices aren't 'pre 1.1 pcie devices' so linux won't disable ASPM L0s
> for them.
> So indeed for 'good feeling' it is ok to disable L0s from ath5k
> explicitly, but most of the time (or always) it will be no-op.

Sure, a no-op is fine given that it won't affect those devices. That
is why I ACKed the contents of the patch but not the commit log entry
description.

> In *addition* to that, since you said that ASPM L1 *does* work, and is
> enabled by BIOS, but linux disables it, that it might be worthy to
> enable it again from ath5k driver explicitly.
> As long as wireless works I don't really care if this done or not.

No, L1 isn't enabled on all devices, so best is to just keep what the
device has set and if the kernel knows better through the rules
mentioned before, let it disable it.

  Luis
