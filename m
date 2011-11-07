Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1KGSGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:06:51 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47072 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1KGSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:06:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: restrict access to /proc/interrupts
In-Reply-To: Your message of "Mon, 07 Nov 2011 21:45:22 +0400."
             <20111107174522.GA2317@albatros>
From: Valdis.Kletnieks@vt.edu
References: <20111107174522.GA2317@albatros>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1320689192_3773P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Nov 2011 13:06:32 -0500
Message-ID: <9718.1320689192@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4EB81E2A.0132,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1320689192_3773P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Nov 2011 21:45:22 +0400, Vasiliy Kulikov said:
> /proc/interrupts contains the number of emitted interrupts, which
> should not be world readable.  The information about keyboard
> interrupts number may be used to learn the precise number of characters in
> users' passwords by simply watching the changes of number of emitted
> interrupts during the life of gksu-like programs.
> 
> The PoC is publicly available at:
> 
> http://www.openwall.com/lists/oss-security/2011/11/07/9

This doesn't close the hole entirely.  You can still figure it out by
watching the files in /dev/pts/ and /dev/tty* for changes in last-modify
time.

This whack-a-mole  "turn off permissions on generally useful files because
there's an exposure" really has to stop.  On probably the vast majority of
Linux systems, it's an embedded or a laptop/desktop, and if you have a
malicious user running code on it already, the fact they can find out how many
characters are in the password is the *least* of your problems.

This sort of thing needs to be done as part of an overall security model
(in other words, something like Smack or SELinux should be moderating
the accesses in a more fine-grained manner than "chmod it to 0").

And if you're worried about them knowing the length of the password, you
probably should be using appropriate PAM configurations to enforce a minimum
length/complexity high enough that even if they know the password is 23
characters long, it doesn't do them any real good...


--==_Exmh_1320689192_3773P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOuB4ocC3lWbTT17ARAudXAKDj+0Hh8HF9KTe1dqHILHoQJV1BSwCg4O2F
Hvg4GfzwlKXivbf/lRdTyj0=
=/TAD
-----END PGP SIGNATURE-----

--==_Exmh_1320689192_3773P--

