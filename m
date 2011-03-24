Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab1CXPBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:01:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1CXPB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ho0nFCoKiOxYf4mQjiGo2q918T6y5QoQKwPO5JaPEvHmnn999s+ayZeXpqzncbDm3b
         gayCuW5rVfCpWvEtTl5Y4yATa7xc5TPRe3kapPkkO1U1w2Be5+pAQtBbX+Kep8ZoZzam
         QRpl5+hYKj0usLFFkD2VN0e759WIH2q2NCZbQ=
Date: Thu, 24 Mar 2011 17:05:29 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: check device_create_file() return code in
 usb_create_sysfs_intf_files()
Message-ID: <20110324150529.GC8200@swordfish.minsk.epam.com>
References: <20110324143116.GA8200@swordfish.minsk.epam.com>
 <Pine.LNX.4.44L0.1103241050520.2006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1103241050520.2006-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (03/24/11 10:55), Alan Stern wrote:
> > I just noticed that usb_create_sysfs_intf_files() ignores device_create=
_file()=20
> > return code and sets intf->sysfs_files_created to 1, even if sysfs_add_=
file_mode()=20
> > returned -ENOMEM (or later sysfs_add_one() returned -EEXIST).
> >=20
> > Shouldn't we check retval for 0 before setting intf->sysfs_files_create=
d?
>=20
> No.  We want this routine to succeed even if the sysfs files can't be=20
> created.  The interface string attribute is more or less optional.
>=20
> It would be okay to add a comment explaining this, so that other people
> don't make the same mistake (which has already happened -- you're not
> the first).
>=20

Thanks. Sorry for the noise then.
Well, in that case, I guess, `int retval;' can be removed, since it's=20
unused.


Best,
	Sergey

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2LXbkACgkQfKHnntdSXjQ4/gQAh0ceVuLm40eM0nXgxx8N4Ngh
6QnGHs5SWjRRi/86N79/NOHnxf/bl8db2Q9/P5rv3UJratkd1OSQNjIxlE6TaXfa
1X0S9OtzWIx3HIoW9kXLBOaWfmF7kKNT6kA3iUfSbB9RO3YeCIHoNrRqtaPJAalX
TyJtE7scyS1qINanp9Q=
=l7X5
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
