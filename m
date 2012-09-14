Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2INObS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:31:18 -0400
Received: from mivlgu.ru ([195.20.195.134]:44448 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab2INObO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:31:14 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2012 10:31:13 EDT
Date: Fri, 14 Sep 2012 18:24:37 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Marti Raudsepp <marti@juffo.org>
Cc: Kernel hackers <linux-kernel@vger.kernel.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux network list <netdev@vger.kernel.org>
Subject: Re: tulip Ethernet driver messes up USB keyboard
Message-ID: <20120914142437.GD11919@newmaster.mivlgu.local>
References: <CABRT9RDdbqz6iscOz7BYwEQPOo8xfstfUZyBqVw44gmPsauLTg@mail.gmail.com>
 <CABRT9RCWU1RqpAay9iWPKwduejvkdk_CA2P_gV70iiEE2FS5HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <CABRT9RCWU1RqpAay9iWPKwduejvkdk_CA2P_gV70iiEE2FS5HQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 14, 2012 at 12:49:45PM +0300, Marti Raudsepp wrote:
> After installing an old 100Mbit PCI Ethernet card to my machine, it has
> complained a few times about spurious interrupts ("nobody cared") at a
> random time of the day. After the oops is reported, my USB keyboard (HP
> smart card keyboard) stops working properly -- it has lots of delay, it
> misses some keystrokes and also causes "stuck keys". Strangely enough my =
USB
> mouse continues to work without problems. Apparently the USB controller a=
nd
> the Ethernet card share an interrupt line. Un-/replugging the keyboard do=
es
> not help.
>=20
> So far I have simply rebooted to fix the issue. I haven't been able to
> reproduce this on will despite my best attempts.
>=20
> The Ethernet card is driven by the tulip driver and is listed as "ADMtek
> NC100 Network Everywhere Fast Ethernet 10/100 (rev 11)" in lspci. My
> motherboard uses the Intel H77 chipset (ASRock H77 Pro4/MVP)

This board uses the ASMedia ASM1083 PCIe-to-PCI bridge (or maybe ASM1085 -
hard to see from photos available on the net, and the PCI IDs for these
chips are the same), which is known to have problems with interrupt
handling:

  https://lkml.org/lkml/2012/1/30/216

I experience the same problem with ASUS P8P67 LE (except in my case the
interrupt is not shared with anything, and the network card does not stop
working completely, just gives horrible performance with > 100ms pings).

Some people use "noirqdebug irqpoll" as a workaround:

  http://lkml.indiana.edu/hypermail/linux/kernel/1204.1/03451.html

But this workaround basically turns off the protection against stuck
interrupts in the kernel, so the system could potentially be busy handling
a stuck interrupt forever.

You can also try to move the PCI card to another slot, so that it would
use another interrupt, which might be not shared with USB or another
important device.

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQUz4kW82GfkQfsqIRAoC7AJ9U9dq+xJINxEBPRnUUlYk9+JCHBACbBlMO
5tseIVosdhOry05Mhbr/PJg=
=icQx
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
