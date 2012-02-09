Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2BIV1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:27:22 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42019 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752825Ab2BIV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:27:20 -0500
Date: Thu, 9 Feb 2012 13:27:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Pasi K?rkk?inen <pasik@iki.fi>, mjg@redhat.com,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Stop the continuous flood of (XEN) traps.c:2432:d0
 Domain	attempted WRMSR ..
Message-ID: <20120209132715.2d1c0c9f@jbarnes-desktop>
In-Reply-To: <20120209212147.GE14007@andromeda.dapyr.net>
References: <20120203180952.GP12984@reaktio.net>
	<20120203185527.GA9290@phenom.dumpdata.com>
	<20120205194413.GR12984@reaktio.net>
	<20120209212147.GE14007@andromeda.dapyr.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4liGmi54FawsoUZLu5aCTz7"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4liGmi54FawsoUZLu5aCTz7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Feb 2012 17:21:47 -0400
Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:

> On Sun, Feb 05, 2012 at 09:44:13PM +0200, Pasi K?rkk?inen wrote:
> > On Fri, Feb 03, 2012 at 01:55:27PM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Feb 03, 2012 at 08:09:52PM +0200, Pasi K?rkk?inen wrote:
> > > > Hello,
> > > >=20
> > > > IIRC there was some discussion earlier about these messages in Xen'=
s dmesg:
> > > >=20
> > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from =
0x0000000000c800c8 to 0x0000000080c880c8.
> > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from =
0x0000000000c800c8 to 0x0000000080c880c8.
> > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from =
0x0000000000c800c8 to 0x0000000080c880c8.
> > > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from =
0x0000000000c800c8 to 0x0000000080c880c8.
> > > >=20
> > > > At least on my systems there's continuous flood of those messages, =
so they will fill up the
> > > > Xen dmesg log buffer and "xm dmesg" or "xl dmesg" won't show any va=
luable information, just those messages.
> > >=20
> > > Is it always that MSR? That looks to be TURBO_POWER_CURRENT_LIMIT
> > > which is the intel_ips driver doing.
> > >=20
> >=20
> > Yeah, it's always the same..
> >=20
> > > >=20
> > > > I seem to be getting those messages even when there's only dom0 run=
ning.
> > > > Is the plan to drop those messages? What's causing them?=20
> > >=20
> > > Looks to be the intel-ips. If you rename it does the issue disappear?
> >=20
> > I just did "rmmod intel_ips" and the flood stopped..=20
> >=20
> >=20
> > Btw on baremetal I get this in dmesg:
> >=20
> > [  745.033645] CPU1: Core temperature above threshold, cpu clock thrott=
led (total events =3D 1)
> > [  745.033652] CPU3: Core temperature above threshold, cpu clock thrott=
led (total events =3D 1)
> > [  745.034676] CPU1: Core temperature/speed normal
> > [  745.034678] CPU3: Core temperature/speed normal
> > [  849.678508] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 968=
2, limit 9000
> > [  899.614074] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 989=
6, limit 9000
> > [  899.722881] [Hardware Error]: Machine check events logged
> > [ 1172.675987] CPU3: Core temperature above threshold, cpu clock thrott=
led (total events =3D 78)
> > [ 1172.675990] CPU1: Core temperature above threshold, cpu clock thrott=
led (total events =3D 78)
> > [ 1172.677038] CPU1: Core temperature/speed normal
> > [ 1172.677042] CPU3: Core temperature/speed normal
> > [ 1174.260050] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 967=
6, limit 9000
> > [ 1199.339634] [Hardware Error]: Machine check events logged
>=20
> Jesse, and Matthew,
>=20
> Is there a way to make the intel_ips.c driver be in a "low-power" state?
>=20
> My first thought about fixing this was that we could allow the
> hypervisor to allow those RDMSR but the Linux kernel has no power to
> actually influence the power management (as the hypervisor is in charge
> of that) - so would the driver be capable of just sitting back and
> not influencing the CPU?

Yeah it's easy enough to turn off or disable.  But it doesn't currently
export any knobs for controlling behavior.  I don't have any issue with
exposing some though...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/4liGmi54FawsoUZLu5aCTz7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPNDozAAoJEIEoDkX4Qk9hNG8P/2O4qC/yeOchS+0rkzMnd6iS
+37M6Om9v+pe14NepikfVosYFMNEbDZftI4jdR4X/vWVONlKXIDt+Et77OyoR1oZ
MLvNSEBJ2rIRdyyXVyi9Y7Ypqpsx8F1d8PjtP+t6svaf+C1r9z+6vWAiF8U7KX10
rL5heVhCPdCXI93BHMTu4X2rWHKqFIIc0E89IdKZ19aXgUcBjUzaYwQDrR9oE5LP
dadhyv42is7jHYFp3EwelLcQP0kawtGMWiCYnOVPEss8AOcWC5IBbZSiYChXRRII
WhAVkI+mvpYntgtZUpspXLOEKJnGiH4uOAgzDD2B80gbZAzYcWewkNhkFpoJ94gP
+Ova2zguX0VHEM8uoeL+TQ9yHRely5euWLHBOGgFVczN6DafDCc4qYE73CgEYjjx
s77PHNJHUuD6U3A0Qg431A5gLxiHnpoKuIsmkEq2j1HdkuJbsCru6HAPH7rvx+jz
9qnCjbK0zf35QlVqWbonXJdNvPEXiec5LQmSP2Rq1FitZxhZUJwTOMDNU9CRWWfB
3HfxqdoMuFd9ic9fzzJKIqW2wOcPPPTJl5xuKxIpep76sfQ5wj++XnFhHhGCoqcN
rtnKTn8haMIgr/2AQwoLMT650HsBodWZibSq+qb+x0DQx9gSB9/UMLTpttDEDz6w
g5It+ECVoPZ+951Ut3U7
=U1xd
-----END PGP SIGNATURE-----

--Sig_/4liGmi54FawsoUZLu5aCTz7--
