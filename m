Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1KHLZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:25:32 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39174 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab1KHLZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:25:30 -0500
Date: Tue, 8 Nov 2011 13:25:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: hdrc: fix dependency on USB_GADGET_DUALSPEED
 in Kconfig
Message-ID: <20111108112523.GC6921@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320229079-27735-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline
In-Reply-To: <1320229079-27735-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2011 at 12:17:59PM +0200, Luciano Coelho wrote:
> USB_MUSB_HDRC depends on USB_GADGET_DUALSPEED.  If HDRC is selected
> but DUALSPEED is not, the kernel oopses:
>=20
> [    3.132781] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000000
> [    3.141296] pgd =3D c0004000
> [    3.144134] [00000000] *pgd=3D00000000
> [    3.147918] Internal error: Oops: 5 [#1] SMP
> [    3.152404] Modules linked in:
> [    3.155609] CPU: 0    Not tainted  (3.1.0-rc9-wl+ #417)
> [    3.161132] PC is at composite_setup+0x738/0xbb4
> [    3.165985] LR is at vprintk+0x400/0x47c
> [    3.170135] pc : [<c031df90>]    lr : [<c004c150>]    psr: 60000093
> [    3.170135] sp : c065dd50  ip : dfb1f0fc  fp : c065ddbc
> [    3.182220] r10: 00000000  r9 : df8fcae8  r8 : df8fcaa0
> [    3.187713] r7 : 00000000  r6 : df8eaa20  r5 : dfae8ea0  r4 : 00000000
> [    3.194580] r3 : df8fcae8  r2 : 00010002  r1 : c065dc40  r0 : 00000047
> [    3.201446] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segm=
ent kernel
> [    3.209228] Control: 10c53c7d  Table: 8000404a  DAC: 00000015
> [    3.215270] Process swapper (pid: 0, stack limit =3D 0xc065c2f8)
> [    3.221405] Stack: (0xc065dd50 to 0xc065e000)
> [...]
> [    3.415405] [<c031df90>] (composite_setup+0x738/0xbb4) from [<c0310d18=
>] (musb_g_ep0_irq+0x9d0/0xaf8)
> [    3.425109] [<c0310d18>] (musb_g_ep0_irq+0x9d0/0xaf8) from [<c030fb04>=
] (musb_interrupt+0xb48/0xc74)
> [    3.434722] [<c030fb04>] (musb_interrupt+0xb48/0xc74) from [<c030fc98>=
] (generic_interrupt+0x68/0x80)
> [    3.444458] [<c030fc98>] (generic_interrupt+0x68/0x80) from [<c0095204=
>] (handle_irq_event_percpu+0x9c/0x234)
> [    3.454925] [<c0095204>] (handle_irq_event_percpu+0x9c/0x234) from [<c=
00953e8>] (handle_irq_event+0x4c/0x6c)
> [    3.465270] [<c00953e8>] (handle_irq_event+0x4c/0x6c) from [<c0097e10>=
] (handle_fasteoi_irq+0xd8/0x110)
> [    3.475158] [<c0097e10>] (handle_fasteoi_irq+0xd8/0x110) from [<c0094d=
2c>] (generic_handle_irq+0x34/0x3c)
> [    3.485260] [<c0094d2c>] (generic_handle_irq+0x34/0x3c) from [<c0014ae=
4>] (handle_IRQ+0x88/0xc8)
> [    3.494537] [<c0014ae4>] (handle_IRQ+0x88/0xc8) from [<c00085b0>] (asm=
_do_IRQ+0x18/0x1c)
> [    3.503051] [<c00085b0>] (asm_do_IRQ+0x18/0x1c) from [<c0429e78>] (__i=
rq_svc+0x38/0xc0)
>=20
> This patch changes Kconfig so that USB_GADGET_DUALSPEED is selected
> automatically by USB_MUSB_HDRC.
>=20
> Signed-off-by: Luciano Coelho <coelho@ti.com>

applied, thanks

--=20
balbi

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuRGjAAoJEIaOsuA1yqREH8kP/1/b+bABKdz7LRxm70l4VxOC
zDWXb48eWhuqG+H9KBnX4uft7fUCYuUN1epAv+fiZ9Ye9a9ItA49VC5VFdKZ7fkV
2nJhQHu6TI0AbpNZJCYQ0acSMzGN9vYfQ6BOhqe9oAiaWrlQvla+ORCe08fXXUNA
ESXQHtEAtA1uNT9HlBpEKCiSufE52Amz7iVjejvUxSuIMoUkx+0vsNPpbYCUP1IZ
IPHgoMt8FQ8cANnRyTIrIX0c72J4PhuEQER7f5cjhpSbnMa0JZUjYjJMm30bpiBM
Qao7hTcZCIrLaDZ04l3NgKqXrNknqDPJhvC8wz5Xw8mSOCX32XT6T9e6os1oQF6G
JbXAipdjwDKZ2sR2zgV152aluRUepNFmqhCJGYd8PJAeL3GQVm6G4/rjEDgf/ggD
b8P3/cDZgdjZ+z0NlpN0kdNJpQ1mU7JWTpa8ht7NMT7U/Sq2ZL4iJXDOqY5ZnTHN
5iQ2xctcaj10jW9T7eJGrHS0Sss8UqtjRupBBF/uN9AK8tNBT1lvN3H+0JvXYcsP
rqjJc6EmNpMrnQnT94LyemPXG0oJyS9dpk+cv2Os6Pnx4MVhFTqjVWCdGOAcUtbj
g4NG4FK8XpRmNAJxpXL6bkL1Ke60G5jBLj91Y047aLfhR2IP1LhWByLuAtk8q9Gq
AtdWELzMq3RvuPIUrMab
=L7DS
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
