Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0LVXBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:01:06 -0500
Received: from frost.carfax.org.uk ([212.13.194.111]:1095 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0LVXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:01:04 -0500
Date: Wed, 22 Dec 2010 23:01:00 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Message-ID: <20101222230100.GB7736@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Andy Isaacson <adi@hexapodia.org>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20101220222446.GA8629@hexapodia.org>
 <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
 <20101222203915.GA9918@hexapodia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20101222203915.GA9918@hexapodia.org>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd0.lon.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Wed, Dec 22, 2010 at 12:39:15PM -0800, Andy Isaacson wrote:
	> On Tue, Dec 21, 2010 at 03:07:33AM +0200, Felipe Contreras wrote: > > On
	Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote: >
	> > I have a directory with 1.2M files in it, which makes readdir very slow
	> > > on btrfs with cold caches (although it's reasonably fast with hot caches
	> > > as in the first example below): > > > > Sounds like: > > > > Bug 21562
	- btrfs is dead slow due to fragmentation > > https://bugzilla.kernel.org/show_bug.cgi?id=21562
	> > Hmmm, how do I look at the btree layout for a given inode? [...] 
	Content analysis details:   (-0.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
	domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 22, 2010 at 12:39:15PM -0800, Andy Isaacson wrote:
> On Tue, Dec 21, 2010 at 03:07:33AM +0200, Felipe Contreras wrote:
> > On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> > > I have a directory with 1.2M files in it, which makes readdir very slow
> > > on btrfs with cold caches (although it's reasonably fast with hot caches
> > > as in the first example below):
> > 
> > Sounds like:
> > 
> > Bug 21562 - btrfs is dead slow due to fragmentation
> > https://bugzilla.kernel.org/show_bug.cgi?id=21562
> 
> Hmmm, how do I look at the btree layout for a given inode?

   There's documentation on the tree structures at [1] and [2]. If you
know the inode number of the object you're interested in, you need to
look in the FS tree for the subvolume it's in and find the
(inode_number, EXTENT_DATA, ...) keys for the file. Each of those
records will reference an individual disk extent -- and you can get
the disk start position and length of the extent from the data stored
under the key.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Btree_Items
[2] https://btrfs.wiki.kernel.org/index.php/Data_Structures

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hail and greetings.  We are a flat-pack invasion force from ---   
                     Planet Ikea. We come in pieces.                     

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNEoMsIKyzvlFcI40RAiPkAKDKw9Me4aEuC4JiIcBDzz7+z6jIpgCg0b+g
tCoSbY5Yz1aLYSY5QXEAt0Q=
=vT2Y
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
