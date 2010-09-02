Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0IBUMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:12:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46066 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab0IBUM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pIL4ReDJB6bsdO8qyf4P86REodV5Zp4tGb3Ow9bQ62vV7o61QrFP6A4mASQd4F+iKV
         NJC0fylWFQJ8iJVshG7NS9uej1UMM58PiE/xJKCvMLv/aYGTtwpKgkW1TL/HjhyY1bpe
         r1TklbhTGQZsZqtfi9jrykIeYH/uvt/z+jNPU=
MIME-Version: 1.0
In-Reply-To: <201008311126.45190.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<201008302333.22447.arnd@arndb.de>
	<20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
	<201008311126.45190.arnd@arndb.de>
Date: Thu, 2 Sep 2010 22:12:26 +0200
X-Google-Sender-Auth: P7NIKM-5fude4ba1wscRLwULOSk
Message-ID: <AANLkTinUjfWqEdOQoomR=TZnQEsiGj1wxvbv5c_MtZKp@mail.gmail.com>
Subject: Re: [RFC 0/5] tty: move stuff around
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier.adi@gmail.com>,
        Roger Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:26, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 31 August 2010, Alan Cox wrote:
>> > drivers/char/tty_*      -> tty/*
>> > drivers/char/{vt stuff} -> tty/vt/
>> > drivers/char/hvc_*      -> drivers/tty/hvc/hvc_*
>> > drivers/serial/*        -> drivers/tty/serial/*
>>
>> There are dead bits in there too we should prune 68xxx stuff mostly
>
> Geert, can you comment on the 68k serial drivers? Which
> ones are to stay, which ones can get phased out?

I don't know much about which drivers are still in active use. People
don't really
tell me ;-)

FWIW, if I use my Amiga's serial port, it's just for a serial console, in case
all else fails (last time I needed that was several years ago).

We have 3 "classes" of serial drivers:

  - generic_serial-based:

      o MVME147_SCC
      o MVME162_SCC
      o BVME6000_SCC
      o A2232

    All of these were marked BROKEN lately due to generic_serial,
while there's even a
    new ATARI_SCC under "active" development...

  - plain drivers/char:

      o SERIAL167
      o AMIGA_BUILTIN_SERIAL

  - drivers/serial:

      o SERIAL_PMACZILOG (Mac)

    Sun 3/3x support might be (re)added to SERIAL_SUNZILOG

On Mon, Aug 30, 2010 at 15:00, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Please don't convert stuff to serial_core - it's got some horrible
> problems with adapting to the new locking model, its buffering model
> pre-dates kfifo and all in all serial_core needs a rewrite not more users.

Funny... so "fortunately" we never found time to move the m68k serial drivers
to driver/serial/? Long live procrastination ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
