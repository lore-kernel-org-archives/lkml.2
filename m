Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1LMS1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:27:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:51150 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1LMS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:27:49 -0500
Date: Tue, 13 Dec 2011 21:27:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dan Luedtke <mail@danrl.de>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: prism: coding style fixes, removed
 space-indentations
Message-ID: <20111213182752.GH3503@mwanda>
References: <1323776137-458-1-git-send-email-mail@danrl.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfTAc8Cvt8L6I27a"
Content-Disposition: inline
In-Reply-To: <1323776137-458-1-git-send-email-mail@danrl.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EE7991C.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pfTAc8Cvt8L6I27a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 12:35:37PM +0100, Dan Luedtke wrote:
> Fixed some coding style issues. Converted multiple spaces to tabs.
>=20

Multiple spaces are allowed.  See below.

> (Please provide feedback on problems, it's my first kernel patch ever)

Everyone's first patch is rejected, so don't feel bad.  :)  Btw put
these kind of comments which you don't want in the permanent git log
under the --- dashes.  git am removes that information.

>=20
> Signed-off-by: Dan Luedtke <mail@danrl.de>
> ---
>  drivers/staging/wlan-ng/prism2fw.c |  190 +++++++++++++++++++-----------=
------
>  1 files changed, 99 insertions(+), 91 deletions(-)
>=20
> diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng=
/prism2fw.c
> index 3c40096..e035839 100644
> --- a/drivers/staging/wlan-ng/prism2fw.c
> +++ b/drivers/staging/wlan-ng/prism2fw.c
> @@ -172,13 +172,14 @@ static int read_cardpda(struct pda *pda, wlandevice=
_t *wlandev);
>  static int mkpdrlist(struct pda *pda);
> =20
>  static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
> -	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
> +	struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
> =20
>  static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
> -	     struct s3crcrec *s3crc, unsigned int ns3crc);
> +				struct s3crcrec *s3crc, unsigned int ns3crc);
> =20
>  static int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
> -	       unsigned int nfchunks);
> +							unsigned int nfchunks);

It looks like you've tried to make everything aligned with the right
hand side of the screen.  I think that's the first time I've seen
someone do that.  I don't think it's normal.

> +
>  static void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks);
> =20
>  static void free_srecs(void);
> @@ -200,23 +201,23 @@ static int validate_identity(void);
>  * Returns:
>  *	0	- success
>  *	~0	- failure
> -----------------------------------------------------------------*/
> +*----------------------------------------------------------------*/

There is a normal kernel comment style described in Chapter 8 of
Documentation/CodingStyle.  Or for documenting function parameters,
if you want to be super awesome you could use kernel doc format.
Documentation/kernel-doc-nano-HOWTO.txt

Btw, if you do something complicated with comments, that should be
sent as a separate patch.

>  int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
>  {
>  	const struct firmware *fw_entry =3D NULL;
> =20
>  	printk(KERN_INFO "prism2_usb: Checking for firmware %s\n",
> -	       PRISM2_USB_FWFILE);
> +		PRISM2_USB_FWFILE);

The original is fine here.  It uses tabs as far as possible and then
spaces to make it align with the start of the function.  Same for
the rest below.

> @@ -951,7 +958,8 @@ int read_fwfile(const struct ihex_binrec *record)
>  			s3data[ns3data].data =3D (uint8_t *) record->data;
>  			ns3data++;
>  			if (ns3data =3D=3D S3DATA_MAX) {
> -				printk(KERN_ERR "S3 datarec limit reached - aborting\n");
> +				printk(KERN_ERR "S3 datarec limit reached"
> +					" - aborting\n");

printks are allowed to break the 80 character limit.  checkpatch.pl
won't complain about this.  We might want to grep for the string and
breaking up the lines makes that harder.

You could do something like:
			printk(KERN_ERR
			       "S3 datarec limit reached - aborting\n");
This one would fit under the limit like that, but I would probably
just leave it as is.

regards,
dan carpenter



--pfTAc8Cvt8L6I27a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO55knAAoJEOnZkXI/YHqR6yUP/1zAxhMipPjrWkEi1fHUQ8Xc
lPFh/Opg0zl4MayDtCqjqaFsyv6w45RQDnhQrBfWJkAlGHiV/9XPd3UE8YGVHPNC
sRaO7a7PHSMayBPY4fhsI/jcDraKzakVi+56+ycVNoGd3xKPwJLxpDmT4GEBp9Ad
wMLeZ87ZGoiMhAnhiGK4tQ8YtYRh19nihPnowGH+SmKMqxrZ9eNB2v8F5YA401uk
OeO9mSs/1XEhpeMjDOPKzyLad7OJSu9wmiLx3SDXZodnfDAyuQKPyB5QnedJUdCG
iO8yrMO9pmNJvjmyDA6FQetgx2Fq9CV7XgK7XE6iHu5T4hlkYOJuXiserxdXSyZ0
OBksFKLiwsf/gVLSnpuob6OU/or6YzKmnxHTIM8b8/KI/BhW0UTeMs3LciIizmbk
GwURhwndZ5HRvfIJ2Ae0kejkniaVCyjBAlzIEXjPUoE43QBLaPDC8vjomAA6gWj4
OuQ32TBnl5Q97fHFsPmvoYltESEZBE3pW4+aXXagASAYkdScMc37P7hc9cPVCZcd
p9EnbJd9c1vpLIyPEnNoqF33Qwz9hohOU2OCGtk5LLjCjDBkz+f84wiynDb5jgVX
Zbqnil8KcvMgJ6cwSA5SGn5vX0CD062mW1TJNphJkptD0OMio7X43+L0nmfbU3Nu
URf0s1Mnk47nTOPz9tZY
=EGfP
-----END PGP SIGNATURE-----

--pfTAc8Cvt8L6I27a--
