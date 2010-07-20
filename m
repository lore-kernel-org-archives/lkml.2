Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0GTLJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:09:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59467 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0GTLI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=RYk2Kb5HJoxdbg/R83A5jrtDb52RrWlO6Zd9t/d6zWrwcLvzI4BoQ8zoNquROOnbUh
         QxuNIALn9YjkadDPzuxSADayhKz93M2vfcy2Gofr6acUX4rtTvebNX0H1jJtPJxtshc4
         +2mig/yiE0KGczuv0bTcRjMOF9JBaYX+7Vc3Y=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTimAUG9DZpCyFBgf_XV9asj7ClBe2Lrjkh8tM0ll@mail.gmail.com>
References: <AANLkTim3VQ7afK91Opco06jzHJ35hHfn13heiXUp7YJ2@mail.gmail.com>
	<AANLkTimAUG9DZpCyFBgf_XV9asj7ClBe2Lrjkh8tM0ll@mail.gmail.com>
Date: Tue, 20 Jul 2010 12:08:56 +0100
Message-ID: <AANLkTikQ5GE4Ob1IAakEiwyWEGKTAL8Uox12jsSusJJl@mail.gmail.com>
Subject: Re: Blank (disconnected) screen during boot with latest 2.6.35-rcX 
	kernels
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xorg-driver-ati@lists.x.org,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 8:09 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Jul 19, 2010 at 5:50 PM, trapDoor <trapdoor6@gmail.com> wrote:
>> Dear kernel Developers,
>> I'd like to report a bug occurring on my machine with some of the
>> latest 2.6.35-rcX and the '-next' kernels. As I'm not sure what is the
>> problem related to I may have omitted relevant people among the
>> recipients. If it is so I'll be thankful if someone could cc them.
>> Also I must apologise for reporting this so late, when it's close to
>> the end of development cycle for 2.6.35.
>>
>> I didn't try to bisect. I've never done it before and maybe someone
>> will able to reproduce the problem or see straight what's going on by
>> looking into attached log/config files. But if it is necessary I'll
>> try my hand at bisecting.
>>
>> ******
>> Description of the problem:
>>
>> Affected kernels tested by me: 2.6.35-rc5-git3, 2.6.35-rc4-git5 and
>> 2.6.35-rc4-next-20100712.
>> Kernel 2.6.34.1 works OK.
>>
>> Briefly what happens is that my graphics card seems to loose
>> connection with the LCD screen (connected through DVI) during boot.
>> Initially it does show something - a blank screen with blinking cursor
>> but it lasts only for about 2-3 seconds and then the screen switches
>> to stand-by mode giving message 'No signal detected !'. The booting
>> process seems to continue though, and looking cursorily through
>> related dmesg and Xorg logs I can't see any suspicious messages
>> (comparing with the same logs produced when booting from working
>> kernel). I'm attaching the following files with this e-mail:
>>    dmesg, Xorg.0.log - produced during successful boot with 2.6.34.1
>>    dmesg.0, Xorg.0.log.old - these are for the failed boot with 2.6.35-rc5-git3
>>
>> Also please find attached config files:
>>     config-2.6.34.1 - for my current, working kernel
>>     config-2.6.35-rc5-git3 - based on above, almost all new entries I
>> left undefined/disabled during making 'oldconfig'; particularly I
>> didn't touch any options related to PCI, graphics drivers, ACPI or
>> power management - these should be all the same as in config-2.6.34.1
>>
>> All the kernels were compiled on the same PC and system, they have/had
>> radeon-kms enabled by default and these firmware files compiled in:
>> R600_rlc.bin, R700_rlc.bin
>>
>> ******
>> A brief specification of my system:
>>
>> 1) OS/software:
>>
>> Ubuntu 10.04, amd64
>>
>> Xorg, xserver, drm, mesa, drm and ati/radeon drivers installed from
>> the following Ubuntu PPA repository:
>> https://edge.launchpad.net/~xorg-edgers/+archive/ppa/
>>
>> Current versions:
>> xorg:  1:7.5+6ubuntu1~xorgedgers3~lucid
>> xserver:  2:1.8.2+git20100705+server-1.8-branch.665aa7ce-0ubuntu0sarvatt2~lucid
>> xserver-xorg-video-ati:  1:6.13.99+git20100716.cdeb1949-0ubuntu0sarvatt~lucid
>> xserver-xorg-video-radeon:  1:6.13.99+git20100716.cdeb1949-0ubuntu0sarvatt~lucid
>> drm:  1:2.4.20+git20100513.a3305b07-0ubuntu0sarvatt~lucid
>> mesa:  7.9.0+git20100718.4eaf591d-0ubuntu0sarvatt~lucid
>>
>> 2) Hardvare:
>> MB: Asus M4A79T Deluxe with chipsets AMD 790FX/SB750
>> Processor: AMD Phenom II X4 810
>> Graphics Card: Asus EAH3650 SILENT/HTDI/512M - based on chipset RV635
>> PRO, port PCIEx2, connected with LCD through DVI
>>
>> ******
>> Please let me know if anyone requires additional details and if there
>> is any tracking/testing I could do on my end.
>
> The driver is not able to detect any attached monitors with 2.6.35:
>
> [    1.980334] No connectors reported connected with modes
> [    1.980338] [drm] Cannot find any crtc or sizes - going 1024x768
>
> [    19.012] (II) RADEON(0): Output HDMI-0 disconnected
> [    19.012] (II) RADEON(0): Output VGA-0 disconnected
> [    19.012] (II) RADEON(0): Output DIN disconnected
> [    19.012] (II) RADEON(0): Output DVI-0 disconnected
> [    19.012] (WW) RADEON(0): Unable to find connected outputs -
> setting 1024x768 initial framebuffer
>
> I think the attached patch should fix the issue.  if not, can you try
> reverting b2ea4aa67bfd084834edd070e0a4a47857d6db59 ?
>
> Alex
>

Hi Alex,
Thanks for looking into this. I feel quite embarrassed that I didn't
notice those messages from my logs you quoted ..

Your patch (applied to 2.6.35-rc5-git3) has fixed the problem.
However, Xorg.0.log says now that:

[    17.780] (II) RADEON(0): Output HDMI-0 connected
[    17.780] (II) RADEON(0): Output VGA-0 disconnected
[    17.780] (II) RADEON(0): Output DIN disconnected
[    17.780] (II) RADEON(0): Output DVI-0 disconnected
[    17.780] (II) RADEON(0): Using exact sizes for initial modes
[    17.780] (II) RADEON(0): Output HDMI-0 using initial mode 1920x1080

... but there is no HDMI port in my card. It has 2 DVI's and one Video
output, that's all.
The card does support HDMI though, via DVI to HDMI adaptor. But
currently I've got
one monitor plugged directly into one of the DVI's - a yellow one,
where the other port
is white. There must be a reason that both ports are coloured
differently. Maybe the
DVI to HDMI adapter is supported only in the yellow DVI port and
that's why is recognised
as HDMI in my system?

Anyway, whether the Xorg log says true or not, it works fine for me,
no display issues and
resolution is set correctly. The only problem I see now is a
noticeable 3D performance
regression on this kernel (2.6.35-rc5-git3+your-patch) comparing to
2.6.34.1. I should make
some tests, gather details and send that in a separate report soon ..

-- 
Regards
trapDoor
