Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab1FJSN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:13:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50049 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1FJSN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Nqv4RAyM/0BhXh8AfmTc7xJrnb+Tp3FFIC4/nKAQnOcpFDBpcgtwHfaEFTfeaOQo16
         t9lYIn8788PS3JNTuvOJV+6ljL49145MsAn3rQTwBmGAOWV4irLCsIeUWKWtHINWlITZ
         qKjwnYWQ0SyziGnScojNdTEU0DZube8B82JHE=
MIME-Version: 1.0
In-Reply-To: <20110610180137.GP26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de> <20110610173004.GJ26441@sirena.org.uk>
 <BANLkTimBJbkYJnU5vgmo+a5eerRroE1uBg@mail.gmail.com> <20110610180137.GP26436@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Jun 2011 14:13:05 -0400
X-Google-Sender-Auth: MqopDHwvCANwjWZg3fRrXXFHhEk
Message-ID: <BANLkTi=S2GayUj8-ctjbDOE_bcEb-6GtJQ@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [alsa-devel] [PATCH 2/3] ASoC: Blackfin:
 Add bf5xx-adau1701 machine driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 14:01, Mark Brown wrote:
> On Fri, Jun 10, 2011 at 01:47:34PM -0400, Mike Frysinger wrote:
>> On Fri, Jun 10, 2011 at 13:30, Mark Brown wrote:
>> > So, I keep on complaining about the way these drivers are just generic
>> > to any random Blackfin plus CODEC combination rather than being board
>> > specific.  It'd be good if we could improve this, even adding something
>> > into the driver name to make it clear these are for the EVB would help.
>>
>> i know you keep complaining, but i honestly dont understand why this
>> is undesirable.  connecting a codec to a Blackfin is pretty much
>> always the same.  you pick a SPORT # and that's about it.
>
> Only if you're looking at very basic boards - as soon as you start
> adding any external components on the boards like speaker amps, start
> handling jacks (with detection or without) or start dealing with more
> flexible CODEC devices with a wider range of connection possibilities
> the number of possibilities expands dramatically.

often times, people do have just basic needs, but i see what you mean.
 i want the base driver to be flexible enough to handle all the base
changes (diff SPORT num and perhaps addresses), but anything beyond
that i'd expect someone to write a custom driver.  perhaps renaming
the Kconfig description to be like "Basic Blackfin connection to XXX
Codec" would be sufficient ?  and then add a few more details to the
help text ?

>> the spi cs and i2c address could differ (so maybe make that a field
>> for the platform resources), but otherwise i dont see why people
>> should have to copy & paste the same code to change all of 4 bytes.
>
> Reusing code where there's similiarities is fine - Tegra is doing that
> for WM8903 based systems in a fairly tasteful fashion - but that's not
> really what this stuff feels like it is doing.  For example, the SPORT
> selection and reset GPIO selection should be platform data not Kconfig
> options and drivers that explicitly say they're for a particular board
> in Kconfig should probably say so in code also.

i absolutely agree with this 100%.  i keep banging on our guys to get
all Kconfig knobs thrown out and moved to proper resources, and some
of it has, but not all of it just yet.
-mike
