Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0LQIUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:20:19 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:46436 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0LQIUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:20:18 -0500
Message-ID: <4D0B1CD9.5060601@web.de>
Date: Fri, 17 Dec 2010 09:18:33 +0100
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
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de>
In-Reply-To: <4D0A75E3.3090900@web.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig267336D61C8FA0F7F603BD7E"
X-Provags-ID: V01U2FsdGVkX1+Pflteipq8JOXC6ahPN839/PaemuBWk7iGmMDr
	v+gzeEz00sRh5Z9iZ3LgBS5iqDFYsUeQO9Sm/rUYMD95LjF/t0
	Ex5piN+cY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig267336D61C8FA0F7F603BD7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.12.2010 21:26, Jan Kiszka wrote:
> Am 16.12.2010 14:13, Thomas Gleixner wrote:
>> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>>> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
>>> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
>>> +		/*
>>> +		 * Signal the old handler that is has to switch to shareable
>>> +		 * handling mode. Disable the line to avoid any conflict with
>>> +		 * a real IRQ.
>>> +		 */
>>> +		disable_irq(irq);
>>
>> This is weird, really. I thought you wanted to avoid waiting for the
>> threaded handler to finish if it's on the fly. So this should be
>> disable_irq_nosync() or did you change your mind ?
>=20
> No, I did not. I wanted to avoid that we set MAKE_SHAREABLE while there=

> might be another IRQ in flight. The handler that is called due to a rea=
l
> IRQ might misinterpret MAKE_SHAREABLE as "there is no real event" and
> perform the wrong steps (at least the current implementation for KVM wo=
uld).

Actually, the requirement we have to fulfill here is to avoid that the
hardirq handler sees !SHARED while the threaded one reads "SHARED". To
achieve this without disabling the line, I'm still searching for a way
to couple the sharing state of associated hard and threaded handler runs
- but I think there is no reliable association, is there?

Jan


--------------enig267336D61C8FA0F7F603BD7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0LHNwACgkQitSsb3rl5xTS2gCgth+pwz/KbEz+MvV/JYxYntp8
I7QAoKdmTWE8xoNfZbPjQfY4Fyltr8SK
=QrZk
-----END PGP SIGNATURE-----

--------------enig267336D61C8FA0F7F603BD7E--
