Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1LMTTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:19:40 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48685 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753583Ab1LMTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:19:38 -0500
Date: Tue, 13 Dec 2011 10:42:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH][Regression fix] PCI / Hotplug: Always allow acpiphp to
 handle non-PCIe bridges
Message-ID: <20111213104220.5cfb78b2@jbarnes-desktop>
In-Reply-To: <201112130002.28907.rjw@sisk.pl>
References: <201112130002.28907.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hmM42Yq3po80//Do5VQVWgA"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hmM42Yq3po80//Do5VQVWgA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Dec 2011 00:02:28 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make
> acpiphp ignore root bridges using PCIe native hotplug) added code
> that made the acpiphp driver completely ignore PCIe root complexes
> for which the kernel had been granted control of the native PCIe
> hotplug feature by the BIOS through _OSC.  Unfortunately, however,
> this was a mistake, because on some systems there were PCI bridges
> supporting PCI (non-PCIe) hotplug under such root complexes and
> those bridges should have been handled by acpiphp.
>=20
> For this reason, revert the changes made by the commit mentioned
> above and make register_slot() in drivers/pci/hotplug/acpiphp_glue.c
> avoid registering hotplug slots for PCIe ports that belong to
> root complexes with native PCIe hotplug enabled (which means that
> the BIOS has granted the kernel control of this feature for the
> given root complex).  This is reported to address the original
> issue fixed by commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a and
> to work on the system where that commit broke things.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Applied to my for-linus branch.  I'll probably send to Linus on Thu. or
so.

I also rebased the breakage out of linux-next.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/hmM42Yq3po80//Do5VQVWgA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO55yMAAoJEIEoDkX4Qk9h/XcP/0aD28lCzFt7Qj6vdT1DNdXE
vVunIuEAjhXSCPf3o1YoolD51IveYNnqCSdwjFr2p4d2v9uV/zR9YOelyACE8pwn
3VkVW276x6SS7UJtJTUeFBOij/qf3rOFVz7mdf5z32IiKYh44VpuqwYM4fxHzs3a
kliDg5UGg5Jozj4LrYzGPuuCDG6D8CCH92uJtL6rJ0EumkCkPO8MSXmSw6txSEKq
74XKbd7h+8IFCFl1faPFYpF2v5v+40OXU9JJQc7V+ULce9BTGrZAKFgFS4xcVUV7
PAGM+VQAK8Fz4Dvfj/CaWEKpttV0k6+IY0WjO/pVt/V4KKp6dNyL//Cx3tWJI8au
CYT+qgKEodDa+95GAub1gUuhe20yjJzMcnlE3GjEwnMK+pvel1YE0R8jIhY8Pa/k
02zYWRmo6eZnG1w4Ft6iwg786Uain0fl4t+eV1+uRDw9VVAqkHFWf/Ys8K3np3KH
UgJdk3fkTrarlLIAL+Rfs/aUznrXqGzvzYXYfHm9FLuJix3a3AG9yjai4TVVFKmQ
ZtjtXhtSYpI2+5joF34XW2gEOCuYndbRDAUkapSr2BBc5lJI0wxZwcqC/DyuizdX
/AqzAwZL/9vkATcExXnwVpprnK44KxVE4yj1wYvzkG1klIZwW5dxzk4Y9mnS+2Nf
+oxa+G6kKT0sI5L/m3Hy
=Xq8s
-----END PGP SIGNATURE-----

--Sig_/hmM42Yq3po80//Do5VQVWgA--
