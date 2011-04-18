Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1DRLet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:34:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54793 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=c33iB1Avnhu6FRPCfkwgFhWQFugZDtVUI+AdZaa/PGHjj/z6MZAKbDXjtMm3WHI9cK
         hZCFQu38VBxO98PLw1mc3z4xGxbp0VsKH3m1fkE6TWrN+eZo81uEgGUpKYoWtPqbnZnJ
         k3+ADKpm5m6jfUlWyVjFzQyPfFKWfRH04TeNA=
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 13:34:42 +0200
Message-ID: <BANLkTimeOj3KvZw3+SM3WGH4dTJ8KvsPZA@mail.gmail.com>
Subject: Resume freezes laptop with Nova-TD Stick dvb-t tuner
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-dvb@linuxtv.org,
        linux-media@vger.kernel.org, Olivier Grenie <olivier.grenie@dibcom.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It seems like there is something broken with dvb-t driver.

Upon resume it requests firmware load - and this is freezing laptop.

usb 3-2: new high speed USB device number 2 using ehci_hcd
usb 3-2: New USB device found, idVendor=2040, idProduct=5200
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-2: Product: NovaT 500Stick
usb 3-2: Manufacturer: Hauppauge
usb 3-2: SerialNumber: 4031595310
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
lirc_dev: IR Remote Control driver registered, major 252
dib0700: loaded with support for 20 different device-types
IR LIRC bridge handler initialized
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
--
SUSPEND
RESUME
--
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
thinkpad_acpi: ACPI backlight control delay disabled
PM: resume of devices complete after 3537.435 msecs
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in cold state, will
try to load a firmware
thinkpad_acpi: fan watchdog: enabling fan
--


>From this discussion:

http://marc.info/?l=linux-kernel&m=130305862617225&w=2

firmware must be kept in memory - and not loaded from disk on resume.

Zdenek
