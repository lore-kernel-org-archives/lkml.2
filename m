Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793Ab2CPOYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:24:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46953 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2CPOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:24:52 -0400
Date: Fri, 16 Mar 2012 17:26:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120316142649.GJ3163@mwanda>
References: <1331858893-775-1-git-send-email-kys@microsoft.com>
 <1331858925-827-1-git-send-email-kys@microsoft.com>
 <20120316054556.GH3163@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B7666A2@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120316071858.GH3220@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B76671F@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9faIjRurCDpBc7U"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B76671F@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F634D20.00A1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+9faIjRurCDpBc7U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 01:14:07PM +0000, KY Srinivasan wrote:
> Dan,
> I am trying to understand your concern here:
> You will agree with me that the current code does not overflow the=20
> buffer since the output is limited to MAX bytes and that is how=20
> big the output buffer is sized. Now, as I pointed out earlier, if the
> string to be converted were to fully occupy the MAX bytes or even be
> larger than MAX bytes (no buffer overflow here since we limit the
> conversion to MAX bytes), we will get a malformed packet that will be
> sent to the host since the size field of the message would exceed
> the protocol specified size limit. I was merely pointing out that in
> this case, I would rather have the host reject the message than send
> a truncated Key/Value string (if we were to ever get invalid key or
> value strings).=20
>=20

Sending malformed packets is a bad idea.

Normally, if you handle the error as close to the cause of the error
as possible then it makes everything easier to read.  In this case
especially, it's so easy to catch any errors.  If you decide to go
ahead and send the malformed message, at least put a comment.

When I read code, I spend all my time looking for what it does
wrong.  So when code doesn't have any error handling and sets
keylen =3D -EINVAL then sure, it's fewer lines of code to read, but
it doesn't make my life easier.  Readable code has obvious error
handling.

Introducing off by one errors is an especially bad idea.  It doesn't
matter how harmless they are, because they end up getting copy and
pasted.  I don't know how to make it any clearer than that.  :/
Never never never do that!

regards,
dan carpenter


--+9faIjRurCDpBc7U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY02pAAoJEOnZkXI/YHqRDEoP+gKhaThrvNOFUEb7aWMq1ilE
SI1nqWD7mBeDdYxDKtyv/kexXXWaGirkBFkR0uxNI3ZVBqdLByl0HYSqoqzAhy2b
yjI3RNSJ5NVA4TJfUcsIGHztCFNsk/ODBSSnpzkEON18kzutblZmZFlRIHxlRgc4
7EZ9b4u+U/l/EL6hmOnO2jM7ZQqnTJhJdzWIvbFE+a7tK9/azuwVKotBUOvtb6eY
StBbJfVSXg/GUyX03aABpsJfzpTuaeDKx7XT/ZBVgk1RtP4naMYXU4DMMuwOBw5S
BNPY5bGIEgQcma0/y127peqTQJWgRKTKYBHTx/uPYuIzvC/2XpeHwqIg5uFk4ThT
v+RPInkEaiG+s5mn4eHbHEzyzY7AboYpaKt8C4FGJLSRfN1CGnAgYp1CGnDhHEPm
5mpcGu1UrjSEM1CiWWOqSra8cWCucFjsIb7hX/VbxYiJHwq7OFKGxyEVM/gRmzea
/zMN3S1EPPmRPvtg56vhyxMINSMH0vMQfjMtLeH6o/KMwT8TASIWMugFwN7P4qQt
QuwPqU1k8MJXfmM2SY3kZ2klRMRlCc6VvZwqjryeDm3D8RjRcsG1iUL2A+b4jij3
0RkP9qqujx5Mccy3/sMbfcqZPtG2LuKYGNHFSZLdtJpJOdhwQY+6vAvJ5+JufWKa
gbJWkgdlXgNTTlBbkb78
=EXNg
-----END PGP SIGNATURE-----

--+9faIjRurCDpBc7U--
