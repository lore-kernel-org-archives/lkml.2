Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0FNQ2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:28:52 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41951 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0FNQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:28:51 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2010 12:28:51 EDT
Date: Mon, 14 Jun 2010 18:19:04 +0200
From: Nico Schottelius <nico-linux-20100614@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: New issues in 2.6.35-rc{1,2}
Message-ID: <20100614161904.GE31910@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100614@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc2 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey devs!

In both of these versions, the update of the carrier flag seems
to be "different" than before (linux-2.6.34-08528-gb3f2f6c):

wlan0 (iwlagn) does not recognize it's disconnected
and eth0 (e1000e) does only react correctly after I restarted
dhcpcd (isc):

[11:20] kr:pm# dhcpcd eth0=20
dhcpcd: version 5.2.2 starting
dhcpcd: eth0: waiting for carrier
^Cdhcpcd: received SIGINT, stopping
dhcpcd: eth0: removing interface
[11:20] kr:pm# dhcpcd eth0
dhcpcd: version 5.2.2 starting
dhcpcd: eth0: broadcasting for a lease
dhcpcd: eth0: offered 129.132.102.115 from 129.132.65.12
dhcpcd: eth0: ignoring offer of 129.132.102.115 from 129.132.57.97
dhcpcd: eth0: acknowledged 129.132.102.115 from 129.132.65.12
dhcpcd: eth0: checking for 129.132.102.115
dhcpcd: eth0: leased 129.132.102.115 for 86400 seconds
dhcpcd: forking to background

It's known that iwlagn has problems after suspend/resume,
but new is that both nics do not notify dhcpcd that the link
has gone. I'm not sure what / where broke here, just see that
dhcpcd noticed it before and now doesn't anymore.

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwWVngACgkQ19zI5DGHffAURgCgxt+B8Q2OK4fYEXaqnoTeeXmV
qrIAnRJldjxynFGP/R3k+9j/+yHVclhb
=Jf1e
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
