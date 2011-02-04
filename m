Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1BDICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:02:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48588 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1BDICt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n3XHi7D4DmWmp9YA0lXJvlRl5yzqkVTXBXvMf2wc8ipbHwT5M/boQJ7Vyji8O1QcHd
         vM/seZ4hrAdifamZi3jSZ9agTR/UGn+/p2S5RJiYUAyTmR1hX/plombc+nAWNYk0k3BA
         aFS3ON0OliuThV+5TLdf8YdYD1Os5UQtAHV2I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikG9vBDUcM=7pn+J4F-8DgUXX3M8fa2zjObXodS@mail.gmail.com>
References: <AANLkTikG9vBDUcM=7pn+J4F-8DgUXX3M8fa2zjObXodS@mail.gmail.com>
Date: Fri, 4 Feb 2011 09:02:48 +0100
X-Google-Sender-Auth: hPBUWdnWiZKjcCA2YsQon_FG6Rw
Message-ID: <AANLkTikx6SADQoh1F7yM43MyrULa7QxS215=ch5JWJad@mail.gmail.com>
Subject: Re: Sun GEM PPC32 Bug?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "R. Herbst" <ruediger.herbst@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/3 R. Herbst <ruediger.herbst@googlemail.com>:
> Ich habe vielleicht/hoffentlich einen Bug gefunden, der sich
> mindestens von Kernel 2.6.27 bis 2.6.37 befindet.

Probably I have found a bug, that's present in at least kernels 2.6.27
to 2.6.37.

> Ich versuche ihn mal so gut als möglich zu beschreiben.
> Meine verwendete Hardware:
> Apple PowerMac Dual G4 mit Sonnetupgrade auf 2x1.83GHz (7447A), Gentoo
> Linux (3 Wochen alt)

3 weeks old.

> ---
> cat /proc/cpuinfo
> processor    : 0
> cpu        : 7447A, altivec supported
> clock        : 1833.333326MHz
> revision    : 1.1 (pvr 8003 0101)
> bogomips    : 83.31
>
> processor    : 1
> cpu        : 7447A, altivec supported
> clock        : 1833.333326MHz
> revision    : 1.1 (pvr 8003 0101)
> bogomips    : 83.31
>
> total bogomips    : 166.63
> timebase    : 41658586
> platform    : PowerMac
> model        : PowerMac3,6
> machine        : PowerMac3,6
> motherboard    : PowerMac3,6 MacRISC2 MacRISC Power Macintosh
> detected as    : 129 (PowerMac G4 Windtunnel)
> pmac flags    : 00000010
> L2 cache    : 256K unified
> pmac-generation    : NewWorld
> Memory        : 2048 MB
> ---
> Solange der Datenverkehr relativ gering ist, gibt es keinerlei
> Probleme (unter 40MBit), wie beispielsweise eine SFTP von meinem IBM
> x345 auf meinen G4.

As long as network traffic is low (below 40 MBit), there's no problem.
For example using SFTP from my IBM x345 to my G4.

> Möchte ich mehr Durchsatz haben und nutze beispielsweise FTP (ca.
> 200MBit/s durchsatz), oder RSYNC (ca. 120MBit/s), dann bekomme ich in
> /var/log/messages folgende Meldungen angezeigt.

If I use more bandwidth, e.g. using FTP (200 MBit/s bandwidth), or RSYNC,
then I get the following messages in /var/log/messages:

> ---
> grep gem /var/log/messages
>
> Feb  3 19:51:35 G4 kernel: gem 0002:20:0f.0: eth0: Link is up at 1000
> Mbps, full-duplex
> Feb  3 19:51:35 G4 kernel: gem 0002:20:0f.0: eth0: Pause is disabled
> Feb  3 19:54:49 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:54:51 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:54:51 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:54:58 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:55:04 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[02010400]
> Feb  3 19:55:11 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:55:12 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00010400]
> Feb  3 19:55:16 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:55:25 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[02010400]
> Feb  3 19:55:26 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[02010400]
> Feb  3 19:55:30 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  3 19:55:32 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[02010400]
> ---
>
> Diese Meldungen können mehrfach pro Sekunde dann aufschalgen. Nach
> geringer Zeit (manchmal ein paar Sekunden, in besten Fall 1, 2
> Minuten) freezed dann das komplette System.

These messages can appear mutiple times per second. After a while (worst case
a few seconds, sometimes up to 1 or 2 minutes), the complete system freezes.

> Unter MacOS X 10.5 läuft mein Computer ohne jeglichen Probleme.
> Hardware ist völlig in Ordnung.

Under MacOS my computer runs fine. The hardware has no problems.

> Ich hatte vorher Debian versucht drauf zu installieren. Das System da
> ging sehr gut, solange man keinen Kernel mit SMP benutzt hat. Dann
> hakte die Tastatur und die Maus so dermaßen, dass ein arbeiten nicht
> mehr möglich war. Nur nebenbei erwähnt. Das ist der Grund warum ich
> Gentoo verwendet habe.

I also tried Debian. It worked well, as long as I used an SMP kernel.
Else the keyboard and mouse worked so bad they became unusuable.
That's why I went with Gentoo.

> Auf meinem Cisco 2960G Switch sehe ich leider auch keine Fehler.

I see no error messages on my Cisco switch.

> Ich hoffe, Sie können mir da weiter helfen.

I hope that you can help me.

> Rüdiger Herbst
>
> PS.: Sollten noch Fragen offen sein, beantworte ich diese gerne wenn möglich!

I you have any questions, feel free to ask!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
