Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab0LNXBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:01:22 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:59208 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0LNXBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:01:21 -0500
Message-ID: <4D07F738.8080204@web.de>
Date: Wed, 15 Dec 2010 00:01:12 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142243540.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012142243540.12146@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig245298DB062D05CC2ABA9269"
X-Provags-ID: V01U2FsdGVkX18G2DEciSJMsOJaWhgwZg39LrW7NIGiBL9gqiLK
	7qEP4ivo4XRHWDrnQXj1RuSYTnnMudh/Nx81RYIV4e9LFPFd4U
	JU7fFF2aM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig245298DB062D05CC2ABA9269
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.12.2010 22:46, Thomas Gleixner wrote:
> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>  	chip_bus_lock(desc);
>>  	retval =3D __setup_irq(irq, desc, action);
>>  	chip_bus_sync_unlock(desc);
>> =20
>> -	if (retval)
>> +	if (retval) {
>> +		if (desc->action && !desc->action->next)
>> +			desc->irq_data.drv_status &=3D ~IRQS_SHARED;
>=20
> This is redundant. IRQS_SHARED gets set in a code path where all
> checks are done already.

Nope, it's also set before entry of __setup_irq in case we call an
IRQF_ADAPTIVE handler.

We need to set it that early as we may race with IRQ events for the
already registered handler happening between the sharing notification
and the actual registration of the second handler.

Jan


--------------enig245298DB062D05CC2ABA9269
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0H9zgACgkQitSsb3rl5xSqaQCgllV4iEoXl3BH8cypYhb42kTW
EdYAoKyTZ0Cn/Sj6N3K/zoYAtnApFXC3
=Q03i
-----END PGP SIGNATURE-----

--------------enig245298DB062D05CC2ABA9269--
