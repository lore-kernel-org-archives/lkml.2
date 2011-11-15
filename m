Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab1KOWEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:04:45 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51086 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab1KOWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:04:44 -0500
Date: Wed, 16 Nov 2011 00:04:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111115220437.GA26711@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111115212012.GA5467@suse.de>
 <20111115130230.GA23584@mail.gnudd.com>
 <20111115213734.GA5094@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20111115213734.GA5094@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 15, 2011 at 10:37:34PM +0100, Alessandro Rubini wrote:
> Hi Greg. Thanks for looking.
>=20
> >> +/*
> >> + * The regset32 stuff is used to print 32-bit registers using the
> >> + * seq_file utilities. We offer printing a register set in an already=
-opened
> >> + * sequential file or create a debugfs file that only prints a regset=
32.
> >> + */
> >=20
> > Can this be part of the kerneldoc below somehow so that people are more
> > aware of it?
>=20
> Ok. There's also a file by Jon in Documentation that needs updating, as it
> has all the other debugfs file types.
> =20
> > +int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *reg=
s,
> >> +			   int nregs, void __iomem *base, char *prefix)
>=20
> > This function also needs to be part of debugfs.h in the "debugfs is not
> > enabled" section of the file, right?
>=20
> Not really. The other one makes a regiters-only file, and it's good
> to register it withouth ifdef.
>=20
> This one is used to embed a register block in a file with more
> stuff, so it shouldn't be used if debugfs is not selected (btw,
> I compiled my internal stuff with and without CONFIG_DEBUG_FS
> before rebasing to next).
>=20
> Example:
>=20
>    static int pl08x_debugfs_show(struct seq_file *s, void *data)
>    { =20
> 	[...]
>         list_for_each_entry(chan, &pl08x->slave.channels, chan.device_nod=
e) {
>                 seq_printf(s, "%s\t\t%s\n", chan->name,
>                            pl08x_state_str(chan->state));
>         }
>=20
>         /* dump registers */
>         seq_printf(s, "\nPL08x registers\n");
>         debugfs_print_regs32(s, pl08x_regs, ARRAY_SIZE(pl08x_regs),
>                                pl08x->base, "");
>=20
>         seq_printf(s, "\nPL08x registers channel\n");
>         for (i =3D 0; i < pl08x->vd->channels; i++) {
> 	[...]
>    }
>=20
> So, I'll post a V2 shortly, unless you refuse it in reply to this.

this will be useful to dwc3 too, we currently have:

struct dwc3_register {
	const char	*name;
	u32		offset;
};

#define dump_register(nm)				\
{							\
	.name	=3D __stringify(nm),			\
	.offset	=3D DWC3_ ##nm,				\
}

static const struct dwc3_register dwc3_regs[] =3D {
	dump_register(GSBUSCFG0),
	dump_register(GSBUSCFG1),
	dump_register(GTXTHRCFG),

	...
};

static int dwc3_regdump_show(struct seq_file *s, void *unused)
{
	struct dwc3		*dwc =3D s->private;
	int			i;

	seq_printf(s, "DesignWare USB3 Core Register Dump\n");

	for (i =3D 0; i < ARRAY_SIZE(dwc3_regs); i++) {
		seq_printf(s, "%-20s :    %08x\n", dwc3_regs[i].name,
				dwc3_readl(dwc->regs, dwc3_regs[i].offset));
	}

	return 0;
}

=2E..

--=20
balbi

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOwuH1AAoJEIaOsuA1yqRE6MsP/1g9kajYe1WO1NAjSF/tGre8
svVOYmUMTSRI6aPj1F0o8hHTr7ZV/LQhmcgcGdl/CMVUlY/l08uBD13sKzTJxVgM
966tG7rjiANjjkSzxku+PQcAQk9XAgSomvJADC3OT6xojGJvqYHKve0NdEpHvRI7
nvWVhtZs0YQ7Bsqp4BQK21cL9jfYr0M2fyKXQlrwTpJCS8MsgJckgTufgHq+Zn/C
6KxkxrRY9VDIRxWi8iePzy8HJaw7vpx1Zc4uaMZ1G3Vzx4ty8TpsVtLC+lhfPJTd
rETDlQ1YHmn+BhJlph4fSOlmjADLF3hybUsXrylANfCVMYWA/+dSccbC2j7ZXR/a
jKXRTR0fHz8SpiMLEMkAsi1XbExyFqIVD652rGvPWhbYa1HWrW/xvil7BxokcJQN
cQtHKR8U93/X5/nZq+wadZS/pwZQJJOCv93GSYL5zDmd9L9Fh2UHkJMoRpOrVP9N
5+JTUyb/CeUdTl87vDBGzlNs4d9MaTCJ0DQ+V4ApVyd98Z84Gid+imIHPrQSnIpO
SsucpduiL073/ecolnBOESA6ztAFxtjlepA7pPXw/a1JZ3dWJNvw3rvFi2NTLaum
2HDbsy8iKPqepPkQL2WSNDPT7VqBW1cW3zv9YAsDZug2U6K7Nq8EBTBb/Fw+t2Ra
LgBNZTWoYmzpYTQVDRl6
=o5mK
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
