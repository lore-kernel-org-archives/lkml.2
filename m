Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1CYVfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:35:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1CYVft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dPN+VEI2VAkeRdGQIClTcp5DSaK+kWy1hovUHW0iNRtRCriTDY0r4+sSjPCSbPfEfR
         p7uaUi9pxk5Ibf7zkSiYPBr7ffN8zOCsvE1qV7vSQx3oXb9RlCvzZ3IvCebMkuw3yeAe
         V8CODyCldrQHXOgflttg3X5yWjQHc4KuXH4/Q=
MIME-Version: 1.0
In-Reply-To: <4D8B4A89.80608@fusionio.com>
References: <4D8B4A89.80608@fusionio.com>
Date: Fri, 25 Mar 2011 22:35:47 +0100
X-Google-Sender-Auth: 1DSR74cdC2HZqCVZuOcMVm3MBis
Message-ID: <AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Thu, Mar 24, 2011 at 14:43, Jens Axboe <jaxboe@fusionio.com> wrote:
> Jens Axboe (20):
>      block: remove per-queue plugging

This one (commit 7eaceaccab5f40bbfda044629a6298616aeaed50) breaks IDE
on Atari/m68k under ARAnyM. It hangs on:

| ide: Falcon IDE controller
| Probing IDE interface ide0...
| hda: Sarge m68k, ATA DISK drive
| ide0 at 0xfff00000 on irq 15 (serialized)
| ide-gd driver 1.18
| hda: max request size: 128KiB
| hda: 2118816 sectors (1084 MB) w/256KiB Cache, CHS=2102/16/63

The next expected line is the partition parsing:

| hda: AHDI hda1 hda2

I tried reverting it, but it caused too many conflicts.
The parent of 7eaceaccab5f40bbfda044629a6298616aeaed50 works.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
