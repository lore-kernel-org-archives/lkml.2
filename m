Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750806Ab0JMPhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:37:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33769 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0JMPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:37:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Stupid lockdep question...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1286984249_9841P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Oct 2010 11:37:29 -0400
Message-ID: <38780.1286984249@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4CB5D23A.00D6,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1286984249_9841P
Content-Type: text/plain; charset=us-ascii

I have a 3rd-party module, that throws this whinge:

[   65.831296] INFO: trying to register non-static key.
[   65.831301] the code is fine but needs lockdep annotation.
[   65.831303] turning off the locking correctness validator.

I've identified that it's a call to down(*foo) where foo points to a kmalloc'ed
block of memory that's memset() to all-zeros. What's the initializer/annotation
I need to add to my code?


--==_Exmh_1286984249_9841P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMtdI5cC3lWbTT17ARAoGGAKDYi61uFjfXX8xZdVeJBYZBhM0PjQCg0S2k
5YeyZz5TLFxI92u+LV7tr50=
=py4K
-----END PGP SIGNATURE-----

--==_Exmh_1286984249_9841P--

