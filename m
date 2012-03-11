Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2CKSrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 14:47:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18077 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2CKSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 14:47:05 -0400
Date: Sun, 11 Mar 2012 21:49:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120311184916.GD3337@mwanda>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-1-git-send-email-kys@microsoft.com>
 <1331422331-4381-2-git-send-email-kys@microsoft.com>
 <20120311104230.GC3337@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B75B403@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F5CF318.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 11, 2012 at 04:56:06PM +0000, KY Srinivasan wrote:
> > Probably that's not enough to make a difference and we'd need to
> > introduce a new function.
> >=20
> > Btw I don't know if utf16s_to_utf8s() counts the NUL char or not.
> > It feels like maybe we could end up with ->value_size equal to
> > HV_KVP_EXCHANGE_MAX_VALUE_SIZE + 1.
>=20
> The MAX value is set to accommodate the maximum string that will ever
> be handled including the string terminator. The function utf16s_to_utf8s()
> returns the converted string length but the returned length does not=20
> include the string terminator (like strlen), hence the "+1".
>

sprintf() and friends copy the NUL terminator but utf16s_to_utf8s()
doesn't so the code isn't right and it does seem like maybe we could
end up with a ->value_size equal to HV_KVP_EXCHANGE_MAX_VALUE_SIZE +
1.

regards,
dan carpenter

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXPOrAAoJEOnZkXI/YHqRDjcP/iEOJI2GimnGoVNHq4rgmEAq
r7IgrcP7ZpzE1PFkUHo0jKBJAb0E3LMxALZpbqZhx0uCXlrIhJEnkpG6j1xp9xG8
J4s+H7YDrMhaVxaOxZMyqSvXxz6dnafi5nQ/jn/t+arUhJHEqhGfWXfqzaLoF/Sm
2DVRhYYi9Hy4Eb18jZt4oQhlrlv6nsRrd53WFEQip8a792IBFtFYrlo/j+5lQaof
XpZKMtbUObYQHPlNPMQ33rsR22fP8gtBGc8MUSh67GwpIcyAU1VZozVxqiLg76RR
iik1k7V7An36tqJMGRwVewYs7kh7q0hhPAZt8hGq56UaYRVWAwGdU62M+nWNuyBk
sfXkdlvsIz7cFWIboiI6o1u4XFwx2pOyEQh5NVop1c5cNcNCrwRNBNFcrSua7teU
H8uDQlf9v3N5jIletrnWxd8XmLNdt2nTC1nxHvAIOdtbLbmEQQgAES41hs1WteuC
PPZlR/0q3wUJ66/X4d4LooUEh/r6mKC3T+O32wKAbc31lh95RgsST1RS3lVjoORq
ztxUMM3OwixdZ/fsKjx/niDgQpc78K03WdycbhWwbXXRXQLy32TL3w+5hPdGIgoN
Pz50GTk+ahQcuGBAj7aUuQ6XDTq16tUL/NcgUWvqPdjT9B+IZa315M2KW3Xu4SEE
JuckEG/hJTwt66GLVs/Y
=sMqU
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
