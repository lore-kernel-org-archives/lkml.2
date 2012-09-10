Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2IJQsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:48:06 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:49687 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab2IJQsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:48:03 -0400
Date: Mon, 10 Sep 2012 19:43:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
Message-ID: <20120910164323.GK7464@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
 <1346943331-18120-2-git-send-email-kishon@ti.com>
 <5048C2A2.2020104@ti.com>
 <20120906171301.GC17754@arwen.pp.htv.fi>
 <20120906171803.GA30717@arwen.pp.htv.fi>
 <20120906195607.GB1303@atomide.com>
 <20120910155855.GE7464@arwen.pp.htv.fi>
 <504E127F.6020406@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6d1KVhp94hk3Jrm"
Content-Disposition: inline
In-Reply-To: <504E127F.6020406@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6d1KVhp94hk3Jrm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 10, 2012 at 06:17:03PM +0200, Benoit Cousson wrote:
> >>>>> On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
> >>>>>> The mailbox register for usb otg in omap is present in control mod=
ule.
> >>>>>> On detection of any events VBUS or ID, this register should be wri=
tten
> >>>>>> to send the notification to musb core.
> >>>>>>
> >>>>>> Till we have a separate control module driver to write to control =
module,
> >>>>>> omap2430 will handle the register writes to control module by itse=
lf. So
> >>>>>> a new address space to represent this control module register is a=
dded
> >>>>>> to usb_otg_hs.
> >>>>>>
> >>>>>> Cc: Benoit Cousson <b-cousson@ti.com>
> >>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>>> ---
> >>>>>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
> >>>>>>  1 file changed, 5 insertions(+)
> >>>>>>
> >>>>>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm=
/mach-omap2/omap_hwmod_44xx_data.c
> >>>>>> index 242aee4..02341bc 100644
> >>>>>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> >>>>>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> >>>>>> @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44x=
x_usb_otg_hs_addrs[] =3D {
> >>>>>>  		.pa_end		=3D 0x4a0ab003,
> >>>>>>  		.flags		=3D ADDR_TYPE_RT
> >>>>>>  	},
> >>>>>> +	{
> >>>>>> +		.pa_start	=3D 0x4a00233c,
> >>>>>> +		.pa_end		=3D 0x4a00233f,
> >>>>>> +		.flags		=3D ADDR_TYPE_RT
> >>>>>> +	},
> >>>>>
> >>>>> I do not have any objection/comment here, but I believe this is con=
trol
> >>>>> module address space required for USB module, right?
> >>>>> I am not sure this is right way of accessing control module space.
> >>>>> Actually Control Module Access required for drivers is one of the
> >>>>> blocking issue we have currently.
> >>>>>
> >>>>> Also there was some effort put up by 'Konstantine' to convert Contr=
ol
> >>>>> module to MFD driver, I haven't seen any further update on it. But =
it
> >>>>> would be good to check with him.
> >>>>
> >>>> this was an agreement with Benoit since we already lost a couple mer=
ge
> >>>> windows for this patchset. We agreed to wait until -rc4 for SCM driv=
er
> >>>> and if it wasn't ready, we'd go ahead with this and SCM author would=
 fix
> >>>> it up on a patch converting users to new SCM driver.
> >>>
> >>> Tony, can I get your Acked-by to this patch so I can take it together
> >>> with the rest of the series ? Thanks
> >>>
> >>> ps: I'll apply this to my 'musb' branch which is immutable, so it's s=
afe
> >>> to merge it into your tree once I apply.
> >>
> >> It would be best if this got acked by Benoit and Paul as they may
> >> have some other patches queued up. I'll ack if they ack ;)
> >=20
> > Benoit, care to ack this patch ???
>=20
> Gosh, that's hard to ack something like that :-)

btw, that's not different than what's already in tree, the only
difference is that now hwmod knows about it...

> But considering that the control module driver is not there yet, I have
> no choice but accepting that one if we want to have the functionality
> we've been waiting for years.
>=20
> Could you just update the patch with a big disclaimer on top of the
> address range to explain that this should not belong here and will be
> removed ASAP, when the proper driver will be done.

sure, that's doable... Kishon, can you do this ASAP ? I want to send my
pull requests tomorrow at the latest.

> Then you sign the patch with your blood and that should be fine for me
> :-).

I'm running out of blood already, but maybe there's enough for this last
one... 8-#

--=20
balbi

--d6d1KVhp94hk3Jrm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQThirAAoJEIaOsuA1yqRE8LAQAICQmQJ4muJwGBSpReg61SsB
fkpHE5+uHNIOculaxJzPu3X2XRJ0i+m/uhhhZYvlf7lz5EPAmtAug0/2odKcw+ru
FuLBIKS4aklpq08QS4PEA3NbQxTcvDoZdvEqfc0po9Jb8Dx29L+Y3JX8qe6hwSPL
RDzhtIQFUHuQ1g9vsYHm9EIYJ2XoTD4Za+VgsFj7jwDBx1veALJqgzpWi/U6YU0T
+Q8KHtAX75NHyG+6e+fkSioC/rT3O4+6Q9ivW/da9vc3dsMWOGbaiVtnKx2EUEwa
XNpysmWA958roEZu+uXLvWr0LrVVbQ+/I9m5CEG8Ucxc9uQe0oAt1Wh+DxQb2VZd
M9RSrCp2jOtMlEZJZJtvr2lxgj/Q/6rRIyI1ifYOlec5PvwMDEQbHv/z0f+0gGjw
Mj8rhanwtkiO+chfYL2+smZfPcO0x/+7YFSt7K5LFybkSORwaF7SSEr4KcnZKSnA
wFS2dEhx/zzYLaPH9GFNdr3z3AcDW9z3ivGTadgYVyeISWKM/Wd66/LXj6N8cVrz
Z42/ZpeSKCcLDzw1TJnwo7X9J7t/pQbh1bXqyfOHuK6DXyWzu3SLH1356nxZNbUA
cnISQYfDcXHth9ChAVLJEaWFlWNOHD1M4qfeINEIRarlzf4EeF0+PGk5SWCWfcRA
IJZS1SxyLvvD1jemAkc+
=cwFg
-----END PGP SIGNATURE-----

--d6d1KVhp94hk3Jrm--
