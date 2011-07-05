Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1GEWIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:08:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49272 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1GEWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:08:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Weird USB over-current messages in recent kernels...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309903710_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 18:08:30 -0400
Message-ID: <61130.1309903710@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E138B5F.001F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309903710_18528P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <61111.1309903694.1@turing-police.cc.vt.edu>

Seen during boot the last few days on my laptop:

running 3.0.0-rc4-mmotm0622:
Jul  2 13:08:37 turing-police kernel: [    2.788108] hub 2-0:1.0: over-current condition on port 1
Jul  2 13:08:37 turing-police kernel: [    2.990088] hub 2-0:1.0: over-current condition on port 2
Jul  2 13:08:37 turing-police kernel: [    3.193073] hub 6-0:1.0: over-current condition on port 1
Jul  2 13:08:37 turing-police kernel: [    3.395088] hub 6-0:1.0: over-current condition on port 2

running 3.0.0-rc5-mmotm0630:
Jul  5 09:43:36 turing-police kernel: [  203.686082] hub 6-0:1.0: over-current condition on port 1
Jul  5 09:43:36 turing-police kernel: [  203.969179] hub 6-0:1.0: over-current condition on port 2
Jul  5 09:43:36 turing-police kernel: [  204.217077] hub 6-0:1.0: over-current condition on port 1

The problem?  I don't see any devices that would *cause* the condition:

#  lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 413c:2513 Dell Computer Corp. 
Bus 001 Device 003: ID 413c:2513 Dell Computer Corp. 
Bus 005 Device 002: ID 0a5c:5800 Broadcom Corp. BCM5880 Secure Applications Processor
Bus 001 Device 005: ID 045e:0023 Microsoft Corp. Trackball Optical
Bus 001 Device 006: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter

The device 5 and 6 on bus 1 are attached to the docking station, the Jul 2 boot
was undocked and those two devices weren't present. Nobody home on bus 2 or 6
at any time, as far as I can tell.

Any ideas?

--==_Exmh_1309903710_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE4tecC3lWbTT17ARAo9jAJ4444Jtc4c0EC8ehPJD53almx4Q1gCeN/fA
Xjre3MFxOMBtSV59lLWKff0=
=4eMR
-----END PGP SIGNATURE-----

--==_Exmh_1309903710_18528P--

