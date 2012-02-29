Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2B2Wkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:40:36 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:41594 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2B2Wke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:40:34 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhengwang Ruan <ruan.zhengwang@gmail.com>, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Trace: initialize variable to clear warning
In-Reply-To: Your message of "Tue, 28 Feb 2012 09:16:31 EST."
             <1330438591.25686.214.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>
            <1330438591.25686.214.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1330555230_2845P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Feb 2012 17:40:30 -0500
Message-ID: <48875.1330555230@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4F4EA95F.0063,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1330555230_2845P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Feb 2012 09:16:31 EST, Steven Rostedt said:

> This is a bug in gcc that's fixed in 4.6 and beyond. I don't want to
> remove this warning because it will hide a real bug if page2 really does
> become uninitialized. If 4.6 gives a warning here, then I'll fix it.

> > -	void *page2;
> > +	void *uninitialized_var(page2);

How would you feel about this?

-	void *page2;
+	void *page2; /* gcc 4.5 bug causes incorrect "uninitialized" warning */

or something similar?


--==_Exmh_1330555230_2845P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT06pXQdmEQWDXROgAQKFhw/+IQdoMTFFMpedv2M0s3nwiRMUBmsCc2cU
yUnSAeuQOhLdAg6jVauLwvA7S/cGYbOYeRIo+BdqOwc2VcvBXWPTGSpZvlsn22eA
m7Zc/rcX53fyljDSO/o/9INKjUYoDPTptij6ljIZmkQbAS+JpsSpOSRTvkVIM4vR
Rc+Vw0dH6o0yQkgSMLAasjCbnNmQ2ZeoIj3QP2+y+6zvfHMoL5JDHbzbAvA6v6ar
j9QD7PnWOTGF8acZVOnKkSlxYgAW3wJcTUKEVaImsvmOyZe8xjdEJivchs0mzP57
Lc/UNUPys2HOHxT5WyLgOVueleyc4aanNFKxKo6pt55oPP/MC/FKH1XIq/ZriLYf
YVLXN3E9QnMIl38gwI/Pl5z8p7RUE9/E7ieLGbyIYjH2fkaWUKYwZmitv9FF92Dr
cVHzWr2Pj+dsC8IJV1vlzInr9uhk/6HNx0xVwdQq2CMURUlGJPQdqKk9YRdOtDUI
zB02i4HNIH189frmoET+dMeLIq8OUKp9Qtoals1tdeJZEM6jOMILpnoS3kbILt2G
y7+NHFwpXbwz5uoOc+lLl7psehF1oG0yCx8JaowGPdgUvawxfEFcB0RkQqLCmwdU
Q6W/uOV7FphzZ3ngZzZkU0II93do8J9WHddNugt2Xbx1JgQoMkqlYWW4YMDTqS/l
KKWmX/KAvWg=
=00p4
-----END PGP SIGNATURE-----

--==_Exmh_1330555230_2845P--

