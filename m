Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1HYT0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:26:13 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:42138 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1HYT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:26:09 -0400
Message-ID: <4E56A1CF.5050008@web.de>
Date: Thu, 25 Aug 2011 21:26:07 +0200
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
References: <4E54D5D7.8050807@siemens.com> <4E551298.2000302@linux.vnet.ibm.com> <4E5613BA.5070101@siemens.com> <4E5647DA.1060901@linux.vnet.ibm.com> <4E5648B9.7050106@siemens.com> <20110825181912.GB27183@redhat.com> <4E5699D8.3070505@web.de> <20110825190748.GA30587@redhat.com>
In-Reply-To: <20110825190748.GA30587@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0C8617C4E00E75C7A1B96656"
X-Provags-ID: V01U2FsdGVkX1/Ldi/7rtsjeLHfAjl/ApvT7/GLSa/a7nsZ6VmN
	ZoqYZxIGYA3gUqTedsQl+vXZ4hGs/3/d2l/S7BCuVGyIkTrDOh
	GZHBPU6yE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0C8617C4E00E75C7A1B96656
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-08-25 21:07, Michael S. Tsirkin wrote:
> On Thu, Aug 25, 2011 at 08:52:08PM +0200, Jan Kiszka wrote:
>> On 2011-08-25 20:19, Michael S. Tsirkin wrote:
>>> On Thu, Aug 25, 2011 at 03:06:01PM +0200, Jan Kiszka wrote:
>>>>> I took a look at the sysfs triggered pci reset function and don't s=
ee any way
>>>>> that the controlling device driver ever gets to be involved in this=
 reset.
>>>>> If code outside the ipr driver were to reset the adapter, the adapt=
er firmware
>>>>> would be left in an uninitialized state and until scsi core starts =
timing
>>>>> out ops and driving EH, the card would be unusable. I can't imagine=
 the
>>>>> ipr driver is unique in this.
>>>>
>>>> Right, that's why a PCI core service is needed for coordination.
>>>>
>>>> Jan
>>>
>>> But why do we want to trigger reset through sysfs while the
>>> driver runs?
>>
>> A perfectly valid race conditions are created by KVM and VFIO: shared
>> IRQ handler is triggered while the user space part wants to reset the
>> assigned device.
>=20
> OK, that would be solved by blocking sysfs reset while
> config access is blocked, right?

=2E..and VFIO's reset IOCTL. And any other potential pci_reset_function
caller. And you still need to synchronize those config space accesses
that don't wait for the block_ucfg_access while some reset is being
performed. This really screams for a redesign of config space locking.

Jan


--------------enig0C8617C4E00E75C7A1B96656
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5Woc8ACgkQitSsb3rl5xTxLACdGd4FoH8a04bfkB1y9kD4jE5D
1zAAoMvmPEonflpSMkbMK0EXJ+/micrN
=9ozw
-----END PGP SIGNATURE-----

--------------enig0C8617C4E00E75C7A1B96656--
