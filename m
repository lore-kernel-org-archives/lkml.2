Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1BMQbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:31:51 -0500
Received: from frost.carfax.org.uk ([212.13.194.111]:3683 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1BMQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:31:44 -0500
Date: Sun, 13 Feb 2011 16:31:42 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Marti Raudsepp <marti@juffo.org>
Cc: btrfs hackers <linux-btrfs@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP
 bug?
Message-ID: <20110213163142.GA5484@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Marti Raudsepp <marti@juffo.org>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd2.lon.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Sun, Feb 13, 2011 at 05:49:42PM +0200, Marti Raudsepp wrote:
	> Hi list! > > It seems I have found a serious regression in compressed btrfs
	in > kernel 2.6.37. When creating a small file (less than the block size)
	> and then cp/mv it to *another* file system, an appropriate number of >
	zeroes gets written to the destination file. Case in point: [...] 
	Content analysis details:   (-0.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
	domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 13, 2011 at 05:49:42PM +0200, Marti Raudsepp wrote:
> Hi list!
> 
> It seems I have found a serious regression in compressed btrfs in
> kernel 2.6.37. When creating a small file (less than the block size)
> and then cp/mv it to *another* file system, an appropriate number of
> zeroes gets written to the destination file. Case in point:

[snip]

> I'm currently running on 2.6.37, x86_64 using Arch Linux -testing with
> coreutils 8.10. Filesystem is mounted from LVM2 to /usr/src with -o
> noatime,compress
> 
> This only seems to occur with compressed file systems (either zlib or
> LZO). A person on IRC also reproduced the same problem in 2.6.28-rc.
> I'm pretty sure this used to work correctly around 2.6.35 or 2.6.36.

   This would seem to be the same effect that we've had reported on
IRC by at least two Gentoo users, of files full of zeroes in their
build system. We'll follow up with them over there and see if it's the
same bug.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I must be musical:  I've got *loads* of CDs ---           

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNWAdtIKyzvlFcI40RAh4EAKCFpHiqBlqrI9ypiD+H4c3PqN3HcwCgyKeV
vvKGo7n+pm2T6RIZcmzf17A=
=24mt
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
