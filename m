Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab2DEIiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:38:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab2DEIiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:38:10 -0400
Date: Thu, 5 Apr 2012 09:38:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] regmap: add MMIO bus support
Message-ID: <20120405083805.GA3129@opensource.wolfsonmicro.com>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
 <1333576113-13196-4-git-send-email-swarren@wwwdotorg.org>
 <20120404225915.GH10787@opensource.wolfsonmicro.com>
 <4F7CD61E.8000609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <4F7CD61E.8000609@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 05:15:42PM -0600, Stephen Warren wrote:

> I assume the solution here is to:

> * Always use __raw_readl/__raw_writel in regmap-mmio.c so that there's
> never any endianness conversion, and don't use the endianness conversion
> macros when reading/writing the work buffer.
> * Implement alternative formatters that format in LE instead of BE
> * Add a field to regmap_config indicating which endianness the data
> should be in, and use this flag to select the LE/BE formatters.

> Does that sound about right?

Sounds about right, yes - probably worth having a third option for the
formatting which does no translation for on-SoC device.

> > Given that you constrain on registration too this should be BUG_ON(),
> > we're seriously confused if we're specifying a different register size
> > here and -EIO is going to be a bit obscure.

> I wondered about that. I would have been quite happy to repost with that
> change. Do you want an incremental patch?

Yes, please.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfVmzAAoJEBus8iNuMP3dgRUP/1Jt2TPypc8n+39xeoyNt2gk
F7qFQp4LEhJW/L/m8YaSRXO5vMCQaObhztyC9ObQcHnF7cSV5rYRL9e1zalT8InS
KIIFyzTjEacYDUPdjZP9YToMGU3aEbVY02Azo0Q2ZJ3aBk7aHtxR6Ii1Jmr7DJpI
cIr/E7iV3H3YBnqnUGmTkxuuLFCqtNUFJDT8ovnhUbXXaMujWHq/KDGtkS7lOEzh
ea6Nr/MnyZF3iUMXQ/EKoQtL8soebV9j+8SOPwP5HPRCVOhAWmkY6/hurXyTq6is
Sd+UAMyXo4wZmUDicCrOIybolmVzcExwGQ5p216UUge3624cWZGBPHacV72F7C2k
/RvhvvPYXbxvYHWWRRga2lp8Zen6q928mRsCBG71vkIzxq26IWkYT1umUFbZhnZK
QJY6Rt+C/5C0JK4fYZ1I420XOyQA4UW1GfX2LHcal1vPJslOx7TNxvklQ+M0MZg7
c1xdIN+K64SUy1HpKyZ4U+9M+fb8FmDEBC++DvONVLMz5lmJ5OatMpBl8VoclknU
CL8zgtpovhmjjF65MMAprVmJ/M+NQ9/RaNZ56OqSu50p1CdvC3SUE/5BVTOpsAu+
GzA5sXyMNAMMkPlo1FvdSZmVZFe2Y7vOxAhyYOIM8F0yJfAEkzlG6tRM3COzDuwm
o7FbNB55VLE1newPvhhU
=uY/f
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
