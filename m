Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0LLVvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 16:51:52 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50134 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0LLVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 16:51:51 -0500
Message-ID: <4D0543EE.7010007@web.de>
Date: Sun, 12 Dec 2010 22:51:42 +0100
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
Subject: Re: [PATCH v2 1/4] genirq: Introduce driver-readable IRQ status word
References: <cover.1292152963.git.jan.kiszka@web.de> <0b28922dfb7f5791fcb1866a0f1c033bacb8f4d8.1292152963.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012121747000.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012121747000.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43E0B7EC0286221978962B5A"
X-Provags-ID: V01U2FsdGVkX1/hhaxoTNAca/ZEAJRGtJ00tWlsFdnt0oFblJLR
	e5PFo8s3xEoyVRKdjPp0ArA4z7y/MB1e0HrsGtrOB4zlE1TwdI
	n3nmKXNyU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43E0B7EC0286221978962B5A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 12.12.2010 18:29, Thomas Gleixner wrote:
> On Sun, 12 Dec 2010, Jan Kiszka wrote:
>=20
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> This associates a status word with every IRQ descriptor. Drivers can o=
btain
>> its content via get_irq_status(irq). First use case will be propagatin=
g the
>> interrupt sharing state.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>  include/linux/interrupt.h |    2 ++
>>  include/linux/irq.h       |    2 ++
>>  kernel/irq/manage.c       |   15 +++++++++++++++
>>  3 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 79d0c4f..16cdbbf 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -126,6 +126,8 @@ struct irqaction {
>> =20
>>  extern irqreturn_t no_action(int cpl, void *dev_id);
>> =20
>> +extern unsigned long get_irq_status(unsigned long irq);
>> +
>>  #ifdef CONFIG_GENERIC_HARDIRQS
>>  extern int __must_check
>>  request_threaded_irq(unsigned int irq, irq_handler_t handler,
>> diff --git a/include/linux/irq.h b/include/linux/irq.h
>> index abde252..5554203 100644
>> --- a/include/linux/irq.h
>> +++ b/include/linux/irq.h
>> @@ -96,6 +96,7 @@ struct msi_desc;
>>   *			methods, to allow shared chip implementations
>>   * @msi_desc:		MSI descriptor
>>   * @affinity:		IRQ affinity on SMP
>> + * @status:		driver-readable status flags (IRQS_*)
>>   *
>>   * The fields here need to overlay the ones in irq_desc until we
>>   * cleaned up the direct references and switched everything over to
>> @@ -108,6 +109,7 @@ struct irq_data {
>>  	void			*handler_data;
>>  	void			*chip_data;
>>  	struct msi_desc		*msi_desc;
>> +	unsigned long		status;
>=20
> That breaks the current code which has irq_data embedded and shadowed
> in irq_desc for migratory reasons until all users are fixed up and the
> GENERIC_HARDIRQS_NO_DEPRECATED sections are cleaned up. I know it's
> ugly, but that was the only way not to rewrite the world in one go. :)
> Just move it below affinity.
>=20
> Also we should name it different than status, drv_status perhaps, to
> avoid confusion with the irq_desc status.

OK, will address both in a succeeding round (just waiting for potential
further comments).

Thanks,
Jan


--------------enig43E0B7EC0286221978962B5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0FQ+4ACgkQitSsb3rl5xQV2ACg7Bor71i+LCk+91j4nNhcFMeo
Zs0AoLzOXSyA1nkXezOaGs9zMKh00Utt
=1UDx
-----END PGP SIGNATURE-----

--------------enig43E0B7EC0286221978962B5A--
