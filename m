Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2G1Vq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 17:46:58 -0400
Received: from keetweej.vanheusden.com ([80.101.105.103]:43675 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2G1Vq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 17:46:57 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2012 17:46:57 EDT
Date: Sat, 28 Jul 2012 23:38:33 +0200
From: folkert <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: problem with baycom driver
Message-ID: <20120728213832.GQ7638@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Jul 27 09:01:35 CEST 2012
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
 me with PGP!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems the baycom driver (for ham radio) needs some attention.
The problems:
- the baycom_ser_hdx driver does not work at all: very occasionally it
  switches the radio to send and transmit the data, but that's only one
  in thousand
- the baycom_ser_fdx does seem to send, but only 1 or 2 packets, then
  something odd happens: the radio does transmit something but it is not
  recognizable as data. it sounds like a couple of ticks, not the
  recognizable modem sound. Important: if I do a sethdlc command, it
  again does send 1 or 2 valid packets!

The system on which I try it, is a 3.2GHz p4 (with HT) so I don't think
it is a problem with the system not keeping up.
The pc is a:
        Manufacturer: IBM
        Product Name: 8215F7G
        Version: ThinkCentre M52

Things are setup like this:
/bin/setserial /dev/ttyS0 uart none
/sbin/modprobe baycom_ser_fdx 'mode=ser12*' iobase=0x3f8 irq=4
/usr/bin/sethdlc -i bcsf0 -a txd 200 slot 100 ppersist 40 half
/sbin/ifconfig bcsf0 hw ax25 FH1GOU-1 up

I played a little with the txd and does not help. Using full or half
does not make a difference so far that it looks as if the first part of
the packet is missing if I full duplex mode but I'm not entirely sure of
that (no second modem setup).
I verified the problem by listening with a second radio.


Folkert van Heusden
