Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1ITRzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:55:00 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:35737 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1ITRy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:54:59 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Sep 2011 13:54:59 EDT
Date: Tue, 20 Sep 2011 19:48:52 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: nikola.ciprich@linuxbox.cz
Subject: 2.6.32.42 - fsnotify_event slabs increasing constantly
Message-ID: <20110920174852.GA2866@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5496273 records (last update: 20110920)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'd like to ask for help with finding out what's constantly eating memory o=
n one
of our servers. Today, I noticed that amount of free memory seems decreasin=
g, and
digging a bit into it revealed that one of the slab caches is increasing co=
nstantly:

9959348 9959348 100%    0.12K 292922	      34   1171688K fsnotify_event

and still slowly growing. The box is running pacemaker/corosync cluster and=
 a lot of asterisk
SW PBX processes. Asterisks might be the culprits here, as they keep scanni=
ng spool directory each, but
to my knowledge, 1.4.x versions we're using do not support *notify yet...
I will disable this functionality anyways, because we don't need it, but I =
can't restart all asterisks right
now...

So my questions are:

Can I somehow find out who's using all this slabs?
Can I free somehow free them without rebooting the whole box?

I'd love to (even temporarily) solve this somehow now, and plan some mainta=
nance window in near future, but I definitely
need to get rid of those slabs somehow, because it seems to cause quite hea=
vy load on MM and the whole box seems to be
getting overloaded...

The box is quad core machine with 4GB of memory, running x86_64 centos 5, w=
ith 2.6.32.42.

Could somebody please to help me hunt this problem down?

thanks a lot in advance

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk540gQACgkQ3xdJJrLygV5rHgCgxr8KOd1NOneVk+XE4t1qNRzj
dn4An1AFVpa7v3L7AjnnPx2FqWuucG3a
=2LCz
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
