Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1EJVlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:41:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61361 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1EJVlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=APOIf2FT3Qc6Ksuf3coiZUoFhyDAvyZ936NKsMCFll3SI6riRfna3JasDIO8yRPDjg
         miZVx1/+Sy41VcR/v6n+bzxa9rQq/WE5Gm6w5Ey8Ew5PkSGi0gZOQpBFcDnzseriWSwb
         YJX/qjn3k4hrHfwY+gBxv+q7bh4YaPq/9TDKI=
MIME-Version: 1.0
In-Reply-To: <201105101237.49686.thomas@fjellstrom.ca>
References: <201105071815.03318.thomas@fjellstrom.ca>
	<201105092122.32284.thomas@fjellstrom.ca>
	<BANLkTindMJ9vYarD+cRoaHaFB60SrvX6hQ@mail.gmail.com>
	<201105101237.49686.thomas@fjellstrom.ca>
Date: Tue, 10 May 2011 17:41:02 -0400
Message-ID: <BANLkTi=wib9=MPVr=49YXqusVfbtDohFUQ@mail.gmail.com>
Subject: Re: long delay when using HMDI output on RS780
From: Alex Deucher <alexdeucher@gmail.com>
To: thomas@fjellstrom.ca
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 2:37 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> On May 10, 2011, you wrote:
>> On Mon, May 9, 2011 at 11:22 PM, Thomas Fjellstrom <thomas@fjellstrom.ca>
> wrote:
>> > On May 9, 2011, Thomas Fjellstrom wrote:
>> >> On May 9, 2011, Alex Deucher wrote:
>> >> > On Mon, May 9, 2011 at 5:04 PM, Thomas Fjellstrom
>> >> > <thomas@fjellstrom.ca>
>> >>
>> >> wrote:
>> >> > > On May 9, 2011, Thomas Fjellstrom wrote:
>> >> > >> On May 9, 2011, Jerome Glisse wrote:
>> >> > >> > On Mon, May 9, 2011 at 3:50 PM, Thomas Fjellstrom
>> >> > >> > <thomas@fjellstrom.ca>
>> >> > >>
>> >> > >> wrote:
>> >> > >> > > On May 7, 2011, Thomas Fjellstrom wrote:
>> >> > >> > >> I just switched to using HDMI with my media center, and its
>> >> > >> > >> causing a 30+ second delay in the screen turning on, as well
>> >> > >> > >> as a 7 second delay in the X startup when it tries to fetch
>> >> > >> > >> the EDID
>> >> > >> > >> information. Basically I don't get any picture at all once KMS
>> >> > >> > >> initializes until after X has been up a few seconds.
>> >> > >> > >>
>> >> > >> > >> The odd thing is the monitor seems to think something is going
>> >> > >> > >> on, since it doesn't go to sleep or display its "No Signal"
>> >> > >> > >> OSD, but just after X starts up, it pops up the "Input
>> >> > >> > >> detected/switched" OSD, and the picture appears.
>> >> > >> > >>
>> >> > >> > >> The bios, grub2 (in both text mode and graphics mode), and the
>> >> > >> > >> initial linux kernel messages all display fine and
>> >> > >> > >> immediately. Its only once KMS and radeondrmfb initializes
>> >> > >> > >> that there's a problem (at least till X starts up).
>> >> > >> > >>
>> >> > >> > >> I've just built with a vanila 2.6.38.4 kernel from the stable
>> >> > >> > >> git repo, and have played with some EDID settings, trying to
>> >> > >> > >> disable edid where I could thinking thats what caused the
>> >> > >> > >> problem. That doesn't seem to be the case though. I also
>> >> > >> > >> tried playing with the video= kernel option, trying to force
>> >> > >> > >> disable VGA-1, and set a static mode for HDMI-A-1, but if I
>> >> > >> > >> try, it seems to force disable HDMI-A-1 instead of force the
>> >> > >> > >> mode.
>> >> > >> > >>
>> >> > >> > >> With a DVI-D cable instead, the problem goes away.
>> >> > >> > >>
>> >> > >> > >> Attached are the dmesg and xorg.log files for the latest boot
>> >> > >> > >> with HDMI (no video= parameter, and EDID enabled, most
>> >> > >> > >> settings at defaults).
>> >> > >> > >>
>> >> > >> > >> What exactly would cause this, and is there a way I can fix
>> >> > >> > >> it?
>> >> > >> > >
>> >> > >> > > I've been playing around with it more, and got it to not blank
>> >> > >> > > the screen after KMS init, /once/. So far no luck repeating
>> >> > >> > > that success.
>> >> > >> > >
>> >> > >> > > I've tried late, and early kms init, and currently have the
>> >> > >> > > radeon module and firmware compiled into the kernel. Boot
>> >> > >> > > times at least are fairly decent, about 8-10s till X starts,
>> >> > >> > > but about 25-35s till anything shows up.
>> >> > >> > >
>> >> > >> > > Some strangeness, I have the kernel set to force the hdmi
>> >> > >> > > output to on, with a very specific mode, that X tends to like,
>> >> > >> > > the vga port is forced disabled. X is set to ignore EDID, and
>> >> > >> > > also set to that specific mode that it tends to auto set
>> >> > >> > > itself. Regardless X still wants to pause for 7s 2-3 times
>> >> > >> > > while processing EDID info.
>> >> > >> > >
>> >> > >> > > I've attached the new dmesg and xorg logs from the latest
>> >> > >> > > attempts.
>> >> > >> > >
>> >> > >> > > Note, this only happens with KMS, with HDMI. disabling KMS, or
>> >> > >> > > using DVI makes the problem go away. Even grub's own graphical
>> >> > >> > > mode works fine, its only once KMS inits that things go bad,
>> >> > >> > > and its not till after X is up for a few seconds that
>> >> > >> > > something displays on my screen.
>> >> > >> > >
>> >> > >> > > --
>> >> > >> > > Thomas Fjellstrom
>> >> > >> > > thomas@fjellstrom.ca
>> >> > >> >
>> >> > >> > Please boot with drm.debug=4 and attach dmesg it should be more
>> >> > >> > verbose. You might also want to try booting with radeon.audio=0
>> >> > >>
>> >> > >> Hi, attached both one with just drm.debug=4, and one with that and
>> >> > >> radeon.audio=0.
>> >> > >>
>> >> > >> Now, I'm guessing its a bug in my monitor claiming it can do HDMI
>> >> > >> audio? As setting radeon.audio=0 seems to have fixed the blanking
>> >> > >> problem. And the dmesg logs seem to claim that radeon thinks it can
>> >> > >> do HDMI audio.
>> >> >
>> >> > Most likely the driver is sending the wrong packets for hdmi audio.
>> >> > Until that gets fixed up, it's probably best to disable hdmi audio if
>> >> > it's not working for you.
>> >>
>> >> Ok. I'll do that for now, since I have no need for HDMI audio atm. My
>> >> receiver is only capable of Dolby Pro Logic input, so eh.
>> >>
>> >> Would be nice to fix the xorg pauses. And whatever is causing the
>> >> massive amounts of drm log spam (yes, I could disable drm.debug, but
>> >> that would just hide the issue, as whatever it is, will keep doing
>> >> whatever it is doing regardless).
>> >
>> > Any hints on where to look to fix the stalls when the xorg radeon driver
>> > starts up?
>>
>> Is the Xserver block or is it just that there is no picture ? ie when
>> you see somethings on the screen is it directly the gnome login screen
>> or what ever should come first ? or do you then see gnome loading ?
>>
>> If it's just black and then you directly got gnome-shell it's likely
>> that your tv doesn't live hdmi mode change and take time before
>> showing the picture.
>
> I can see X start up, the cursor shows up, but it just pauses for a few
> seconds, then once the wm is up, it pauses for a bit again.
>

Are you sure it's X/ddx and not kde or some desktop daemon
loading/polling things?  Does it pause the same way if you start plain
X with twm or an xterm?

Alex

> Here's some log info from Xorg that I think might be relevant:
>
> 7 second wait:
> [    16.161] (II) No input driver/identifier specified (ignoring)
> [    23.725] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
>
> 1 second:
> [    23.726] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602
> 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
> [    24.620] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
>
> 6 seconds:
> [    24.631] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602
> 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
> [    30.206] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
>
>
> It actually prints out the EDID information 5 times. Once at the beginning,
> and theres no discernible pause, then later on at the end, it prints out the
> EDID/DDC information 4 more times, with 3 pauses, once before the second print
> out, once between the second and third, and once between the fourth and the
> fifth.
>
> [    15.849] (II) RADEON(0): EDID for output HDMI-0
> [    15.849] (II) RADEON(0): Manufacturer: BNQ  Model: 790e  Serial#: 21573
> [    15.849] (II) RADEON(0): Year: 2009  Week: 6
> [    15.849] (II) RADEON(0): EDID Version: 1.3
>
> This is what led me to believe it might be related to EDID. Thought maybe
> there was some glitch causing kms+xorg to not like my monitor's EDID info, but
> it seems it likes it just fine, so much it asks for it 4+ times (kms looks,
> then x prints it out 5 times, possibly actually fetching it 3+ times).
>
> Also, I have it setup to auto boot into KDE without compositing enabled, using
> startx in an init script. I'm thinking of switching to icewm or something
> equally light weight, to see if maybe its KDE causing one of the pauses (it
> didn't used to pause like this, before I updated to 2.6.38).
>
> Last bit of info, my "TV" is actually a 24" 1080p LCD monitor.
>
>> Cheers,
>> Jerome
>
>
> --
> Thomas Fjellstrom
> thomas@fjellstrom.ca
>
