Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab0LNXKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:10:12 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:41693 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab0LNXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:10:10 -0500
Message-ID: <4D07F94D.8050807@web.de>
Date: Wed, 15 Dec 2010 00:10:05 +0100
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
Subject: Re: [PATCH v3 1/4] genirq: Introduce driver-readable IRQ status word
References: <cover.1292281184.git.jan.kiszka@web.de> <3575edb77b3e824f921b6fdbbe5a4fdb8a549e17.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142145480.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012142145480.12146@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig533F2A08170831BCB27B27A0"
X-Provags-ID: V01U2FsdGVkX1/B8FJUdIwL9+yGmRCs3f9nxZeKmYqKZ1+tRzwO
	88of8mWB+Do9L1Bt4otbVMhDBEp+BqhSjjxe/ZEpu7KN1oA5fa
	zrghONlF8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig533F2A08170831BCB27B27A0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.12.2010 21:47, Thomas Gleixner wrote:
> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>> +/**
>> + *	get_irq_status - read interrupt line status word
>> + *	@irq: Interrupt line of the status word
>> + *
>> + *	This returns the current content of the status word associated wit=
h
>> + *	the given interrupt line. See IRQS_* flags for details.
>> + */
>> +unsigned long get_irq_status(unsigned int irq)
>> +{
>> +	struct irq_desc *desc =3D irq_to_desc(irq);
>> +
>> +	return desc ? desc->irq_data.drv_status : 0;
>> +}
>> +EXPORT_SYMBOL_GPL(get_irq_status);
>=20
> We should document that this is a snapshot and in no way serialized
> against modifications of drv_status. I'll fix up the kernel doc.

Yeah, I think I had some hint on this in the previous version but
apparently dropped it for this round.

Thanks,
Jan


--------------enig533F2A08170831BCB27B27A0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0H+U0ACgkQitSsb3rl5xRrNwCeJb+g+zBGWrlNbF+uv5i7OPEz
sMAAoLTaeLgDgTLP32KDcr3McxeK6CUH
=i0l7
-----END PGP SIGNATURE-----

--------------enig533F2A08170831BCB27B27A0--
