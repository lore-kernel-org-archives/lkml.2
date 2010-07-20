Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724Ab0GTWAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:00:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39242 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0GTWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=hvOXH4ZOGrhuAvB0ACtb2KL84AGCd7aLQoV7e5TNPxyhixWph3HbX4nSicbOMGqVyA
         TSxUGweCDHnK+0kk7K6FUilOW7H6E+SjI/puYOk4TVItTJiICyNnr7fZkNuIv2gC8Pno
         EDZEAR+GyoR0hfvKUB2fGWPrAKnynib62c/bg=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTimuBRwuD0MjtzZyd--2JSUfWejuYb7t-GE6oK3T@mail.gmail.com>
References: <AANLkTim3VQ7afK91Opco06jzHJ35hHfn13heiXUp7YJ2@mail.gmail.com>
	<AANLkTimAUG9DZpCyFBgf_XV9asj7ClBe2Lrjkh8tM0ll@mail.gmail.com>
	<AANLkTikQ5GE4Ob1IAakEiwyWEGKTAL8Uox12jsSusJJl@mail.gmail.com>
	<AANLkTik87QXCEHgG8ph6ehfFo1yvCvRz7JbvaC_uKWJd@mail.gmail.com>
	<AANLkTiljMvaCttFAI_GoajBHwK9OHS5MPmx1P6_qDOdY@mail.gmail.com>
	<AANLkTimuBRwuD0MjtzZyd--2JSUfWejuYb7t-GE6oK3T@mail.gmail.com>
Date: Tue, 20 Jul 2010 22:54:10 +0100
Message-ID: <AANLkTinXCIfB94WXHtS7cej_8zi8n_hqjtVsZsOCTmqk@mail.gmail.com>
Subject: Re: Blank (disconnected) screen during boot with latest 2.6.35-rcX 
	kernels
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xorg-driver-ati@lists.x.org,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The attached patch should fix the connectors to report properly.
> There are a number of similar ASUS cards with the same quirk.
>

Right. I have applied your second patch on top of 2.6.35-rc5-git4 +
0001-drm-radeon-kms-fix-shared-ddc-harder.patch

After successful boot from the new kernel, these lines in Xorg.0.log
corresponds now to the outputs I have on my card:

### for LCD connected to the first DVI port:
[    19.582] (II) RADEON(0): Output DVI-0 connected
[    19.582] (II) RADEON(0): Output DIN disconnected
[    19.582] (II) RADEON(0): Output DVI-1 disconnected
[    19.582] (II) RADEON(0): Using exact sizes for initial modes
[    19.582] (II) RADEON(0): Output DVI-0 using initial mode 1920x1080

### LCD connected to the other DVI port:
[    18.068] (II) RADEON(0): Output DVI-0 disconnected
[    18.068] (II) RADEON(0): Output DIN disconnected
[    18.068] (II) RADEON(0): Output DVI-1 connected
[    18.068] (II) RADEON(0): Using exact sizes for initial modes
[    18.068] (II) RADEON(0): Output DVI-1 using initial mode 1920x1080

HDMI output isn't listed any more. So that's seems good. Thanks a lot
for fixing this.

I'm just wondering now what will happen if I connect some HDMI device
via DVI > HDMI adaptor. Should it work? Is HDMI still supported on my
card after applying the last patch? Unfortunately I don't own any
device I could test it on.

Do you expect any problems with applying this patch onto 2.6.34.1? If
not, I could do it as on that kernel the first DVI port is still shown
as HDMI. If the patch works OK on 2.6.34.1, it could be submitted
upstream to the stable branch ?

>>
>> Where I see a real 3D performance drop now is for example Armagetron
>> Advanced - a game I use just for testing. I enabled certain features
>> using 3D in it. Without going into details I just say that with kernel
>> 2.6.34.1 the overall 3D performance in AA is about twice better. The
>> game runs quite smooth, number of fps doesn't go under 60. With kernel
>> 2.6.35-rc5-git3 on the same system, with the same drivers, mesa, drm
>> etc., the game runs slower and not so smooth, certain details look
>> slightly worse and I won't get more than 35 fps.
>>
>> Apart from that I don't notice any regressions on my desktop, with
>> compiz effects etc. I'd run some other tests if you could recommend
>> some tools, but not too complex and rather some specialised software
>> just for testing purposes, not games.
>
> If it's just the kernel that changed is there any chance you could
> bisect what caused the performance regression?
>

I could find some time for bisecting tomorrow around evening. Prior to
that I'd need a quick look into some manuals ..


-- 
Regards
trapDoor
