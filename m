Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1JKIOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:14:07 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57270 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab1JKIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:14:04 -0400
Date: Tue, 11 Oct 2011 11:13:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111011081352.GC10155@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111010201055.GB8808@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110102010310.28007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110102010310.28007-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 10, 2011 at 08:15:29PM -0400, Alan Stern wrote:
> > > > > In fact we do already have sibling lists.  They are maintained as=
 part=20
> > > > > of the device_private structure.  What we are missing is a=20
> > > > > device_for_each_sibling() routine.  It could be added pretty easi=
ly; it=20
> > > > > would be similar to device_for_each_child().
> > > >=20
> > > > care to point out where is ?
> > > >=20
> > > > 68 struct device_private {
> > > > 69         struct klist klist_children;
> > > > 70         struct klist_node knode_parent;
> > > -------------^  Here.  The "parent" in the name refers to where the
> > >                 head of the list is stored.
> > >=20
> > > > 71         struct klist_node knode_driver;
> > > > 72         struct klist_node knode_bus;
> > > > 73         void *driver_data;
> > > > 74         struct device *device;
> > > > 75 };
> > >=20
> > > From device_add():
> > >=20
> > > 	if (parent)
> > > 		klist_add_tail(&dev->p->knode_parent,
> > > 			       &parent->p->klist_children);
> >=20
> > that's a parent -> child relationship. What we have on this case is:
> >=20
> >  --------------                ---------------
> > |              |              |               |          |\
> > |   UHH        |  clocks, etc |    USBTLL     |          | |
> > |              | <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> |               | <=
=3D=3D=3D=3D=3D=3D> | | <=3D=3D=3D=3D> ports
> > |     -------  |              | (Transceiver- |          | |
> > |    |  EHCI | |              | less Link)    |          |/
> > |     -------  |              |               |         Port MUX
> > |              |              |               |
> > |     -------  |              |               |
> > |    |  OHCI | |              |               |
> > |     -------  |              |               |
> > |              |              |               |
> >  --------------                ---------------
> >=20
> > It doesn't shown here, but the TLL link is completely optional. It's
> > mainly used for modem integration, IIRC. Still, if we're using TLL, EHCI
> > and OHCI will depend on a clock provided by the USBTLL block.
> >=20
> > Clearly, USBTLL isn't either a parent of UHH, nor a parent of EHCI/OHCI
> > blocks. We can, from a code perspective, make USBTLL into a parent of
> > UHH to make things simpler, but this will mean that calling
> > pm_runtime_get() will also unconditionaly turn on TLL clock, unless we
> > add some nasty hacks to allow TLL know if *HCI port is in TLL mode.
> >=20
> > That's why I decided for making TLL and UHH siblings, because that's a
> > closer relationship than parent-child.
> >=20
> > Can you see the problem now ?
>=20
> Okay, now I understand better.  The word "sibling" implies that the two=
=20
> objects have the same parent, so a different word would describe this=20
> relationship better.  Something like "friend" or "associate".
>=20
> Or maybe, following Paul's suggestion, the driver core doesn't have to=20
> be changed at all.

I see... I just thought that if there are other similar cases, it might
make sense to have a more generic way to make those two devices talk to
each other. But if you all agree that an EXPORT_SYMBOL_GPL() is enough,
then it's ok ;-)

thanks

--=20
balbi

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOk/rAAAoJEIaOsuA1yqRE/tAP/j274m5gGNEOrPkLy63yyHrY
YkPTmAaUtsKzMMIuEKFxLDPKXL6O9UEexx4tsLa3d9YtwHNDNsuO+swQsD6QIbxz
UM0IC9YkGU5aidrDO61JZQv1a8pp93+Uw9CBm78dIDON6Vkn8NLflymCw6O1a3Sy
XxUeFkYeSAQuSRB/BNLLOhJqfJwIIhRqJy24Iddrw1OGXlD862VLP+iCIvigMAk1
Bn8qJXGyCfxLPs+EqDLbAZLQUhjaCqii1V16h5OYCU94oa2rxjEg1tQFFxzAior3
EczdPrYeSU1ZwVdW4Ls5gvMxwb9zM8e1AImnKoc7iYAUIb/qkD3TEegKurHsWc8f
lQsPTplsLFYKXwhz3Pz8EdzrAofZ66JLI+0LvHTL6SWRhAqsH6G6C35S675ZUMwk
NUB7fpLS+xbh4m0yia3UmMi3VmtNcfIfiEfWvhsJJjSHryyDlvDahslX0YIaaQG4
BWMCB7LAaR019a9O9t7+XDk2Xzk38L89gTF6B1R4Qht0lqpYJdrvhKJp2Qz75OIg
8FXeHsXOhXAkR+JnPmzEt52jksBOuYLA46ZQxKL22WgB3GMhP0Gf8aLVwvyOpOx1
nIG4jzP8ffVVxUBJ3UDtjNkVkYPjgWGjHX/NkXjd+5DGSdaPDwxrVq8yewD3BepF
2Dc0X5o/py1YxEI5ZCWE
=NKjo
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
