Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0I2LDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:03:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57130 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0I2LDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DRuc7tDAxqZ+BM/UHd2/G4Pyl4/Bu6LPbWZGjWX3aTveA7h9JBp9vRWHshb2HpfXcT
         talmimR2xkychMlngQQq3T1XW2/jRS8FHFI+okm/5NMtKBfdqjzGsGkDJ4zDmnRP51uj
         klMJFykVXAfTc/Iz6W+BBI5pSVB5fTRPwMtJs=
Date: Wed, 29 Sep 2010 07:02:48 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100929110247.GA2032@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab> <20100927233956.GA15705@roll> <20100928083505.0a808ffd@schatten.dmk.lab> <20100928190358.GA24303@roll> <20100929092924.2090f19e@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20100929092924.2090f19e@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2010 at 09:29:24AM +0200, Florian Mickler wrote:
> Do you know what load average conky is showing you? If I
> type 'uptime' on a console, i get three load numbers: 1minute-,
> 5minutes- and 15minutes-average.=20
> If there is a systematic bias it should be visible on the
> 15minutes-average.  If there are only bursts of 'load' it should be
> visible on the 1 minutes average numbers.

It is giving the same averages that uptime does in the same format, and
there is a routine problem - it remains high on all averages on the kernels
that do not work properly, and zeroes eventually if I leave it alone long
enough on kernels that do work properly. When I discovered X was part of the
problem somehow, it was due to me testing in X with mrxvt running bash and
uptime, and in console without X using bash with uptime. uptime consistently
gives the same numbers that conky does, so I don't think I need to worry
about conky confusing the issue.

>=20
> But it doesn't really matter for now what kind of load disturbance you
> are seeing, because you actually have a better way to distinguish a good
> kernel from a bad:

You may think a timed kernel compile is a better way to determine if there
is a fault with the kernel, but it takes my machine around two hours (WITH
ccache) to build my kernel. Since the use of ccache speeds up the builds
dramatically and would give misleading readings if I compiled the exact
kernel source twice, I'd have to disable it if I wanted it to be a
worthwhile test. So it would take even *longer* to build than normally. This
is not something I'm willing to use as a 'better' test - especially since
the loadavg numbers are consistently high when on a bad kernel and
consistently zeroed or very close to it when not.

Here's an uptime sample from a working version:

06:20:31 up 21 min,  4 users,  load average: 0.00, 0.02, 0.06

I've been typing up this email while waiting for the load to flatten from
the initial boot. I think it's pretty obvious here that it's working
properly, so I'm going to git bisect good it...

Bisecting: 27 revisions left to test after this (roughly 5 steps)

I'm getting fairly close at least.

Here's an uptime output from a version of the kernel that was NOT working
properly, 2.6.35.6:
14:30:12 up  3:46,  4 users,  load average: 0.85, 0.93, 0.89

And it probably doesn't give you any useful information, but here's 2.6.35.=
1's
reaction to building 2.6.35:
22:01:22 up 15 min, 4 users, load average: 1.84, 1.38, 0.83

whereas on a working kernel this is what the load average looks like when
building a kernel:
06:33:13 up 34 min,  4 users,  load average: 1.01, 0.92, 0.52

This is not a multiprocessor or multicore system, it's an athlon XP 2800
with 1.5GB of ram. Before the question is asked, no, I'm not being silly and
using make -j2.

I think simply letting the machine idle is just as good a test for
determining wether or not any particular kernel is good/bad since the
readings are like night and day. I only brought up that the timed kernel
runs were taking longer on the kernel with the higher load average since it
meant that it wasn't simply a broken statistic giving false readings;
something *is* wrong, and I can't simply ignore it.

It's taken me several days to bisect this far. If greg insists, I'll restart
the bisection from scratch using a kernel compile as a test, but I implore
you not to ask me to do so; it will more than likely give me the same
results I'm getting now for more than double the amount of time invested.

> Yes, the sample rate was one of the things I wanted to know, but also whi=
ch of
> the 3 load figures you were graphing. =20
To be honest, I actually don't know. I'm *terrible* at regex, this is what
the bash script is doing:

cat /proc/loadavg     | perl -p -e 's/^([^ ]+) .+$/$1/'

If you can explain what that's doing, I'd appreciate it. If it's not to your
liking, I can change it to something else.


Tim McGrath
--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKMc15EncCrqzVruAQIT1wgAhBnJeBayzoJ5fFtfEdU9W/Sa+I56UEPC
wuywEBTnjka3DRxkAX9w0c1aRbByCwqPKt8OjnGXrw61rzn0K1pnJFMv1zny1dGG
X8Ka3vHCpNVeTXO2/1tTr/oyN0qNgX0yCA7koVYPl6FPQx8wJqzAHM7ln5P+h1ow
Bsfb3K9BW1VJrbDN5JVlTKH0QuermVDclKHCKmr9fpFPrcY8zWUnWpRwIIQhCt3M
eOClAIA5NmvDg7O/35n4Vvx2t/G/00xGPFL8FTFcUm8NOYYGxWnnw+atwVcopzV7
jsBzqgea46FsLHEAQ4Jch9TW8ZcX8NNe3GjTn6gk8M4WaKJ9D+Ci2g==
=r2NO
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
