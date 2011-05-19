Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab1ESSSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:18:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997Ab1ESSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Gk7o3aafAO4dCngwCBz3ML+UZlPWZ7p4w5FrAimhyTuq13NpGWuf3RtREbZ2e4OeUl
         UnbPnVzOvvHIAuowORtMqQhN7iuzjkNhyoBUvTKbulfP3JBM3MFMWTiLhqLcrI5r9/OY
         BuVG4MM5sBdi+PoYUkxTC8z8sNqnFQbWC6WTs=
MIME-Version: 1.0
Date: Thu, 19 May 2011 20:18:16 +0200
Message-ID: <BANLkTikwjL-3m110CcRs+-KLdZpH0rOTsQ@mail.gmail.com>
Subject: samsung-laptop backlight control not working
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, mjg@redhat.com,
        David Herrmann <dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tried the new samsung-laptop driver with samsung backlight support.
It is detected as:
[109282.931433] samsung_laptop: found laptop model 'N150P/N210P/N220P'

However, backlight support is kind of weird:
"echo 1 >/sys/class/backlight/samsung/brightness"
does not set brightness to 1 but instead reduces brightness for 1.
That is, if my current brightness setting is 8, I need to call "echo 1
>..." 7 times to get brightness value 1.

"cat /sys/class/backlight...."
returns 1 after the first try, though.

"echo 3 >..."
reduces brightness also for 1 but stops at brightness level 3 if I
repeat the command.

dmesg shows the following for every "echo" I call:
[110690.073783] ACPI: Failed to switch the brightness

Furthermore "echo 0 >..." doesn't disable backlight but instead
behaves like a brightness setting below 1.


However, I know the following works on my machine:
setpci -s 00:02.0 F4.B=255
It accepts a setting between 0-255 and 255 is full brightness and 0 is
backlight off.


Regards
David
