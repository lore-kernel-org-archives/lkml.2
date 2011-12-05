Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1LETDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:03:53 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49123 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932159Ab1LETDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:03:50 -0500
Date: Mon, 5 Dec 2011 11:06:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pci: Rework config space blocking services
Message-ID: <20111205110623.0eeaa2ec@jbarnes-desktop>
In-Reply-To: <693bbd2bcf55f839d6dc4b7b002dd1827214bf1f.1320396359.git.jan.kiszka@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
	<693bbd2bcf55f839d6dc4b7b002dd1827214bf1f.1320396359.git.jan.kiszka@siemens.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_tyQgg6dL2ArbgXgVwdS6X/"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_tyQgg6dL2ArbgXgVwdS6X/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  4 Nov 2011 09:45:59 +0100
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

Applied this series to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/_tyQgg6dL2ArbgXgVwdS6X/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RYvAAoJEIEoDkX4Qk9hZyIP/i1yZ0JftIAUlTuroMlyKwzh
bG4apRW7//sp4FTJvLYn5btZfN44uxtgFyxYxRFGEWUwtzLO5HYgJop1PNVPL57t
HrQewqmNDQhWFhK+tR/7SXdxo7XICHMlGcZcX6OCet22m62PZRnY8A3O1TKoN1We
wMJGY//rPh5/SK6nfkmHuwbP3rJTUJSlNZklV1MHN5gp91angikF4qanMhj0KTjD
tqILYffBItd/Qrv494q6RnlMMIrASBY9Y/kzQJE6aHPowIx49cwj9wZUQohjSKf7
cOV5aRUaWbyZ2tb43XjrC5yE+LlQK7YdW2+b2goea8iQeHL+BcZWErhJw23JAFq/
3F2IcGwIYizBGVit3NxArjFNagki6oOYBGUslXl6me5tDjFWadZGUP+aSzgTGO80
y9CPGrhnnWBlQ84o6Fx8wN2n/N7RMNsmkF9XgbunO5Hb3WtjDUL2aApF8pnBf4tr
Rc9Ml/50YPZrtbiwbtlMYlt1EmyvP+92nA8fNY6bSL/txGZ36PV85PFxr9FkaTfo
7TN6MFZPm4vo4JediCsLPBwK0vTwyFgRkOappoLE/kcqAhrZjGckgEzh/+sUPGp0
tzsv3C42t+HBJRXBZwhud3A3L8wgMR3xPg1wTpVMO8hjGfLitQX6pFofWV988Duh
xVkFXN6rRTKIKW15h1J5
=m5Tj
-----END PGP SIGNATURE-----

--Sig_/_tyQgg6dL2ArbgXgVwdS6X/--
