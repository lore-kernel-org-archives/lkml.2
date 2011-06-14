Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1FNStO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:49:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37088 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1FNStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:49:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jean Sacren <sakiwit@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
In-Reply-To: Your message of "Sun, 12 Jun 2011 15:31:07 MDT."
             <20110612213107.GA12816@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20110612213107.GA12816@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308077351_2718P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jun 2011 14:49:11 -0400
Message-ID: <56959.1308077351@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DF7AD28.0012,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308077351_2718P
Content-Type: text/plain; charset=us-ascii

On Sun, 12 Jun 2011 15:31:07 MDT, Jean Sacren said:
> The fix makes certain so that the size of the initialized arrays doesn't
> go beyond the boundary set by the array size of 40.

Did you notice that gcc as far back as 3.4.6 will whinge *anyhow*
if you have too many initializers?

% cat > test9.c
int foo[5] = { 0, 1, 2, 3, 4, 5, 6};
^D
% gcc -c test9.c
test9.c:1:1: warning: excess elements in array initializer [enabled by default]
test9.c:1:1: warning: (near initialization for 'foo') [enabled by default]
test9.c:1:1: warning: excess elements in array initializer [enabled by default]
test9.c:1:1: warning: (near initialization for 'foo') [enabled by default]


--==_Exmh_1308077351_2718P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN960ncC3lWbTT17ARAhnLAJ4ksI5IWYzkvLYD2y1GZHq2PtPItwCgl3QP
PncW/1vJ7vRXErYpzNpjM0k=
=H2FV
-----END PGP SIGNATURE-----

--==_Exmh_1308077351_2718P--

