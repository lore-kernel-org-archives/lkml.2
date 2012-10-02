Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab2JBETy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:19:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53341 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2JBETw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:19:52 -0400
Date: Tue, 2 Oct 2012 14:19:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: linux-next: manual merge of the xen-two tree with Linus' tree
Message-Id: <20121002141949.f6e61437bdce0d56d9d4321e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_14_19_49_+1000_JIGO8hj8TisqS859"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_14_19_49_+1000_JIGO8hj8TisqS859
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
drivers/xen/Makefile between commit 9fa5780beea1 ("USB EHCI/Xen:
propagate controller reset information to hypervisor") from Linus' tree
and commit 13febc84849d ("xen: do not compile manage, balloon, pci, acpi,
pcpu and cpu_hotplug on ARM") from the xen-two tree.

I fixed it up (I am not sure exactly what it should depend on - see
below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/xen/Makefile
index a4a3cab,cd28aae..0000000
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@@ -4,8 -8,11 +8,12 @@@ obj-y	+=3D xenbus
  nostackp :=3D $(call cc-option, -fno-stack-protector)
  CFLAGS_features.o			:=3D $(nostackp)
 =20
+ obj-$(CONFIG_XEN_DOM0)			+=3D $(dom0-y)
+ dom0-$(CONFIG_PCI) +=3D pci.o
++dom0-$(CONFIG_X86) +=3D dbgp.o
+ dom0-$(CONFIG_ACPI) +=3D acpi.o
+ dom0-$(CONFIG_X86) +=3D pcpu.o
  obj-$(CONFIG_BLOCK)			+=3D biomerge.o
- obj-$(CONFIG_HOTPLUG_CPU)		+=3D cpu_hotplug.o
  obj-$(CONFIG_XEN_XENCOMM)		+=3D xencomm.o
  obj-$(CONFIG_XEN_BALLOON)		+=3D xen-balloon.o
  obj-$(CONFIG_XEN_SELFBALLOONING)	+=3D xen-selfballoon.o

--Signature=_Tue__2_Oct_2012_14_19_49_+1000_JIGO8hj8TisqS859
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQamtlAAoJEECxmPOUX5FEGskP/2TNkrb1IoRLKl4jpeYUxWWL
HKarVz3pfRrRKoYQd927YcWdPI9SOGJ7LEHE92jXyqBT4zCdBhDmtaFIoMGsoTpj
B5gemmFUEeq41RFOSgrpEJSP5KJBA521XWvb3hPa3Vi/29zWh+ggE9RCs4yY1XFr
mBcIPSBBiwCxzqAOHuUbVBY+jybTZohf2qBYz95PbPk6LoFxqu6YbK9Ew+l+6lro
ms01glqegLOhJUlF4uWyDF6YBz+fMzot6mWHpn0LS89flK1d0akms3vSx8t02pvV
f1K2kOU4FpLFVquU17Gjz5Gv6qYIHV7xAwslekZl4d+L41LlTmd+jANXRaWRxnxh
6shkN60Knechjfxc22FPj0up6tDYbucdkzYiNqm6uDpwksZjItXpGIleU4Mk9f1q
1vU4lrDiG7P6qG2NGnGXstqC7Me36v9bzn1sIctnhPihgTALKv9dHZfaVr6f+oda
nhxtsNj864PxHGPAG8sLwU8SOlBRwbeev6hElns5w8Pp+HEVFnUtGJSepxzEu/Sh
Ng3KU+PIQCz6UUkhlltqMU35N5nDteMDF6tRtt5A1o2IjhkyYNYSbC1Bdb7d5VDf
InKsZ0MN9fDJb2GyuYMR18B9BiIyFbAbeRR3iUu3+CKf8MpmTPVdcpXffFoK1djT
SSXQYjX98JChEE9e896v
=3s2g
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_14_19_49_+1000_JIGO8hj8TisqS859--
