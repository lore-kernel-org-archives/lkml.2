Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2KLHYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:24:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2KLHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:24:20 -0500
Date: Mon, 12 Nov 2012 08:24:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
Message-ID: <20121112072410.GA925@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
 <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
 <509D28B6.3060207@vodafone.de>
 <20121110210118.GA26809@avionic-0098.mockup.avionic-design.de>
 <20121111144644.GK5854@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20121111144644.GK5854@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:L29sObTMsUX1VA993120G1CYD0rT8ifdJmXsiBdHnw3
 5tWeAl+YOWWnTIu5MBtzo3XFTp/5dw4BvfWElLlyIzbuCNBoBO
 Rq1JblF100hMT77g/G6n0wq3p+h92sUtCTeB/dJvtzoWZ0pxdj
 mYmHEljmn9D/YaKjnFwipbCAQc5WgAxWgHFWuCzufpmjjxCQ2g
 iuVTjf4ArAVutYQSnbB4xqP3u797LESZ1T32n9teruzK2YbCRj
 3HKWNtDkj+nOXV19vkC2g1POpGwT2+5iS3OZhFVPncEv7mGUwd
 pPPV75MlXCi7MT8wX4oS7zeKyNW+qpoO7dqBNLwOXjNuyz5Ll7
 qosA2YfFUHwlYo7+oyNIa5e88c2TbQFA4aWzl6tdCA1YGzWwnU
 8QQ9AWnPoB6Edlyy//mIRs1H3Y8EzouRGM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 11, 2012 at 03:46:44PM +0100, Daniel Vetter wrote:
> On Sat, Nov 10, 2012 at 10:01:18PM +0100, Thierry Reding wrote:
> > On Fri, Nov 09, 2012 at 05:00:54PM +0100, Christian K=C3=B6nig wrote:
> > > On 09.11.2012 16:45, Rafa=C5=82 Mi=C5=82ecki wrote:
> > > >2012/11/9 Thierry Reding <thierry.reding@avionic-design.de>:
> > > >>+/* all fields little endian */
> > > >>+struct hdmi_audio_infoframe {
> > > >>+       /* PB0 */
> > > >>+       u8 csum;
> > > >>+
> > > >>+       /* PB1 */
> > > >>+       unsigned cc:3; /* channel count */
> > > >>+       unsigned res1:1;
> > > >>+       unsigned ct:4; /* coding type */
> > > >>+
> > > >>+       /* PB2 */
> > > >>+       unsigned ss:2; /* sample size */
> > > >>+       unsigned sf:3; /* sample frequency */
> > > >>+       unsigned res2:3;
> > > >>+
> > > >>+       /* PB3 */
> > > >>+       unsigned cxt:5; /* coding extention type */
> > > >>+       unsigned res3:3;
> > > >>+
> > > >>+       /* PB4 */
> > > >>+       u8 ca; /* channel/speaker allocation */
> > > >>+
> > > >>+       /* PB5 */
> > > >>+       unsigned res5:3;
> > > >>+       unsigned lsv:4; /* level shift value */
> > > >>+       unsigned dm_inh:1; /* downmix inhibit */
> > > >>+
> > > >>+       /* PB6-10 reserved */
> > > >>+       u8 res6;
> > > >>+       u8 res7;
> > > >>+       u8 res8;
> > > >>+       u8 res9;
> > > >>+       u8 res10;
> > > >>+} __packed;
> > > >I was told it won't work on different endian devices. See
> > > >[RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
> > > >http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html
> > >=20
> > > Yeah, that's indeed true. And honestly adding just another
> > > implementation of the HDMI info frames sounds like somebody should
> > > finally sit down and implement it in a common drm_hdmi.c
> >=20
> > So I've been looking at what most other implementations do and it seems
> > a lot just fill the AVI infoframe with zeroes while only a few actually
> > try to put useful information in them. Still in order to plan for a
> > generic solution, I thought maybe something like the below set of
> > structures and functions could work:
> >=20
> > /*
> >  * Structure that contains the infoframe fields in a form that allows t=
hem to
> >  * be easily accessed from C code.
> >  */
> > struct hdmi_avi_infoframe;
> >=20
> > /*
> >  * DRM helper to fill a struct hdmi_avi_infoframe with information take=
n from
> >  * a struct drm_display_mode. Fields that cannot automatically be deriv=
ed by
> >  * looking at a struct drm_display_mode are set to the default values.
> >  */
> > int drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe =
*frame,
> > 					     struct drm_display_mode *mode);
> >=20
> > /*
> >  * Packs the struct hdmi_avi_infoframe into a binary buffer that can be
> >  * programmed to the hardware-specific registers.
> >  */
> > ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame,
> > 				void *buffer, size_t size);
> >=20
> > Such a scheme would allow DRM drivers to call the helper and tweak the
> > fields in the structure if the want or need to and call the packing
> > function to obtain a buffer that they can write to the controller.
> >=20
> > Does that sound at all reasonable?
>=20
> Sounds good, especially the disdinction between the infoframe creation and
> packing. E.g. on intel sdvo outputs we may not put in one of the ECC bytes
> (since the hw creates it), so we need our own packing code there.

Actually what I had in mind was a packed binary representation of
infoframes as specified by HDMI 1.3a (I don't have access to 1.4, but I
would think it doesn't differ in this respect) in section 5.3 and 5.3.5
more specifically. According to the specification, the ECC bytes only
come into play at a later stage, when data is actually transmitted on
the TMDS link (Section 5.2.3). Tegra, nouveau and radeon also seem to be
doing the checksumming in hardware, so I guess we don't need to compute
the ECC bytes in software at all (for now).

Once we have this for the AVI infoframes I guess the same concept can be
used for audio infoframes and for vendor-specific infoframes (for HDMI
1.4 3D).

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoKQaAAoJEN0jrNd/PrOhvWUP/1PaUFUAaXUBC4pa221xson6
nQGg4XHJgKZ2HhhMj5SmpcfFPcPaCaZM7Qe/AZ8vISNhB2DQUsqsevlHuUaNe53I
ESbIOsm8w7HQ9ricqJp4Rv4vdk5GQBQsNVqWlogNUPoAV/XOkiFWZJwm2Mx7N/O3
nDx3GI0dULYaeG42/r8qR3eB80TzQR8+d3oQDJ3xCWAzjEV6wmapoxva0hnOS8hQ
ngjgbG8yXPP/F+bxCdjs5wSR4UehoWIslB0SQE8dVUeHZPoa0A1odopcWlqBp0mU
dBIBp8jJ+zl9h+RONDtHNk0QT6+/C30CyaJA4HfSN0g458UqXTAObQt2OYtVNoMZ
X611GCVQRGD6lPN96pINqEkTxZ8MWWwMdEhtcOEtwsPvwKBO/VjCB3D95G5//A/F
ZHqX7WxVmdM/zXjm9JK9li7V2x78MPiH9FvgWulXjcGRTNf6FGfkQHKqa7jGsnw+
auOECCqApfhlCvA7PTK9o2bcg1iI2FePOfTbtQFFF+EbKKSrb15VRhOJoclr5RS3
b/7A2YqYA0bKgHEipOGQUs8/xx2KI3VMtez+MsEStXUk0eIWrJJWsQYiNdFJwXWo
hZ4y2VEAb3R4ndRMCwNAiKH6NKGCBkpuPlOqkr84+JErHxfmD5sqvdCX7rKeKJRO
j8cyCc+ddGxIWKVfu3n8
=yx68
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
