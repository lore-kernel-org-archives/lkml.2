Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1HYSwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:52:16 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:47310 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1HYSwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:52:14 -0400
Message-ID: <4E5699D8.3070505@web.de>
Date: Thu, 25 Aug 2011 20:52:08 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Brian King <brking@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
References: <4E54D5D7.8050807@siemens.com> <4E551298.2000302@linux.vnet.ibm.com> <4E5613BA.5070101@siemens.com> <4E5647DA.1060901@linux.vnet.ibm.com> <4E5648B9.7050106@siemens.com> <20110825181912.GB27183@redhat.com>
In-Reply-To: <20110825181912.GB27183@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCD2C24927CDA1EC728829095"
X-Provags-ID: V01U2FsdGVkX18O2/xfNsqxLLlzNAxKzJ2W65hkZBFh5jXpkhef
	cwgvmF/ENXnevf31CHsLmDnIK+lC7F6fh2CCWwG6D5e8LUN/9x
	1ML9V8PSU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCD2C24927CDA1EC728829095
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-08-25 20:19, Michael S. Tsirkin wrote:
> On Thu, Aug 25, 2011 at 03:06:01PM +0200, Jan Kiszka wrote:
>>> I took a look at the sysfs triggered pci reset function and don't see=
 any way
>>> that the controlling device driver ever gets to be involved in this r=
eset.
>>> If code outside the ipr driver were to reset the adapter, the adapter=
 firmware
>>> would be left in an uninitialized state and until scsi core starts ti=
ming
>>> out ops and driving EH, the card would be unusable. I can't imagine t=
he
>>> ipr driver is unique in this.
>>
>> Right, that's why a PCI core service is needed for coordination.
>>
>> Jan
>=20
> But why do we want to trigger reset through sysfs while the
> driver runs?

A perfectly valid race conditions are created by KVM and VFIO: shared
IRQ handler is triggered while the user space part wants to reset the
assigned device. I'm quite sure that this how I first caused this bug to
show up (it triggered for an assigned device with a shared busy IRQ line
during QEMU startup, ie. the initial guest reset).

Jan


--------------enigCD2C24927CDA1EC728829095
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5WmdwACgkQitSsb3rl5xQqbQCfUdKQbnMAC6VchdGVEx8d4BWe
2JsAoObt70vsa6/GvljH3QxgZSBVi+bN
=Pe2U
-----END PGP SIGNATURE-----

--------------enigCD2C24927CDA1EC728829095--
