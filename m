Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0INEZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42958 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0INEZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:25:33 -0400
Date: Tue, 14 Sep 2010 14:25:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Don??u <mihai.dontu@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-Id: <20100914142528.1810936b.sfr@canb.auug.org.au>
In-Reply-To: <20100914040803.GB11972@kroah.com>
References: <20100914125431.1603ffd1.sfr@canb.auug.org.au>
	<20100914040803.GB11972@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_14_25_28_+1000_0q7_ZcH.DiaITSyA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_14_25_28_+1000_0q7_ZcH.DiaITSyA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 13 Sep 2010 21:08:03 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Sep 14, 2010 at 12:54:31PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > After merging the usb tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >=20
> > In file included from drivers/usb/gadget/ether.c:123:
> > drivers/usb/gadget/rndis.c: In function 'rndis_init':
> > drivers/usb/gadget/rndis.c:1163: error: expected ';' before 'if'
> >=20
> > Caused by commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB: gadget:
> > rndis: fix up coding style issues in the file").
> >=20
> > I used the version of the usb tree from next-20100913 for today.
>=20
> I can't duplicate this at all, are you sure it's coming from my tree?
> What is your .config here?

See above: that was an x86_64 allmodconfig build.  You need
CONFIG_USB_GADGET_DEBUG_FILES set.

The patch above was not in your usb quilt series when I fetched it
yesterday and it was there this morning.  The relevant hunk of the patch
looks like this:

@@ -1160,42 +1158,40 @@ int rndis_init(void)
 #ifdef	CONFIG_USB_GADGET_DEBUG_FILES
 		char name [20];
=20
-		sprintf (name, NAME_TEMPLATE, i);
-		if (!(rndis_connect_state [i]
-				=3D proc_create_data(name, 0660, NULL,
+		sprintf(name, NAME_TEMPLATE, i);
+		rndis_connect_state[i] =3D proc_create_data(name, 0660, NULL,
 					&rndis_proc_fops,
-					(void *)(rndis_per_dev_params + i))))
-		{
-			pr_debug("%s :remove entries", __func__);
+					(void *)(rndis_per_dev_params + i))
                                                                           ^
*** note missing semicolon ...

+		if (!rndis_connect_state[i]) {
+			pr_debug("%s: remove entries", __func__);
 			while (i) {
-				sprintf (name, NAME_TEMPLATE, --i);
-				remove_proc_entry (name, NULL);
+				sprintf(name, NAME_TEMPLATE, --i);
+				remove_proc_entry(name, NULL);
 			}
 			pr_debug("\n");
 			return -EIO;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_14_25_28_+1000_0q7_ZcH.DiaITSyA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjvk4AAoJEDMEi1NhKgbskQIH/iFTIyBgkaezbJu5/JoN6sJm
+jG+i1ePqxTxEqKjEb6lih0O/eH2YVu8P4ZTatU+r/eFruVp3PjK6L6/FKL/4J6d
bipvg2OGRP7CuZrp31lximK2ythUMqk+sB/GfuNNjPhdhJWBL68MraIiWqbZ3sd9
OtHxZy/6de7lVxK+Y1EjfFr4NJeBE6XdtTYlgiaVFQZxyCfYjwcwab7c6tizHcYc
uGkEl52gk6RlahEsOwjTRoNAmoJ4hxSjYXJxy5zzT2xCTQs3Rv4RsplEF0ja6goN
Tvgfc3JoGv6koVI/nzP2DSyN8JfJLT36q+ZgXxcTFby9x8BxIqUFsPrHfq2hoXA=
=T4cz
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_14_25_28_+1000_0q7_ZcH.DiaITSyA--
