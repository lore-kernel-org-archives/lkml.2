Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0KNJSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:18:47 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:36464 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0KNJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:18:45 -0500
Message-ID: <4CDFA96D.1060301@web.de>
Date: Sun, 14 Nov 2010 10:18:37 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com>
In-Reply-To: <201011021531.22886.sheng@linux.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B18957E2AC8B8658A10647B"
X-Provags-ID: V01U2FsdGVkX1+nnZjB7xC+YFvAhXUzYSW1vASZzmVovUZUPv8Y
	qJQNyJDBzH3j6GsQCZR8EAbyhlkxBQ3jEt2ZFTzSIiS1pEy0C9
	l9u0mGUIU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B18957E2AC8B8658A10647B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.11.2010 08:31, Sheng Yang wrote:
> On Tuesday 02 November 2010 15:05:51 Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Obtail the new pgd pointer before releasing the page containing this
>> value.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>
>> Who is taking care of this? The kvm tree?
>>
>>  drivers/pci/intel-iommu.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>> index 4789f8e..35463dd 100644
>> --- a/drivers/pci/intel-iommu.c
>> +++ b/drivers/pci/intel-iommu.c
>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
>> iommu_domain *domain,
>>
>>  		pte =3D dmar_domain->pgd;
>>  		if (dma_pte_present(pte)) {
>> -			free_pgtable_page(dmar_domain->pgd);
>>  			dmar_domain->pgd =3D (struct dma_pte *)
>>  				phys_to_virt(dma_pte_addr(pte));
>> +			free_pgtable_page(pte);
>>  		}
>>  		dmar_domain->agaw--;
>>  	}
>=20
> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
>=20
> CC iommu mailing list and David.

Ping...

I think this fix also qualifies for stable (.35 and .36).

Jan



--------------enig5B18957E2AC8B8658A10647B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzfqXQACgkQitSsb3rl5xQ0nwCgwqR+xLqadCpFKJq9IutkdEaG
hh0AniOLfRH8w3Uy94fnT8VT+OE+Xpem
=gI8i
-----END PGP SIGNATURE-----

--------------enig5B18957E2AC8B8658A10647B--
