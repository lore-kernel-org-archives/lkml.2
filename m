Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030689Ab2ERCud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:50:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2ERCuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:50:32 -0400
Date: Fri, 18 May 2012 12:50:10 +1000
From: NeilBrown <neilb@suse.de>
To: Andi Shyti <andi.shyti@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: otg: twl4030-usb: Don't power down phy when it
 is in-use by charger.
Message-ID: <20120518125010.582b191f@notabene.brown>
In-Reply-To: <20120513181409.GB2641@andi>
References: <20120508213518.2844.95446.stgit@notabene.brown>
	<20120508214040.2844.81364.stgit@notabene.brown>
	<20120513181409.GB2641@andi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rMri70LmOMVS6LxKq3hycuA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rMri70LmOMVS6LxKq3hycuA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 May 2012 20:14:09 +0200 Andi Shyti <andi.shyti@gmail.com> wrote:

> Hi,
>=20
> On Wed, May 09, 2012 at 07:40:40AM +1000, NeilBrown wrote:
> > @@ -388,10 +388,16 @@ static void twl4030_phy_power(struct twl4030_usb =
*twl, int on)
> >  					(PHY_CLK_CTRL_CLOCKGATING_EN |
> >  						PHY_CLK_CTRL_CLK32K_EN));
> >  	} else {
> > -		__twl4030_phy_power(twl, 0);
> >  		regulator_disable(twl->usb1v5);
> >  		regulator_disable(twl->usb1v8);
> >  		regulator_disable(twl->usb3v1);
> > +		if (!regulator_is_enabled(twl->usb3v1))
> > +			/* no-one else is requesting this
> > +			 * so it is OK to power-down the
> > +			 * phy.  Sometimes a charger might
> > +			 * hold the regulator active.
> > +			 */
> > +			__twl4030_phy_power(twl, 0);
> >  	}
>=20
> Usually a regulator line is shared by more than one device and
> regulator_is_enable() returns true if at least one of these
> devices is holding the regulator. This means that here the check
> will not work if this is your case.
>=20
> Andi

This regulator is inside an MFD and it only feeds a very limited number of
devices within that MFD.  So I don't think there is much room for confusion.

However is it a somewhat indirect method of signalling.  I want the charger
to be able to tell the USB controller that it is using the PHY so please
don't turn it off.  Doing that through the regulator seems simple and
effective.
Maybe there is a better way, but it isn't immediately clear what that would
be.
Suggestions welcome.

Thanks,
NeilBrown

--Sig_/rMri70LmOMVS6LxKq3hycuA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7W44jnsnt1WYoG5AQI3QA/+I4/SdXhKseUOwRZ3npdnWkFSECnq0Ayo
ubzOq6iKC715pqoSQdu0GwfhgqJlCqLQRU2LOviSEubt5WaHkiMRnS97nIfMmufL
W52/F75Ns4VkifkF0ysHRDCHVV5SEFRYzwLuaZJw3a8Y8fJAa1seeZCFwCjYzTEH
k5yO76wpMF59A4rNjHG5Mcp1QMxFPT6oJJ1lcZNqj1pPZG5j1dvLloiDmvas4eC0
f52mxe/4GuKU8GQ+xnKgmuWHZTnyBcSS6vqagBcuU82d0c42Z+nhLB8TPOrIDBay
rL6v4eRsvU1l/NRO+KsxBsswyA+q7X8VRDANkgWAbU97Y0InezHTWnrXLGbqyqHY
a0k51tKXexzTb1iXVdsn/zUPkY6qhBotMki2Y5dSjhzNHZ+xrSD0vE8nOBP4VNQb
bibL46JbzRKzmJgMfSZI8+0cJ6KDwo88XwopkRkP1+sMjmpZzkUWsmvw2WTiceRO
/Yu5p5DsmMzFJSK3h9fH5IeVAazsXi0rpqB79wbNcg0ztBRq7MIbwzaaSZn2AEvs
uvMGhD6QaR1PTK3mBpsTydX/hsdXjAp+ingxknAO41tSaXLkPQ1BglnTXN6/MDs6
ULqrKXXmSKxDmFBGxgMu2OS7sUb0S+sHxVhQwGXyuZgof2jLDCLF9ugeuuNhI5PK
JqGl99dJ8SQ=
=AE7H
-----END PGP SIGNATURE-----

--Sig_/rMri70LmOMVS6LxKq3hycuA--
