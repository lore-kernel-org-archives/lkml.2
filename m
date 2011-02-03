Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1BCTsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:48:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32828 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab1BCTr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nRYEziO8aZghG/gzGgGA+nGNjRR7//wD2VswmOiDqyCS/Ul+YGhMdFHSUz0UzngAk9
         5tb2/LLvrjiBKPj5n4kS3QYOjKdxERR41/Ue1jj/5hDVoFL4baacpCH9KFIHPWIKnXxQ
         uwVjxUEzgGzqdU4ZL98ngndLuVwXDZlr+Blns=
MIME-Version: 1.0
Date: Thu, 3 Feb 2011 20:47:58 +0100
Message-ID: <AANLkTikG9vBDUcM=7pn+J4F-8DgUXX3M8fa2zjObXodS@mail.gmail.com>
Subject: Sun GEM PPC32 Bug?
From: "R. Herbst" <ruediger.herbst@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo.

Ich habe vielleicht/hoffentlich einen Bug gefunden, der sich
mindestens von Kernel 2.6.27 bis 2.6.37 befindet.
Ich versuche ihn mal so gut als möglich zu beschreiben.
Meine verwendete Hardware:
Apple PowerMac Dual G4 mit Sonnetupgrade auf 2x1.83GHz (7447A), Gentoo
Linux (3 Wochen alt)
---
cat /proc/cpuinfo
processor    : 0
cpu        : 7447A, altivec supported
clock        : 1833.333326MHz
revision    : 1.1 (pvr 8003 0101)
bogomips    : 83.31

processor    : 1
cpu        : 7447A, altivec supported
clock        : 1833.333326MHz
revision    : 1.1 (pvr 8003 0101)
bogomips    : 83.31

total bogomips    : 166.63
timebase    : 41658586
platform    : PowerMac
model        : PowerMac3,6
machine        : PowerMac3,6
motherboard    : PowerMac3,6 MacRISC2 MacRISC Power Macintosh
detected as    : 129 (PowerMac G4 Windtunnel)
pmac flags    : 00000010
L2 cache    : 256K unified
pmac-generation    : NewWorld
Memory        : 2048 MB
---
Solange der Datenverkehr relativ gering ist, gibt es keinerlei
Probleme (unter 40MBit), wie beispielsweise eine SFTP von meinem IBM
x345 auf meinen G4.
Möchte ich mehr Durchsatz haben und nutze beispielsweise FTP (ca.
200MBit/s durchsatz), oder RSYNC (ca. 120MBit/s), dann bekomme ich in
/var/log/messages folgende Meldungen angezeigt.
---
grep gem /var/log/messages

Feb  3 19:51:35 G4 kernel: gem 0002:20:0f.0: eth0: Link is up at 1000
Mbps, full-duplex
Feb  3 19:51:35 G4 kernel: gem 0002:20:0f.0: eth0: Pause is disabled
Feb  3 19:54:49 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:54:51 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:54:51 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:54:58 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:55:04 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[02010400]
Feb  3 19:55:11 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:55:12 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00010400]
Feb  3 19:55:16 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:55:25 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[02010400]
Feb  3 19:55:26 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[02010400]
Feb  3 19:55:30 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[00810400]
Feb  3 19:55:32 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
overflow smac[02010400]
---

Diese Meldungen können mehrfach pro Sekunde dann aufschalgen. Nach
geringer Zeit (manchmal ein paar Sekunden, in besten Fall 1, 2
Minuten) freezed dann das komplette System.
Unter MacOS X 10.5 läuft mein Computer ohne jeglichen Probleme.
Hardware ist völlig in Ordnung.

Ich hatte vorher Debian versucht drauf zu installieren. Das System da
ging sehr gut, solange man keinen Kernel mit SMP benutzt hat. Dann
hakte die Tastatur und die Maus so dermaßen, dass ein arbeiten nicht
mehr möglich war. Nur nebenbei erwähnt. Das ist der Grund warum ich
Gentoo verwendet habe.

Auf meinem Cisco 2960G Switch sehe ich leider auch keine Fehler.

Ich hoffe, Sie können mir da weiter helfen.

Rüdiger Herbst

PS.: Sollten noch Fragen offen sein, beantworte ich diese gerne wenn möglich!
