Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0JDIr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:47:29 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58176 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0JDIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:47:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Swsusp patches applied to suspend-2.6#linux-next
Date: Mon, 4 Oct 2010 10:47:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069-dirty; KDE/4.5.1; i686; ; )
Cc: Nigel Cunningham <nigelc@hera.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <201010021849.54682.Martin@lichtvoll.de> <201010041000.33653.Martin@lichtvoll.de> (sfid-20101004_103927_480732_B8CE1D41)
In-Reply-To: <201010041000.33653.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5254041.D1cpeKUBlt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010041047.25307.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5254041.D1cpeKUBlt
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Montag 04 Oktober 2010 schrieb Martin Steigerwald:
> Am Samstag 02 Oktober 2010 schrieb Martin Steigerwald:
> > Am Montag 27 September 2010 schrieb Nigel Cunningham:
> > > Hi again Rafael.
> >=20
> > Hi Nigel and Rafael,
> >=20
> > > As discussed, here are the patches, modified to apply against your
> > > current linux-next tree. A new first patch splits compression
> > > support out into its own file, removing the need to have two
> > > versions of the load_image and save_image routines, minimising the
> > > changes to the remainder of the patches and making things cleaner
> > > than would otherwise be the case.
> > >=20
> > > On my laptop, single-threaded compression actually slows writing
> > > down from 175MB/s to around 100-120MB/s (depending on how well the
> > > image compresses). Reading speed improves from 218MB/s to around
> > > 245MB/s. I expect that multithreaded writing would bring the
> > > writing (and reading) speeds back up. It's on my swsusp to do list
> > > :)
> >=20
> > Testing this now
> > (2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069- dirty).
>=20
> Two times I had the rather strange issue that the machine booted
> freshly instead of resuming! First I thought I maybe didn't wait until
> the image was saved, before turning the laptop off. But now it
> happened a second time and also the ThinkPad T42 has a battery in it,
> thus it should always be able to complete writing the image.
>=20
> For resuming I found this in the syslog:
>=20
> Oct  4 09:19:10 shambhala kernel: end_request: I/O error, dev fd0,
> sector 0
> Oct  4 09:19:10 shambhala kernel: PM: Starting manual resume from disk
> Oct  4 09:19:10 shambhala kernel: PM: Resume from partition 8:2
> Oct  4 09:19:10 shambhala kernel: PM: Checking hibernation image.
> Oct  4 09:19:10 shambhala kernel: PM: Error -22 checking image file
> Oct  4 09:19:10 shambhala kernel: PM: Resume from disk failed.
> Oct  4 09:19:10 shambhala kernel: PM: Marking nosave pages:
> 000000000009f000 - 0000000000100000
> Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps created
> Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps freed
>=20
> What does error -22 mean?
>=20
> For hibernating:
>=20
> Oct  4 00:13:09 shambhala ifplugd(eth0)[15127]: Link beat lost.
> Oct  4 00:13:10 shambhala NetworkManager[2146]: <info> (eth0): carrier
> now OFF (device state 1)
> Oct  4 00:13:12 shambhala ifplugd(eth0)[15127]: Exiting.
> Oct  4 00:13:14 shambhala postfix/master[2589]: reload -- version
> 2.7.1, configuration /etc/postfix
> Oct  4 00:13:14 shambhala dhclient: Internet Systems Consortium DHCP
> Client 4.1.1-P1
> Oct  4 00:13:14 shambhala dhclient: Copyright 2004-2010 Internet
> Systems Consortium.
> Oct  4 00:13:14 shambhala dhclient: All rights reserved.
> Oct  4 00:13:14 shambhala dhclient: For info, please visit
> https://www.isc.org/software/dhcp/
> Oct  4 00:13:14 shambhala dhclient:
> Oct  4 00:13:14 shambhala dhclient: Listening on
> LPF/eth0/00:11:25:46:ec:a5
> Oct  4 00:13:14 shambhala dhclient: Sending on
> LPF/eth0/00:11:25:46:ec:a5
> Oct  4 00:13:14 shambhala dhclient: Sending on   Socket/fallback
> Oct  4 00:13:15 shambhala dhclient: DHCPRELEASE on eth0 to 10.0.0.9
> port 67
> Oct  4 00:13:18 shambhala kernel: PM: Marking nosave pages:
> 000000000009f000 - 0000000000100000
> Oct  4 00:13:18 shambhala kernel: PM: Basic memory bitmaps created
> Oct  4 00:13:18 shambhala kernel: PM: Syncing filesystems ... done.
> Oct  4 09:19:10 shambhala kernel: imklog 4.6.4, log source =3D /proc/kmsg
> started.
> Oct  4 09:19:10 shambhala rsyslogd: [origin software=3D"rsyslogd"
> swVersion=3D"4.6.4" x-pid=3D"1964" x-info=3D"http://www.rsyslog.com"]
> (re)start Oct  4 09:19:10 shambhala kernel: r hub
> Oct  4 09:19:10 shambhala kernel: usbcore: registered new device driver
> usb
>=20
> Which is not complete. It seems the last log messages prior to
> hibernating have not fully been written by rsyslog.
>=20
> Whats going on there? I didn't see this with Nigel's patches without
> the readahead patch. But then now I am testing suspend next + his
> patches, which may well contain other patches, as far as I understand.
>=20
> Any change to test with some newer state of suspend-next?
>=20
> Rafael did you integrate Nigel's patches in your tree?

Hmmm, there might be a similarity  between these:

In both times it happened after I made at least one suspend to ram cycle.=20
Yesterday I plugged the laptop to my hi-fi and forget to switch on the=20
power extension lead. Thus KDE's Power management suspended to RAM after=20
15 minutes of inactivity.

So maybe suspend to RAM interferes somehow.

Additionally I tend to get Radeon DRM KMS graphics corruption with that=20
kernel. And even a complete lockup once.

I think I will try 2.6.35-rc5 or whatever is latest with Nigel's patches=20
from Nigel's for-rafael branch in order to isolate whether what I see is=20
an issue with Nigel's patches or with any of the other stuff in suspend-
next.

Unless to have some newer stuff for me to test with.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5254041.D1cpeKUBlt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyplJQACgkQmRvqrKWZhMe+OgCgoiJgrfCzsbP/D4krqr28IL54
/CsAnilVuqa6umhlgNpH5A9BkTkWgssY
=7ivz
-----END PGP SIGNATURE-----

--nextPart5254041.D1cpeKUBlt--
