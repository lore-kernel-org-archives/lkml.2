Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0JCDC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 23:02:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45281 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0JCDC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 23:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vfRRQuiEng+cwmYVLOU5KK9+Lx/7KcsAAahY8Nt4hF0PsbVU5jZnyzhLrPB4BU8wV5
         IUyxDkoZDzrJaeEl3nlPELKnGbpjgZf1cq9Xi8xKdpRzKQLMr1MV9IKZNxumM953e2RA
         tx9S3GHtpI+XmuwSNdlIPJAt4MsH2tgaktr7k=
Date: Sat, 2 Oct 2010 23:02:54 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later
Message-ID: <20101003030254.GA4901@roll>
References: <20101001035321.GA2360@roll> <20101001094814.GA5029@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20101001094814.GA5029@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	These final tests I think conclusively prove that I've been on a
wild goose chase. The load average statistic is indeed broken somehow, and I
did bisect it down to where the problem began, however there seems to be no
performance problem related to it I can find. Somehow I must have made a
mistake I didn't catch when I did the original build that led me to believe
on top of the statistic being broken, that it was causing a performance
problem.

	All of the make allnoconfig test results finish within a second of
eachother, with four different kernels tested. I think if there really was a
performance problem it would have reared its head sometime during the
multiple compile tests on different kernels I took. I apologize for wasting
everyones time, especially my own :)

Anyway, the results:

2.6.35.6:
make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
5.46user 0.51system 0:07.08elapsed 84%CPU (0avgtext+0avgdata 95888maxresident)k
0inputs+1920outputs (0major+126585minor)pagefaults 0swaps

2.6.35:
make mrproper && XZ_OPT="" CCACHE_DISABLE="1" time make allnoconfig
5.42user 0.50system 0:06.24elapsed 95%CPU (0avgtext+0avgdata 95888maxresident)k
0inputs+1920outputs (0major+126585minor)pagefaults 0swaps

Tim McGrath

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKfyXpEncCrqzVruAQJNdgf/aXHKwjE73AVOq1QdQoYzBkvIL+nGfyMb
A2l+U5ku+/COyT00ucZmt9EoGkz1UyN5a62mUF96qLZC6k1UHChhJ3+I+55hpFyb
cTEzEVmxxJx2RUoTwQQFzrkd+2XMhfo1V8AJdexZsdafD+iladTJyokQirhLYq7B
xbOpjIoGLoIMXsBPrsl0cKZJlfitjWQq1sAKAibR22a7Fa2jJ0l37EW1wsTQxvoP
5ANLDFkYoU6UMpM9IyYm91PFPfArMh11DUa33ug8ebg/wYLWsvV/UT3Lmae9JQ5q
dI+hexMjj+cPIzSOzQkEOplLue+ANbzZhB6rPYj+Hf9rLa6E+8ugHA==
=noy5
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
