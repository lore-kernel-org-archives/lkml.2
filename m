Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1ECPs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:48:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36533 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1ECPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:48:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
In-Reply-To: Your message of "Tue, 03 May 2011 13:02:08 +0200."
             <201105031302.08910.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <201105030044.51661.rjw@sisk.pl> <50363.1304379012@localhost>
            <201105031302.08910.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304437643_4857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 May 2011 11:47:23 -0400
Message-ID: <15997.1304437643@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DC0238E.008C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304437643_4857P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 May 2011 13:02:08 +0200, "Rafael J. Wysocki" said:

> Although the WARN_ON output will probably not make it to the user's screen
> immediately, the resume will continue without the delay, because error code
> will be returned as soon as the WARN_ON triggers.
> 
> The user will likely notice the device not working after the resume and will
> look at dmesg output. :-)

Good point. I obviously didn't have enough caffeine to think it through. ;)

> > 2) What percent of the time the WARN_ON output will itself make the user
> > think the resume has died rather than just being slow, causing them to power
> > cycle and hope for a clean boot?
> > 
> > Maybe something like this instead?
> > 
> > 	if (WARN_ON(usermodehelper_is_disable()))) {
> > 		printk(KERN_WARNING "Resume continuing, but firmware for %s not loaded", device);
> 
> It's useful, but I'd rather do
> 
>  		dev_info(device, "firmware: %s will not be loaded\n", name);

That works too.  :)

> OK, updated patch is appended.

Looks good to me.


--==_Exmh_1304437643_4857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwCOLcC3lWbTT17ARAjk0AKC8fce+ePFBOa8hpxhovv9JinmnNQCg8Rm1
00z5bsBXrsmW5EnP7AquHF8=
=5lay
-----END PGP SIGNATURE-----

--==_Exmh_1304437643_4857P--

