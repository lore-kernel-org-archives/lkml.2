Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2BIKEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:04:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:51457 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2BIKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:04:37 -0500
Date: Thu, 9 Feb 2012 13:06:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Arend van Spriel <arend@broadcom.com>, Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch complaint
Message-ID: <20120209100612.GA4204@mwanda>
References: <4F32E062.1020709@broadcom.com>
 <1328744534.6909.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1328744534.6909.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F339A31.0024,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2012 at 03:42:14PM -0800, Joe Perches wrote:
> On Wed, 2012-02-08 at 21:51 +0100, Arend van Spriel wrote:
> > checkpatch complains on code below and I must overlook something or
> > checkpatch gives a false negative/positive/whatever:
> >=20
> > #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
> > #define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
> > #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
> > #define IFEPDESC(usb, idx, ep)  \
> > 	(IFALTS((usb), (idx)).endpoint[(ep)]).desc
> >=20
> > checkpatch errors:
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #169: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:58:
> > +#define IFDESC(usb, idx)        (IFALTS((usb), (idx))).desc
> >=20
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #170: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:59:
> > +#define IFEPDESC(usb, idx, ep)  ((IFALTS((usb),
> > (idx))).endpoint[(ep)]).desc
> >=20
> > Any ideas? I tried extra parenthesis around IFALTS but that does not
> > resolve it.
>=20
> I think the entries should be surround by ()
> I think it's reasonable too.
>=20

No.  That's not reasonable.  The other code is:
A) perfectly fine
B) nicer to look at

We already have newbies running checkpatch.pl -f against the kernel
source and sending bogus patches that make the code uglier.  I've
tried to fight back against checkpatch patches before where they
make the code worse, but it's just overwhelming.  I don't like to
be the bad guy to tell newbies that they are sending bad patches
when actually the Official Kernel Checkpatch tool said they should
send it.  We're causing everyone pain for no reason.

regards,
dan carpenter

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM5qUAAoJEOnZkXI/YHqRB5AQAKXrURlIS6QBfLxVXupkX5KD
bwyGF3KrPEwwavaPNQv+L1cJqD63M8SGMomvhu0VvSJepVmH+cNRPWRImfgIe6qM
SXGQHEt6L/CQzmU2on2VURLF17QvxHsRWhGREaCjoTufRrCl91tTnTBXUW7/1mA9
wGoq8nNqqozvXbgmEiqGM1nUQ4gTn1SJMg0kza8fyON1QtqU88ZtiG2E6R28rhzL
aTQJTARJrPM4OKReJtoXIL8WK6zJCd791uLR9J0K41WuYbr4BJCSxqYp0vHO8R9a
BpfEZuAV9j73uFszarL6laIRYwO3Lzx3L2KIv9eqmug20Re/FsWX8peONC+iDAOA
SG+7KnvP/Lh6VCZ/p429thQlrjae4K7i65X8iB1vtqDwirhB+45ox9y/6BKstP+u
ZsztW+nuuxAShqXFL8ZfD6hhA9CTgYIKIxGPDWG9v6h550Rab/oM5ksmbkovuX5B
N8+2Ud3tWJVqKeaK9HvSTT7LZ0Qs2x7Hs7VA4ZzNmowtQRwej4lPIjc1WzVFJ6na
ZPzJ7qQnv7o89ooj+idoXPJ+OJrtLl5KAgfliUB3iSAvTF72cZsuxBMt5bp/z13Z
QfWcICzQhdd/skAsq8qoazswI69dYyK+yzIkWicsHsAKW3DcMkfR9M9+EWf5rJqJ
tXnoZCitk+Q8jTk3w7iZ
=c7/l
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
