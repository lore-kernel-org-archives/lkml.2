Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1ISMkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 08:40:45 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:55754 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1ISMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 08:40:43 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 08:40:43 EDT
Date: Mon, 19 Sep 2011 08:31:00 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andres Freund <andres@anarazel.de>, Matthew Wilcox <matthew@wil.cx>,
        Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com, pgsql-hackers@postgresql.org
Subject: Re: [HACKERS] Improve lseek scalability v3
Message-ID: <20110919123100.GJ12765@tamriel.snowman.net>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <201109161616.50004.andres@anarazel.de>
 <20110916153620.GA9913@parisc-linux.org>
 <201109161927.34472.andres@anarazel.de>
 <20110916200817.GD28519@kvack.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GmIAiBEz2jSsbeLA"
Content-Disposition: inline
In-Reply-To: <20110916200817.GD28519@kvack.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.32-5-amd64 (x86_64)
X-Uptime: 08:30:20 up 228 days, 21:00, 13 users,  load average: 0.28, 0.14,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GmIAiBEz2jSsbeLA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Benjamin LaHaise (bcrl@kvack.org) wrote:
> For such tables, can't Postgres track the size of the file internally?  I=
'm=20
> assuming it's keeping file descriptors open on the tables it manages, in=
=20
> which case when it writes to a file to extend it, the internally stored s=
ize=20
> could be updated.  Not making a syscall at all would scale far better tha=
n=20
> even a modified lseek() will perform.

We'd have to have it in shared memory and have a lock around it, it
wouldn't be cheap at all.

	Thanks,
	=09
		Stephen

--GmIAiBEz2jSsbeLA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk53NgQACgkQrzgMPqB3kigQkACbBedEBkNbhU0Eg/LgMO7xPcdZ
VRgAn20rNS0pVWDTsFdladAr9UzPxo8Z
=K4cW
-----END PGP SIGNATURE-----

--GmIAiBEz2jSsbeLA--
