Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1JGRC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:02:26 -0400
Received: from izzard.Mines.EDU ([138.67.132.197]:55202 "EHLO izzard.mines.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1JGRCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:02:24 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Oct 2011 13:02:24 EDT
Message-ID: <4E8F2C8D.7070201@mines.edu>
Date: Fri, 07 Oct 2011 10:45:01 -0600
From: Yuri Csapo <ycsapo@mines.edu>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NFS performance
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9337D85A8195A0C458E136B1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9337D85A8195A0C458E136B1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

We've been battling a strange performance problem with one of our NFS
servers. At mostly irregular intervals, our users report extremely slow
responses. Those who are command line-challenged say that their windows
"gray out" for a few seconds and won't let them do anything. Those who
use the command line more report things like simple commands like cat
taking a few seconds to "start."

On the server, the only indication we can see that anything is wrong is
%iowait climbing above 80% while the event is happening. Running iotop
we can see that it's the several nfsd processes that are driving IO.
Another thing we have noticed is that when the backup process (Symantec
NetBackup) runs, %iowait pegs at 100% for the duration.

I know that normally this would mean disk bottlenecks, but look at the
specs below and you will see why I find that hard to believe. We have
tried a ton of different monitoring tools and we are trying to fiddle
with parameters at the NFS, tcp, and iSCSI levels to see if we can
figure this out, so far with not a lot of luck.

The server
----------

=2E VMware virtual machine
=2E 2 GB RAM, which sounds small but we rarely ever see any swapping
=2E 2 cores
=2E Stock CentOS 6.0 (Final)

The host
--------

=2E Dell PowerEdge M610 blade
=2E 2 x quad-core 2.4 GHz Xeon (L5530)
=2E 48 GB RAM
=2E ESXi 4

The storage
-----------

The VM itself, as well as its system volume, reside on a group of 4
EquaLogic ps6000 with 16 x 15K SAS disks each, on RAID50. The system
volume (sda) is a VMware vmdk.

The data volume (sdb) is an iSCSI volume that the VM connects directly
to, on an EquaLogic ps6510 with 48 x 3Gb/s SATA disks on RAID50.

The clients
-----------

=2E About 50 clients
=2E Brand new Dell Optiplexes (not sure about model)
=2E 8 GB RAM
=2E 2 x quad-core Intel Core i7-2600 @ 3.4 GHz
=2E Ubuntu 10.04 lucid lynx LTS

The network
-----------

=2E The blade has 6 NICs in 3 bonded pairs, all Gb Ethernet. One pair is
for regular networking, one for vMotion, and one for SAN iSCSI access.
The particular VM has two virtual (VMXNET3) NICs, one for regular
service and one for iSCSI access. The blade links to a Cisco 3750 2
switch stack.

=2E The ps6000 SAN links to the same 3750 stack through 4 bonded pairs (8=

NICs) each.

=2E The 3750 uplinks to a Cisco 6509.

=2E The 6509 downlinks to a different 3750 stack in a different building,=

through fiber, where all workstations link.

=2E The 6509 also links to a 3750x with 2 links of Gb Ethernet. The 3750x=

links over a 10 GB Ethernet to the ps6510 SAN.

I will appreciate any idea or insight into finding this problem.

Thanks!

Yuri


--------------enig9337D85A8195A0C458E136B1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOjyyNAAoJEE9aMTvgYng5dVQH/36gLtapIKDc2O4Wa15M5PqK
LmDmnG0O4sZUSCy7UlPbP9QkGAW0AyJfrgKXBk0acv9I631OWGoF+Q3YRqxjGvmB
D4n4t6dIEwfZjrs54fUGRW9nkf0BaxIVFWvzeTGzAERWRiemREKvaz66H219pnZg
dBvNXF48m4jYRQrQHFN8P/4z8QuLcmDIQTRA2h5trcC5u0mUPiRhcXtZS6f3bWy2
ZvgrlLg7iLTQzRz+ZgmC3VESudkZJ1EBGVWJTZWab/3zq2fURaiWq+akXAzgWC4f
smeqKjrnqcoMZvEXOmX8VhUxlIIzC5fRHp+tjaw2U1eLnG6VE8ET0fDVxDuU6ew=
=jpvK
-----END PGP SIGNATURE-----

--------------enig9337D85A8195A0C458E136B1--
