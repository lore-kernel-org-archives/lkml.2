Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0EJOxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:53:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40071 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0EJOxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:53:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] Handle instruction cache maintenance fault properly
In-Reply-To: Your message of "Mon, 10 May 2010 16:34:57 +0300."
             <AANLkTint0f2Ow2FM3jVAqGfPjolHvF-oBTGCmY7Jx7_d@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com> <20100510131519.GB7796@n2100.arm.linux.org.uk>
            <AANLkTint0f2Ow2FM3jVAqGfPjolHvF-oBTGCmY7Jx7_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273503128_3913P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 May 2010 10:52:08 -0400
Message-ID: <7529.1273503128@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4BE81D98.0343,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273503128_3913P
Content-Type: text/plain; charset=us-ascii

On Mon, 10 May 2010 16:34:57 +0300, "Kirill A. Shutemov" said:

> It looks like cache maintenance fault was introduced in ARMv6.
> 
> So, what is the right way to fix it? Something like:
> 
> #if __LINUX_ARM_ARCH__ < 6
>         { do_bad,               SIGBUS,  0,             "external

This would need to be a runtime test, no?  Or does LINUX_ARM_ARCH not allow
it to run on other arch levels? (i.e. can an ARM kernel boot for v5 and v6?)

--==_Exmh_1273503128_3913P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL6B2YcC3lWbTT17ARAvQjAKCmJ0GxRedpJGFJMrXTtiWRI2en0QCg8scr
vSowoN64gYkGhfye3H+MghI=
=b+xM
-----END PGP SIGNATURE-----

--==_Exmh_1273503128_3913P--

