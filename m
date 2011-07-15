Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1GOOHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:07:38 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:40740 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1GOOHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:07:36 -0400
Date: Fri, 15 Jul 2011 15:07:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
        david <david@lang.hm>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
Message-ID: <20110715140724.GA29265@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
	david <david@lang.hm>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
References: <20110714163836.35a729c1@notabene.brown>
 <4E1E9372.3030208@redhat.com>
 <1310696606-sup-710@shiny>
 <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm>
 <20110715163354.74fa2083@notabene.brown>
 <1310728784-sup-9024@shiny>
 <4E20395C.1000301@redhat.com>
 <1310735821-sup-2589@shiny>
 <4E204139.5060702@redhat.com>
 <1310738205-sup-715@shiny>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1310738205-sup-715@shiny>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd3.lon.bitfolk.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Fri, Jul 15, 2011 at 10:00:35AM -0400, Chris Mason wrote:
    > Excerpts from Ric Wheeler's message of 2011-07-15 09:31:37 -0400: > > On
    07/15/2011 02:20 PM, Chris Mason wrote: > > > Excerpts from Ric Wheeler's
    message of 2011-07-15 08:58:04 -0400: > > >> On 07/15/2011 12:34 PM, Chris
    Mason wrote: > > > [ triggering IO retries on failed crc or other checks
   ] > > > > > >>> But, maybe the whole btrfs model is backwards for a generic
    layer. > > >>> Instead of sending down ios and testing when they come back,
    we could > > >>> just set a verification function (or stack of them?). >
   > >>> > > >>> For metadata, btrfs compares the crc and a few other fields
   of the > > >>> metadata block, so we can easily add a compare function pointer
    and a > > >>> void * to pass in. > > >>> > > >>> The problem is the crc can
    take a lot of CPU, so btrfs kicks it off to > > >>> threading pools so saturate
    all the cpus on the box. But there's no > > >>> reason we can't make that
    available lower down. > > >>> > > >>> If we pushed the verification down,
    the retries could bubble up the > > >>> stack instead of the other way around.
    > > >>> > > >>> -chris > > >> I do like the idea of having the ability to
    do the verification and retries down > > >> the stack where you actually
   have the most context to figure out what is possible... > > >> > > >> Why
   would you need to bubble back up anything other than an error when all > >
    >> retries have failed? > > > By bubble up I mean that if you have multiple
    layers capable of doing > > > retries, the lowest levels would retry first.
    Basically by the time we > > > get an -EIO_ALREADY_RETRIED we know there's
    nothing that lower level can > > > do to help. > > > > > > -chris > > > >
    Absolutely sounds like the most sane way to go to me, thanks! > > > > It
   really seemed like a good idea, but I just realized it doesn't work > well
    when parts of the stack transform the data. > > Picture dm-crypt on top of
    raid1. If raid1 is responsible for the > crc retries, there's no way to crc
    the data because it needs to be > [...] 
 Content analysis details:   (0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.0 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 15, 2011 at 10:00:35AM -0400, Chris Mason wrote:
> Excerpts from Ric Wheeler's message of 2011-07-15 09:31:37 -0400:
> > On 07/15/2011 02:20 PM, Chris Mason wrote:
> > > Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
> > >> On 07/15/2011 12:34 PM, Chris Mason wrote:
> > > [ triggering IO retries on failed crc or other checks ]
> > >
> > >>> But, maybe the whole btrfs model is backwards for a generic layer.
> > >>> Instead of sending down ios and testing when they come back, we could
> > >>> just set a verification function (or stack of them?).
> > >>>
> > >>> For metadata, btrfs compares the crc and a few other fields of the
> > >>> metadata block, so we can easily add a compare function pointer and a
> > >>> void * to pass in.
> > >>>
> > >>> The problem is the crc can take a lot of CPU, so btrfs kicks it off to
> > >>> threading pools so saturate all the cpus on the box.  But there's no
> > >>> reason we can't make that available lower down.
> > >>>
> > >>> If we pushed the verification down, the retries could bubble up the
> > >>> stack instead of the other way around.
> > >>>
> > >>> -chris
> > >> I do like the idea of having the ability to do the verification and retries down
> > >> the stack where you actually have the most context to figure out what is possible...
> > >>
> > >> Why would you need to bubble back up anything other than an error when all
> > >> retries have failed?
> > > By bubble up I mean that if you have multiple layers capable of doing
> > > retries, the lowest levels would retry first.  Basically by the time we
> > > get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> > > do to help.
> > >
> > > -chris
> > 
> > Absolutely sounds like the most sane way to go to me, thanks!
> > 
> 
> It really seemed like a good idea, but I just realized it doesn't work
> well when parts of the stack transform the data.
> 
> Picture dm-crypt on top of raid1.  If raid1 is responsible for the
> crc retries, there's no way to crc the data because it needs to be
> decrypted first.
> 
> I think the raided dm-crypt config is much more common (and interesting)
> than multiple layers that can retry for other reasons (raid1 on top of
> raid10?)

   Isn't this a case where the transformative mid-layer would replace
the validation function before passing it down the stack? So btrfs
hands dm-crypt a checksum function; dm-crypt then stores that function
for its own purposes and hands off a new function to the DM layer
below that which decrypts the data and calls the btrfs checksum
function it stored earlier.

> In other words, do we really want to do a lot of design work for
> multiple layers where each one maintains multiple copies of the data
> blocks?  Are there configs where this really makes sense?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "What are we going to do tonight?" "The same thing we do ---     
            every night, Pinky.  Try to take over the world!"            

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOIEmcIKyzvlFcI40RAr7bAJ9d7z0p7vr5PfFH7gDAnfwRZXGMEwCgi6GB
UeE95KcveYLaekGroq7zbYk=
=GW5L
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
