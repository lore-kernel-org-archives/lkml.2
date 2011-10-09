Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1JIXeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 19:34:11 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41774 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1JIXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 19:34:09 -0400
Date: Mon, 10 Oct 2011 10:33:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: balbi@ti.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
Message-Id: <20111010103357.0039532470cdaa59c09d1803@canb.auug.org.au>
In-Reply-To: <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
	<4E8F67C6.5020603@xenotime.net>
	<20111008100326.GA24633@legolas.emea.dhcp.ti.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Oct_2011_10_33_57_+1100_9h.foZK1J75htygV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Oct_2011_10_33_57_+1100_9h.foZK1J75htygV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 8 Oct 2011 13:03:28 +0300 Felipe Balbi <balbi@ti.com> wrote:
>
> On Fri, Oct 07, 2011 at 01:57:42PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >=20
> > Move function to fix langwell_udc.c build error:
> >=20
> > drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
> > drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration o=
f function 'lpm_device_speed'
> > drivers/usb/gadget/langwell_udc.c: At top level:
> > drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types for=
 'lpm_device_speed'
> > drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit decl=
aration of 'lpm_device_speed' was here
>=20
> I don't have this compile error on my branch, did something go in
> without me noticing ?
>=20
> Can you blame a comit which introduced this ?
>=20
> btw, all I have is a warning.

The code in that file is structured like this (in linux-next and the usb
tree):

static ssize_t show_langwell_udc(struct device *_dev,
                struct device_attribute *attr, char *buf)
{
	...
	t =3D scnprintf(next, size,
                "Device LPM Control Reg:\n"
                "Parallel Transceiver : %d\n"
                "Serial Transceiver : %d\n"
                "Port Speed: %s\n"
                "Port Force Full Speed Connenct: %s\n"
                "PHY Low Power Suspend Clock: %s\n"
                "BmAttributes: %d\n\n",
                LPM_PTS(tmp_reg),
                (tmp_reg & LPM_STS) ? 1 : 0,
                usb_speed_string(lpm_device_speed(tmp_reg)),
                (tmp_reg & LPM_PFSC) ? "Force Full Speed" : "Not Force",
                (tmp_reg & LPM_PHCD) ? "Disabled" : "Enabled",
                LPM_BA(tmp_reg));
	...
}

...

static inline enum usb_device_speed lpm_device_speed(u32 reg)
{
	...
}

So this function is clearly used before it is declared.  What does yours
look like?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Oct_2011_10_33_57_+1100_9h.foZK1J75htygV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOki9lAAoJEECxmPOUX5FEY9oQAJbZG3aAI4rFVMTW9MA9QnzS
GIpbpu9aCSQcsHNo32PxjnKMBW3JI/6aMWruO30SgRt8knB4NoQhl+IfjrRvmg55
7sIisBBHVYgRHcuCdt+oJN3MbnKd7rLBy4rCKbdGqq9Z0Ad+XZCAz1m3kC3CHvvv
kybB4EVKUe5DxRlVsUY5BhRwMAsadhOknTW2KwGv8xVJ/MBDuKAM+JoML/co61sG
WWt29RXUDiGI9ok0k6zHPY8Xi3yht8TtAsR4yFQJmM4IDuv2gk40GG8TnwZ5QGY6
0RL02FDf37NSRezu+UIU3A0GWmb45F8wHCqKlUcJItvJoKLvIQVoC4km1LErOQ/Y
PTRk6qugb6q0Ac/ISf+Ew+gB/vSX42zdAAHTnE1GDmMQcP6qLw2VralDGwE4bafi
e05sfbPcxrWZFeDHKNeViVSChhKXA+xtctGjenTQLi/roj/0n3NEEWFxInytwy6Z
Siruc6hKQA/eX1ywzunTGbi55OODZx6ne7YxUSwERaVZW9Ih3KOoSWCVwsOhz6Am
ZlC9WtN51iUtJFSag0PNGgLy97qAqMKKjOyLZycnu5ME/U+j6Xa95i3BoRX3hGFU
tVnGvjtnG/CIov2GVmiuHNiWFDDP9FtvnWWaJBqfFdRxJTVP0wfhj5IWQJcnegeE
SkFIjCmOEiclEqmW1rYp
=8OP0
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Oct_2011_10_33_57_+1100_9h.foZK1J75htygV--
