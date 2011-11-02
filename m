Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1KBU76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:59:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42535 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751479Ab1KBU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:59:56 -0400
Date: Wed, 2 Nov 2011 13:59:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] pci: Rework config space blocking services
Message-ID: <20111102135951.3bce8b08@jbarnes-desktop>
In-Reply-To: <33234f96f761babf0e61dfe2cb5fe87cadc98d60.1315846441.git.jan.kiszka@siemens.com>
References: <cover.1315846441.git.jan.kiszka@siemens.com>
	<33234f96f761babf0e61dfe2cb5fe87cadc98d60.1315846441.git.jan.kiszka@siemens.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/i7TBoQ+I71WOB_UzxnFwfE/"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/i7TBoQ+I71WOB_UzxnFwfE/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Sep 2011 18:54:02 +0200
Jan Kiszka <jan.kiszka@siemens.com> wrote:

> pci_block_user_cfg_access was designed for the use case that a single
> context, the IPR driver, temporarily delays user space accesses to the
> config space via sysfs. This assumption became invalid by the time
> pci_dev_reset was added as locking instance. Today, if you run two loops
> in parallel that reset the same device via sysfs, you end up with a
> kernel BUG as pci_block_user_cfg_access detect the broken assumption.
>=20
> This reworks the pci_block_user_cfg_access to a sleeping service
> pci_cfg_access_lock and an atomic-compatible variant called
> pci_cfg_access_trylock. The former not only blocks user space access as
> before but also waits if access was already locked. The latter service
> just returns false in this case, allowing the caller to resolve the
> conflict instead of raising a BUG.
>=20
> Adaptions of the ipr driver were originally written by Brian King.

Sorry to ask you to refresh these after so long, Jan, but can you
respin against my linux-next branch?

My inbox is a poor substitute for patchwork, but that's no excuse for
leaving you hanging so long.  Sorry!

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/i7TBoQ+I71WOB_UzxnFwfE/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsa9IAAoJEIEoDkX4Qk9hgGgP/jCGby/oBt5DAuS2mmaoGwQc
f0+jj1DoVyuKyLl5S7NhmImCVHpkN9ZO4MGpvM0ZFeLCza9TE1J3XEBz5lMNWrgb
AaFKo3/bhpvYkyb97C9m3ZPr5B0+RX1asGPGh2r2Zv9/vh/vqDKj/DcasVv1wQNM
joAKDvdD6LHeWQqJM1mKyOREYjckuehRv2OtWR7xtmzG4lFfbxQSOwsXJmuLu9Nb
hFvCGHTbYbUI5+ePYcZyEh+CTMqndGNRW6pHJ44625WAbvzOZ0wngzlrsZlukccU
zhfGC4+tvolxPhANviC/7gefpP2DStMYX65cPp+ANpQ1s5IrNV5AJHSqQ+yQBuZ3
8tw+Bx5QqTRf/vfm60tZiu3vAM8/mGjC6iGSbrZ4Hzx7RAJQzMRoiwnk/kZDDHQ7
TJqdPtRVVfZBGRx3u11+1St/mJULwwKS3XeELpzElZ2xBWq6nfdxdygxH3mZAW+E
e4B33rX8WJCxRzO4OoWnZ7XXdJDmcCx/7CG7T6fWFhh1Gk4ArPd32GDQlvId/W4M
gndverWe4HPBYAxfGE19Kruogh/v8uJtQKpUk3hjdPjKwMArU5Sjv8fmLNbeZnyF
56YfRUh0ODSBxFOO7xqiCgMUfijJZSTOfu2u/kA48AIFmlNQqgeow4GvhXjyD6t2
koS06VzyJKJFJ/fEjA9S
=YoCS
-----END PGP SIGNATURE-----

--Sig_/i7TBoQ+I71WOB_UzxnFwfE/--
