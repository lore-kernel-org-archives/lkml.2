Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1HaTQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:16:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34040 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1HaTQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:16:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next-20110831 build failure in iwlwifi when IWLWIFI_DEBUGFS not set
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314818201_5176P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Aug 2011 15:16:41 -0400
Message-ID: <41822.1314818201@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4E5E889A.01CA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314818201_5176P
Content-Type: text/plain; charset=us-ascii

Build error in linux-next 20110831:

drivers/built-in.o: In function `iwl_irq_handle_error':
iwl-trans-rx-pcie.c:(.text+0x100ee9): undefined reference to `iwl_dump_csr'
iwl-trans-rx-pcie.c:(.text+0x100ef5): undefined reference to `iwl_dump_fh'

Calling site is iwl-trans-rx-pcie.c, function iwl_irq_handle_error.

The functions are in iwl-trans.c, but hidden behind #ifdef
CONFIG_IWLWIFI_DEBUGFS so if that isn't defined, they don't get built.  The
call site already has an IWLWIFI_DEBUG ifdef, looks like iwl_irq_handle_error()
needs some tender loving restructuring.


--==_Exmh_1314818201_5176P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOXoiZcC3lWbTT17ARApwVAJ9zv+QZVHIkw5ChphnjXSsXkJrDzACg400b
YXuCfDOw4/DK2ibvUSUvWXc=
=G3Dw
-----END PGP SIGNATURE-----

--==_Exmh_1314818201_5176P--

