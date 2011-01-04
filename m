Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1ADKmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:42:54 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:47618 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ADKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:42:52 -0500
Message-ID: <4D22F9A4.3050807@web.de>
Date: Tue, 04 Jan 2011 11:42:44 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
CC: Sheng Yang <sheng@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de> <4D01E677.5070702@siemens.com> <20101210184402.GE4040@sequoia.sous-sol.org>
In-Reply-To: <20101210184402.GE4040@sequoia.sous-sol.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7AD2655383A5E4EB169E613B"
X-Provags-ID: V01U2FsdGVkX1/q+ZiFO8SxZp21bLffkIo+vU8mhehlE9Q19+nD
	cNC7sWK3aT37lY34t6QC0Kz2u9sFJp4lmLDJLA6jkaHZWy8C9G
	+zKDAPt7Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7AD2655383A5E4EB169E613B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 10.12.2010 19:44, Chris Wright wrote:
> * Jan Kiszka (jan.kiszka@siemens.com) wrote:
>>>>> --- a/drivers/pci/intel-iommu.c
>>>>> +++ b/drivers/pci/intel-iommu.c
>>>>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
>>>>> iommu_domain *domain,
>>>>>
>>>>>  		pte =3D dmar_domain->pgd;
>>>>>  		if (dma_pte_present(pte)) {
>>>>> -			free_pgtable_page(dmar_domain->pgd);
>>>>>  			dmar_domain->pgd =3D (struct dma_pte *)
>>>>>  				phys_to_virt(dma_pte_addr(pte));
>=20
> While here, might as well remove the unnecessary cast.
>=20
>>>>> +			free_pgtable_page(pte);
>>>>>  		}
>>>>>  		dmar_domain->agaw--;
>>>>>  	}
>>>>
>>>> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
>=20
> Acked-by: Chris Wright <chrisw@sous-sol.org>
>=20
>>>> CC iommu mailing list and David.
>>>
>>> Ping...
>>>
>>> I think this fix also qualifies for stable (.35 and .36).
>>>
>>
>> Still not merged?
>=20
> David, do you plan to pick this one up?
>=20
> thanks,
> -chris

Hmm, still no reaction. Trying David's Intel address now...

Jan


--------------enig7AD2655383A5E4EB169E613B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0i+akACgkQitSsb3rl5xR6UgCfWIaBoTVCrNc/QdjO7ZhnZH/S
e8gAoNJpNIgaL8tG+QNTyl40bJCAk1j/
=3Hpu
-----END PGP SIGNATURE-----

--------------enig7AD2655383A5E4EB169E613B--
