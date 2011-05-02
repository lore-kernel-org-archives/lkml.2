Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1EBXbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:31:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55909 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1EBXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:31:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
In-Reply-To: Your message of "Tue, 03 May 2011 00:44:51 +0200."
             <201105030044.51661.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <201105030044.51661.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304379012_5156P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 May 2011 19:30:12 -0400
Message-ID: <50363.1304379012@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DBF3E87.0040,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304379012_5156P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 May 2011 00:44:51 +0200, "Rafael J. Wysocki" said:

> +	if (WARN_ON(usermodehelper_is_disabled()))
> +		return -EBUSY;
> +

Since this is a "no user serviceable parts inside" type of error, so I guess
WARN_ON rather than a printk(KERN_WARNING is a good idea so we get
a traceback pointing out the offending driver.

I have to wonder 2 things though:

1) What percent of the time the missing firmware (or other issues, like the
display not being resumed yet) will prevent the WARN_ON output from making it
to the display *anyhow*, so the user *still* hits the power button to try again?

2) What percent of the time the WARN_ON output will itself make the user
think the resume has died rather than just being slow, causing them to power
cycle and hope for a clean boot?

Maybe something like this instead?

	if (WARN_ON(usermodehelper_is_disable()))) {
		printk(KERN_WARNING "Resume continuing, but firmware for %s not loaded", device);
		return -EBUSY;
	}

(or whatever that %s actually needs to work)

All the same, it still looks better than what we're doing now.


--==_Exmh_1304379012_5156P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNvz6EcC3lWbTT17ARAoB3AKDdGwaSZvg4IY15nM55u5ZpdmS2ewCfdMpC
N7QaGdS2glNSsTngfe98oDo=
=T9ik
-----END PGP SIGNATURE-----

--==_Exmh_1304379012_5156P--

