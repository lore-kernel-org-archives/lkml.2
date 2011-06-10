Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1FJGGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:06:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab1FJGGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:06:04 -0400
Date: Fri, 10 Jun 2011 16:05:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110610160548.529797c7.sfr@canb.auug.org.au>
In-Reply-To: <20110609192243.GA3980@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
	<20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jun_2011_16_05_48_+1000_DYUVsR8WAGExXXZ."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jun_2011_16_05_48_+1000_DYUVsR8WAGExXXZ.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 9 Jun 2011 12:22:43 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jun 09, 2011 at 11:41:27AM -0700, Greg KH wrote:
> > > Also in several other files in drivers/staging/brcm80211/
> > >=20
> > > Also:
> > >=20
> > > drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
> > > drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE'=
 undeclared (first use in this function)
> > > In file included from drivers/staging/comedi/drivers/addi_apci_035.c:=
7:0:
> > > drivers/staging/comedi/drivers/addi-data/addi_common.c: In function '=
i_ADDI_Attach':
> > > drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error:=
 implicit declaration of function 'virt_to_bus'
> > >=20
> > > (Also several other occurrences of that one)
> >=20
> > I'll fix this up, it looks just like a #include that needs to be added.
>=20
> I've fixed all of these up, thanks for reporting them.

No, I still get these:

In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_ADDI=
_Attach':
drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: impli=
cit declaration of function 'virt_to_bus'

virt_to_bus is only defined for 32 bit powerpc (not 64 bit) (and maybe
not at all on some architectures e.g. sparc).

=46rom Documentation/DMA-API-HOWTO.txt:
"All drivers should be using these interfaces with no exceptions.  It
is planned to completely remove virt_to_bus() and bus_to_virt() as
they are entirely deprecated.  Some ports already do not provide these
as it is impossible to correctly support them."

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Jun_2011_16_05_48_+1000_DYUVsR8WAGExXXZ.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8bQ8AAoJEDMEi1NhKgbsA1oH/2db3MrLp+uo+NKJji4Rzydk
c4+0DUIiYbI7rHWVJK98/vfEdEnQbvT/Carl2ep6sJPXWgn0CH/PqlyVrzmH6Atd
ixQsv6RhEwnYrzlZV4opUZ6CKNXgyYcKXSAFV9F2kXxKgJ2BI1sNUSHQpoH4nAM4
Zr/OqtCzfVzCTcEctkuZ3Q3jU6nYY/jFaVnwM6nensnhY8ZzXGsmv30xNT8QfMY9
iGeV7zf+NOzy5gRhPMvVbhxI3ghTVbfDy1OmKjAAM7Z71+pXjumDL9WnamL7ASDc
VkKC0XiJ2GtwvuRyclDH/oET9mjGEALtDMO369T+sgMZ6/j9kJOzwRFRDW/s2zY=
=5VPQ
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jun_2011_16_05_48_+1000_DYUVsR8WAGExXXZ.--
