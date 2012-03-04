Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2CDN36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 08:29:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52210 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab2CDN34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 08:29:56 -0500
Date: Sun, 4 Mar 2012 13:29:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v6 2/2] Regulator: Add Anatop regulator driver
Message-ID: <20120304132953.GB3083@opensource.wolfsonmicro.com>
References: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
 <1330671641-6439-1-git-send-email-paul.liu@linaro.org>
 <1330671641-6439-2-git-send-email-paul.liu@linaro.org>
 <20120304065145.GD10743@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20120304065145.GD10743@S2101-09.ap.freescale.net>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 04, 2012 at 02:51:48PM +0800, Shawn Guo wrote:

> > +	sreg = devm_kzalloc(dev, sizeof(struct anatop_regulator), GFP_KERNEL);
> > +	if (!sreg)
> > +		return -EINVAL;
> > +	rdesc = devm_kzalloc(dev, sizeof(struct regulator_desc), GFP_KERNEL);
> > +	if (!rdesc)
> > +		return -EINVAL;

> Would something like the following be better?

> 	sreg = devm_kzalloc(dev, sizeof(*sreg) + sizeof(*rdesc), GFP_KERNEL);
> 	if (!sreg)
> 		return -ENOMEM;
> 	rdesc = (struct regulator_desc *)(sreg + 1);

No, that sort of pointer arithmetic would be much worse - it's harder to
read and more likely to break.  However, embedding the regulator_desc in
sreg would achieve the same result without the legibility issues.

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPU25LAAoJEBus8iNuMP3d1BAP/iOkeLZUUd181n7ORmxaaFae
lArFZZyqOeXQfgAJ45I+1uDuV4b4dfJCCzQ0+TyRvxUqOB6z1xmPJVcP25sZZX7N
0chXfq9rpH1nNgL6aKH5GArMHYlnCuR/YM5TXsG6480zN9DkdQkga+EEyXCowX4+
YCPXmQXCTP63SHHFqjZaDdIUh7YBgkN1qgxgaUsFdL9IRrZgUIIavN+sN3Weuu7g
+mF99q4UoIC8cdhbG2gB4OUXhKmO1amDtnBRdbIfCvXERPBXlHmxMsBL+pF7cqSP
jT44WuG0rMOtcGSigpgNQfhdDvBsyh0hsUo5wQ2OTSsxE5sQJKnLQpwOlQ4o8TZu
R54ApRjDPJizxOOfi6IxQl4b+yth6GoFoJb5cU9gxe4OV+zYCX/BT1SWs2jCRnna
3BsLxfI80500A+2yUTYMFZi91eFgRaRgoQ5gwtuo5WQ/SKlhLQvhyfT415bXI241
TnciKidhN1FUdU2Y+oaoY93xzHdwncKhhRHngyvEvYqS2DnxuOTF7fFxaghlqxN6
0ie+4zwkl3PbIsMNSMGQThAQUs2yqnKNLjuieoEc5LuBoMsuhjJDQREh2ZC2w2Nd
Hm4WYD05C0MttIr+0ds2Jc0PKA+zL5Mx8wAN5BmhD3Jp0MzYFc6FNJ65z0nL7gde
Ak0rI+R1SSCnIP0U29k8
=c2wS
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
