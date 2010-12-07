Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0LGBkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:40:40 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47778 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0LGBkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:40:39 -0500
Date: Mon, 6 Dec 2010 18:40:38 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Bryan Wu <bryan.wu@canonical.com>
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] MFD: TWL/TPS: fix twl_probe section mismatch warning in
 mfd/twl-core.c
In-Reply-To: <AANLkTimXPFROMQ_fF4Od-jw3aDY0WZQgc=x14=VcFM3d@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012061839170.13430@utopia.booyaka.com>
References: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com> <AANLkTimXPFROMQ_fF4Od-jw3aDY0WZQgc=x14=VcFM3d@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1320055421-1291686038=:13430"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1320055421-1291686038=:13430
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 7 Dec 2010, Bryan Wu wrote:

> On Tue, Dec 7, 2010 at 8:35 AM, Paul Walmsley <paul@pwsan.com> wrote:
> >
> > Fix the following section mismatch warning when building omap2plus_defc=
onfig:
> >
> > WARNING: vmlinux.o(.data+0x47d7c): Section mismatch in reference from t=
he variable twl_driver to the function .init.text:twl_probe()
> >
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> > =A0drivers/mfd/twl-core.c | =A0 =A02 +-
> > =A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> > index 35275ba..615cf38 100644
> > --- a/drivers/mfd/twl-core.c
> > +++ b/drivers/mfd/twl-core.c
> > @@ -969,7 +969,7 @@ static int twl_remove(struct i2c_client *client)
> > =A0}
> >
> > =A0/* NOTE: =A0this driver only handles a single twl4030/tps659x0 chip =
*/
> > -static int __init
> > +static int
>=20
> I think we might change __init to __devinit.
>=20
> > =A0twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
> > =A0{
> > =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 status;
> > --

That's fine with me.  Samuel et al, Bryan's already done a patch=20
for this stuff:

https://patchwork.kernel.org/patch/367011/

so we should use that instead, if you're happy with it.  Samuel, maybe we=
=20
could get an ack from you on it?


- Paul
--155748971-1320055421-1291686038=:13430--
