Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1FJSU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:20:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54085 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab1FJSU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VRoCSBlB7pLYfBICNzeb+Y5b72fwdPM2LcnHNSsrf7MpHrJm5AtQM+HNs/Pc78o2/L
         z49KgMfPdnQhXcNIAQqzSq3BZ6AnksZ81c+zdC8exm9M0MjCjQJsAGTIqvjCLtfubsLB
         cm9hjeS7ee+8BwPmuLWFF2MoM7U5BpFkZscEw=
MIME-Version: 1.0
In-Reply-To: <4DF25EAF.7050203@metafoo.de>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de> <20110610173004.GJ26441@sirena.org.uk>
 <4DF25959.9060603@metafoo.de> <20110610180256.GQ26436@opensource.wolfsonmicro.com>
 <4DF25EAF.7050203@metafoo.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Jun 2011 14:20:36 -0400
X-Google-Sender-Auth: heAyV8Fuj9GnNwJ7hdO3QccY2Wk
Message-ID: <BANLkTi=Hh7etBGCpfvhHc-76tgsyu3WSmQ@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [alsa-devel] [PATCH 2/3] ASoC: Blackfin:
 Add bf5xx-adau1701 machine driver
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 14:13, Lars-Peter Clausen wrote:
> On 06/10/2011 08:02 PM, Mark Brown wrote:
>> On Fri, Jun 10, 2011 at 07:50:17PM +0200, Lars-Peter Clausen wrote:
>>> On 06/10/2011 07:30 PM, Mark Brown wrote:
>>>> So, I keep on complaining about the way these drivers are just generic
>>>> to any random Blackfin plus CODEC combination rather than being board
>>>> specific.  It'd be good if we could improve this, even adding something
>>>> into the driver name to make it clear these are for the EVB would help.
>>
>>> I think this is due, that the codecs them-self sit on an add-on board to the
>>> bf5xx eval boards.
>>> So you have two boards, the bf5xx eval board with has the codec eval board
>>> connected to it. That's why it it is kept so generic. You could connect the
>>> codec eval board to any of the bf5xx boards.
>>
>> I'd be more happy with that if there were some indication in the code
>> that this was for the standard Blackfin EVBs rather than all systems
>> based on Blackfin.
>
> I could rename the machine driver to bf5xx-adau1701-evb for v2.

i'd like to get away from "bf5xx" actually and start using "bfin".
ive started doing this in some of the files, so let's not add more.

also, if we do decide to add more to the name, it should be closer to
what ADI calls the actual product, so probably "bfin-eval-adau1701".
although, once we push the SPORT # and I2C address to platform
resources, this should work for more than just the eval.  it'd fall
into our "basic blackfin" category, so we'd only tweak the Kconfig
desc/help text.
-mike
