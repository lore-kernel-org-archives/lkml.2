Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0EPTaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:30:11 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.50]:39127 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab0EPTaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:30:09 -0400
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Alexander Kurz <linux@blala.de>
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
Date: Sun, 16 May 2010 15:30:04 -0400
User-Agent: KMail/1.9.9
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <201005142029.37408.fmhess@speakeasy.net> <alpine.DEB.1.10.1005151601510.26254@blala.de>
In-Reply-To: <alpine.DEB.1.10.1005151601510.26254@blala.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1911512.ZCiRrP2smK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005161530.07363.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1911512.ZCiRrP2smK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 15 May 2010, Alexander Kurz wrote:
> Hm, I cannot see a build-dependancy from any of the PCMCIA-Modules
> to 8255.c. All PCMCIA-modules do build and load fine without compiling
> 8255.c. There is a dependancy from das08_cs (PCMCIA) to das08 (ISA) via
> config COMEDI_DAS08_CS select COMEDI_DAS08.
> This will lead to a hidden select of COMEDI_DAS08 when
> COMEDI_ISA_DRIVERS is not enabled.
> Is there something that I have missed?

All the drivers that include 8255.h depend on the 8255 module.  They still=
=20
compile without it because 8255.h provides stubs that automatically drop=20
support for the 8255 chips from the other drivers if the 8255 module is=20
not selected.  IMO, the stubs are not particularly valuable and with the=20
fine-grained driver selection will just result in confused users with=20
reduced functionality drivers.


--nextPart1911512.ZCiRrP2smK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBL8Ee95vihyNWuA4URAvu+AKCMYayz3mU8VPGTRwJW0kzpZHRRawCgrzq6
/Tl/oE3FV8c5cewdoxZVlgI=
=26cf
-----END PGP SIGNATURE-----

--nextPart1911512.ZCiRrP2smK--
