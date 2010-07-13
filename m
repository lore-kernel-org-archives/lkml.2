Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0GMQhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:37:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51759 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0GMQhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rFfXRQK3P3Du7Rp3OequcHudufqJB/hba9UDdlYUhrHG67dTTr48z3ldcnJowZXUNG
         CztX0QkHuEG4SrqyvlmTP0A9wGmvaghMBZQ7ezi9JoynZ33H9nWtxAngnqzDKUaiplmN
         MyL/aH8kXrQbcJwJF379PnXaHW+hMViKWjRjg=
MIME-Version: 1.0
In-Reply-To: <1279037435.9846.17.camel@localhost>
References: <1279037435.9846.17.camel@localhost>
Date: Tue, 13 Jul 2010 12:37:01 -0400
Message-ID: <AANLkTil6WK0m6DowcjVGRSk-EMPZlW98AhgPHwlFkB0v@mail.gmail.com>
Subject: Re: 2.6.35-rc5 seems hangs at "[drm] Loading REDWOOD Microcode"
From: Alex Deucher <alexdeucher@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:10 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Hi.
>
> I gave 2.6.35 a try and the last message I see before the boot process
> seems to hang is something like:
> "[drm] Loading REDWOOD Microcode"
>
> I seem to have the microcode installed:
> $ ll /lib/firmware/radeon/RED*
> -rw-r--r--. 1 root root 5504  9. Apr 01:53 /lib/firmware/radeon/REDWOOD_me.bin
> -rw-r--r--. 1 root root 4480  9. Apr 01:53 /lib/firmware/radeon/REDWOOD_pfp.bin
> -rw-r--r--. 1 root root 3072  9. Apr 01:53 /lib/firmware/radeon/REDWOOD_rlc.bin
>
> I also did check these sides for a newer version:
> http://wiki.x.org/wiki/radeonBuildHowTo#TroubleshootingExtraFirmwareforR600.2BAC8-R700.2BAC8-Evergreen
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary
> http://people.freedesktop.org/~agd5f/radeon_ucode/
>
> But all versions seem to be from April 8.
>
> Booting with option "nomodeset" boots up the kernel correctly, but then
> the Fedora initram disk program dracut fails to open my luks devices
> (sda2+sda3) for some reason (I think I get a timeout and the message:
> "no root device found" appears). Booting without the options "quiet" and
> "rhgb" and with option "nomodeset" reveals in the kernel log that the
> disk and partitons sda1,2,3 are found by the kernel. I don't know what's
> going on here. Help appreciated!
>
> with kind regards
> thomas
>
> PS:
> I did put Alex Deucher in CC as he was the last person to change the
> file "drivers/gpu/drm/radeon/evergreen.c"
>
>

The microcode needs to be included in your initrd otherwise the driver
can't find it when it loads.

Alex
