Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1JXVEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:04:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59010 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1JXVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:04:43 -0400
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wolfram Sang <w.sang@pengutronix.de>, Roland Kletzing <devzero@web.de>
Cc: adrian.hunter@intel.com, linux-mtd@lists.infradead.org,
        Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Date: Tue, 25 Oct 2011 00:04:15 +0300
In-Reply-To: <20111024195313.GA6326@pengutronix.de>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
	 <20111024055705.GA4020@1wt.eu>
	 <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
	 <20111024195313.GA6326@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Mt6x6GP4VKd/k7yBkYj5"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319490276.12314.9.camel@golum>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mt6x6GP4VKd/k7yBkYj5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > Anyway - what would people think if linux had a kernel module  which wi=
pes
> > /dev/sda1 when loaded ? :)

Yeah, the tests are destructive and they start erasing and torturing
your MTD device without preserving your data.

And the bad thing is - if you do not pass any parameter, they will
torture your mtd0.

I am sorry that you bricked your device and I hope you will be able to
resurrect it. This was an oversight. The tests were written for
validating new drivers and making sure they are robust. So we always
assumed people run them on a development HW, not on a production HW.
That was a false implicit assumption.

Yes, we should use -1 as the default value, and print a scary warning
message when the module is inserted without a parameter. We should
probably also put word "destructive" or something like this to the
module description.

--=20
Best Regards,
Artem Bityutskiy

--=-Mt6x6GP4VKd/k7yBkYj5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOpdLPAAoJEJtuLFy+q7fenwkIAJr+sLsgJcJCbNdqagPJTJsY
pU/6ZnKO3MGsypdvrpmHrVXkMxPieubQJm+jq/VIT8kbDeUAvd9wVRZf4DZi4EHO
a6xKhyGYfPDiZoWsh0QnQYKaloOWqsenCI5DlqGMsTb5/fU/8EEMgrgkEsBBdhHo
kF4LJgrHxwvWsqeWobf37FmbwgO74ssiHc9GPNFU1aOu5GjRaGyaAqKWJ06CEm9U
walMr3/cSlhWZCMY5b94+fIwr8gdJ6DIoGSShsG8HxzRj2/w9deG/nJrVQKOL7d1
DB+oqiqebhQFFBaoFhWAtKgS+H6zvs8i+dU6q6aQNDMNtbUjERuDCYxse2NL7s4=
=Bo34
-----END PGP SIGNATURE-----

--=-Mt6x6GP4VKd/k7yBkYj5--

