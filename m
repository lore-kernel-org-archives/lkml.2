Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0FMUxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:53:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43605 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0FMUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:53:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
In-Reply-To: Your message of "Sun, 13 Jun 2010 13:11:48 EDT."
             <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
From: Valdis.Kletnieks@vt.edu
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
            <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276462373_18203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jun 2010 16:52:53 -0400
Message-ID: <40245.1276462373@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C154526.014D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276462373_18203P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Jun 2010 13:11:48 EDT, Chase Douglas said:
> Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> condition. We know the exact size of nsecs_str, so use it instead of
> math that may overflow.

>  	/* Print nsecs (we don't want to exceed 7 numbers) */
>  	if ((s->len - len) < 7) {
> -		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
> +		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);

We only get into this code after we've checked that the length is under 7
characters.  How much overflow can happen as long as the sizeof(nsecs_str) is a
sane size (like at least 8 chars)?  Probably a better bet would be doing the
right thing and 'BUILD_BUG_ON(sizeof(nsecs_str) < 8);'?


--==_Exmh_1276462373_18203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFUUlcC3lWbTT17ARAvAhAJ4yDVB6vRNKCM+yvRPYg/G16JnGIwCgvO3N
S8T7K3cOvIZqlWSX+/nFmgI=
=ol4x
-----END PGP SIGNATURE-----

--==_Exmh_1276462373_18203P--

