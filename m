Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab0JBQvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:51:52 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50225 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0JBQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:51:51 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] unable to handle paging request at resume (was: Re: [TuxOnIce-devel] Nigel's current for-rafael queue)
Date: Sat, 2 Oct 2010 18:51:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069-dirty; KDE/4.5.1; i686; ; )
Cc: "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigelc@hera.kernel.org>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <201009281234.49454.Martin@lichtvoll.de> <201009300952.20273.Martin@lichtvoll.de> (sfid-20100930_112343_493662_F2440AEE)
In-Reply-To: <201009300952.20273.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1352683.YoA8NxOJDT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010021851.49116.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1352683.YoA8NxOJDT
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag 30 September 2010 schrieb Martin Steigerwald:
> Hi Nigel and Rafael,
>=20
> Am Dienstag 28 September 2010 schrieb Martin Steigerwald:
> > Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> > > Hi Rafael.
> > >=20
> > > Please find attached a slightly updated version of the patchset I
> > > sent a few months ago. The main change is that I've prepended and
> > > additional patch which lets the user see the speed at which the
> > > image is being read and written. This is accomplished by recording
> > > the MB/s in a single byte in the image header, and using a couple
> > > of __nosavedata variables to get the data back through the atomic
> > > restore. I realise the char limits us to 255MB/s at the moment. In
> > > future patches, I intend to address this by storing the data in a
> > > 'proper' image header (it's a real problem - TuxOnIce reads and
> > > writes on the same set up at speeds around 250MB/s).
> > >=20
> > > Results on my Dell XPS M1530, which has an SSD hard drive are:
> > >=20
> > > With just patch 1 applied:
> > > Attempt 1: Write 74MB/s; Read 52MB/s
> > > Attempt 2: Write 68MB/s; Read 52MB/s
> > > Attempt 3: Write 73MB/s; Read 53MB/s
> > >=20
> > > With the whole sequence:
> > > Attempt 1: Write 181MB/s; Read 52MB/s
> > > Attempt 2: Write 156MB/s; Read 53MB/s
> > > Attempt 3: Write 160MB/s; Read 52MB/s
> >=20
> > Is doesn't get much stabler than
> >=20
> > shambhala:~> grep "PM: Image.*at " /var/log/syslog
> > Sep 28 11:32:06 shambhala kernel: PM: Image written at 63 MB/s.
> > Sep 28 11:32:06 shambhala kernel: PM: Image read at 32 MB/s.
> > Sep 28 11:35:00 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 11:35:00 shambhala kernel: PM: Image read at 32 MB/s.
> > Sep 28 11:38:43 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 11:38:43 shambhala kernel: PM: Image read at 33 MB/s.
> > Sep 28 11:41:15 shambhala kernel: PM: Image written at 66 MB/s.
> > Sep 28 11:41:15 shambhala kernel: PM: Image read at 33 MB/s.
> > Sep 28 11:42:57 shambhala kernel: PM: Image written at 66 MB/s.
> > Sep 28 11:42:57 shambhala kernel: PM: Image read at 34 MB/s.
> > Sep 28 11:45:16 shambhala kernel: PM: Image written at 66 MB/s.
> > Sep 28 11:45:16 shambhala kernel: PM: Image read at 34 MB/s.
> > Sep 28 12:19:21 shambhala kernel: PM: Image written at 66 MB/s.
> > Sep 28 12:19:21 shambhala kernel: PM: Image read at 35 MB/s.
> > Sep 28 12:21:35 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 12:21:35 shambhala kernel: PM: Image read at 35 MB/s.
> > Sep 28 12:23:18 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 12:23:18 shambhala kernel: PM: Image read at 35 MB/s.
> > Sep 28 12:25:23 shambhala kernel: PM: Image written at 64 MB/s.
> > Sep 28 12:25:23 shambhala kernel: PM: Image read at 36 MB/s.
> > Sep 28 12:26:55 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 12:26:55 shambhala kernel: PM: Image read at 37 MB/s.
> > Sep 28 12:28:28 shambhala kernel: PM: Image written at 65 MB/s.
> > Sep 28 12:28:28 shambhala kernel: PM: Image read at 37 MB/s.
> >=20
> > many attempts.
> >=20
> > So - without readahead patch for now -
> >=20
> > Tested-By: Martin Steigerwald <Martin@Lichtvoll.de>
> >=20
> > on 2.6.36-rc5.
>=20
> Well probably it couldn't get more stable than that, but it was able to
> get more unstable:
>=20
> This morning I got a unable to handle paging request after switching on
> my kernel suspended ThinkPad T42. With exactly that kernel with all of
> Nigel's patches except for the readahead one.
>=20
> http://martin-steigerwald.de/tmp/suspend-patches/unable-to-handle-pagin
> g- request-at-resume/
>=20
> IMG_3897.JPG  is what I saw first. IMG_3900.JPG came after I pressed
> the power button to swich off the machine in order to cold reboot it.
> As I left the machine unattended during resume, I did not see what
> happened before this.
>=20
> On the next attempt the laptop just rebootet instead of trying to
> resume from the saved image again.
>=20
> I grepped stuff in syslog and found that it seemed to have been able to
> write some stuff into syslog prior to the trace:
>=20
> Sep 30 00:00:34 shambhala kernel: PM: Marking nosave pages:
> 000000000009f000 - 0000000000100000
> Sep 30 00:00:34 shambhala kernel: PM: Basic memory bitmaps created
> Sep 30 00:00:34 shambhala kernel: PM: Syncing filesystems ... done.
> Sep 30 09:13:34 shambhala kernel: Freezing user space processes ...
> 00:02:00.0: restoring config space at offset
>  0x1 (was 0x2100107, writing 0x2100007)
> Sep 30 09:13:34 shambhala kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0xf (was 0x3c0020
> b, writing 0x5c0020b)
> Sep 30 09:13:34 shambhala kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0x3 (was 0x824008
> , writing 0x82a810)
> Sep 30 09:13:34 shambhala kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0x1 (was 0x210010
> 7, writing 0x2100007)
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: BAR 0: set to
> [mem 0xc0220000-0xc023ffff] (PCI address [0x
> c0220000-0xc023ffff]
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: BAR 1: set to
> [mem 0xc0200000-0xc020ffff] (PCI address [0x
> c0200000-0xc020ffff]
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: BAR 2: set to [io
> 0x8000-0x803f] (PCI address [0x8000-0x8
> 03f]
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: restoring config
> space at offset 0xf (was 0xff0100, writin
> g 0xff010b)
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: restoring config
> space at offset 0x3 (was 0x0, writing 0x4
> 008)
> Sep 30 09:13:34 shambhala kernel: e1000 0000:02:01.0: restoring config
> space at offset 0x1 (was 0x2300000, writi
> ng 0x2300117)
> Sep 30 09:13:34 shambhala kernel: PM: early restore of devices complete
> after 31.408 msecs
> Sep 30 09:13:34 shambhala kernel: BUG: Bad page state in process echo
> pfn:73302
> Sep 30 09:13:34 shambhala kernel: page:c24d8040 count:0 mapcount:1
> mapping:(null) index:0x9bf5
> Sep 30 09:13:34 shambhala kernel: page flags:
> 0x80100078(uptodate|dirty| lru|active|swapbacked)
> Sep 30 09:13:34 shambhala kernel: Pid: 18599, comm: echo Not tainted
> 2.6.36-rc5-tp42-hiber-wri-accel-vmembase-0-
> 00133-g3394a84-dirty #1
> Sep 30 09:13:34 shambhala kernel: Call Trace:
> Sep 30 09:13:34 shambhala kernel: [<c10ac8d3>] bad_page+0x83/0xd0
> Sep 30 09:13:34 shambhala kernel: [<c10ad541>]
> free_pages_prepare+0x131/0x170
> Sep 30 09:13:34 shambhala kernel: [<c10aef98>]
> free_hot_cold_page+0x28/0x140
> Sep 30 09:13:34 shambhala kernel: [<c10af0e5>] __free_pages+0x35/0x40
> Sep 30 09:13:34 shambhala kernel: [<c10727e6>] swsusp_free+0xa6/0x100
> Sep 30 09:13:34 shambhala kernel: [<c10719f3>]
> hibernation_snapshot+0x123/0x290
> Sep 30 09:13:34 shambhala kernel: [<c1070b76>] ?
> freeze_processes+0x56/0xa0
> Sep 30 09:13:34 shambhala kernel: [<c1071c45>] hibernate+0xe5/0x210
> Sep 30 09:13:34 shambhala kernel: [<c10704f0>] ? state_store+0x0/0xb0
> Sep 30 09:13:34 shambhala kernel: [<c1070596>] state_store+0xa6/0xb0
> Sep 30 09:13:34 shambhala kernSep 30 09:25:08 shambhala kernel: imklog
> 4.6.4, log source =3D /proc/kmsg started.

I didn't see this one again so far.

Still I wonder what that might have been. Any hints?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1352683.YoA8NxOJDT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkynYyQACgkQmRvqrKWZhMdHyACfX6cP+gv+ILfZIuaSZFTPO7hf
DYUAoJotUSeV3ti1S9IR5Ju//OaH15YB
=cZmL
-----END PGP SIGNATURE-----

--nextPart1352683.YoA8NxOJDT--
