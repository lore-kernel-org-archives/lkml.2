Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1EIUDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:03:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1EIUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JlxY+uXasb1wodK44QFNGUxuDb7XX4DG64lw1C2z3sYRbbnUNoSQVPAOl9ML9skOUi
         WkIOnyoXtBg6J5vbjxiPBNSXF4rYTe/Il5b2butGDnYlvttK83VjA/WvAUcnosz+rILm
         Qu97Kzba5/bmnaS4ZDqIedXSDIP3pTPmh16WU=
MIME-Version: 1.0
In-Reply-To: <201105091350.43119.thomas@fjellstrom.ca>
References: <201105071815.03318.thomas@fjellstrom.ca>
	<201105091350.43119.thomas@fjellstrom.ca>
Date: Mon, 9 May 2011 16:03:16 -0400
Message-ID: <BANLkTik1NUc8Jaa4i_awNSbBHaMhW9FgqA@mail.gmail.com>
Subject: Re: long delay when using HMDI output on RS780
From: Jerome Glisse <j.glisse@gmail.com>
To: thomas@fjellstrom.ca
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 3:50 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> On May 7, 2011, Thomas Fjellstrom wrote:
>> I just switched to using HDMI with my media center, and its causing a 30+
>> second delay in the screen turning on, as well as a 7 second delay in the X
>> startup when it tries to fetch the EDID information. Basically I don't get
>> any picture at all once KMS initializes until after X has been up a few
>> seconds.
>>
>> The odd thing is the monitor seems to think something is going on, since it
>> doesn't go to sleep or display its "No Signal" OSD, but just after X starts
>> up, it pops up the "Input detected/switched" OSD, and the picture appears.
>>
>> The bios, grub2 (in both text mode and graphics mode), and the initial
>> linux kernel messages all display fine and immediately. Its only once KMS
>> and radeondrmfb initializes that there's a problem (at least till X starts
>> up).
>>
>> I've just built with a vanila 2.6.38.4 kernel from the stable git repo, and
>> have played with some EDID settings, trying to disable edid where I could
>> thinking thats what caused the problem. That doesn't seem to be the case
>> though. I also tried playing with the video= kernel option, trying to force
>> disable VGA-1, and set a static mode for HDMI-A-1, but if I try, it seems
>> to force disable HDMI-A-1 instead of force the mode.
>>
>> With a DVI-D cable instead, the problem goes away.
>>
>> Attached are the dmesg and xorg.log files for the latest boot with HDMI (no
>> video= parameter, and EDID enabled, most settings at defaults).
>>
>> What exactly would cause this, and is there a way I can fix it?
>
> I've been playing around with it more, and got it to not blank the screen
> after KMS init, /once/. So far no luck repeating that success.
>
> I've tried late, and early kms init, and currently have the radeon module and
> firmware compiled into the kernel. Boot times at least are fairly decent, about
> 8-10s till X starts, but about 25-35s till anything shows up.
>
> Some strangeness, I have the kernel set to force the hdmi output to on, with a
> very specific mode, that X tends to like, the vga port is forced disabled. X is
> set to ignore EDID, and also set to that specific mode that it tends to auto
> set itself. Regardless X still wants to pause for 7s 2-3 times while
> processing EDID info.
>
> I've attached the new dmesg and xorg logs from the latest attempts.
>
> Note, this only happens with KMS, with HDMI. disabling KMS, or using DVI makes
> the problem go away. Even grub's own graphical mode works fine, its only once
> KMS inits that things go bad, and its not till after X is up for a few seconds
> that something displays on my screen.
>
> --
> Thomas Fjellstrom
> thomas@fjellstrom.ca
>

Please boot with drm.debug=4 and attach dmesg it should be more
verbose. You might also want to try booting with radeon.audio=0

Cheers,
Jerome
