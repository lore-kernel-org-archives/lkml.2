Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0FPJbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:31:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58465 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0FPJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n2r1kUu3GyRCLRa1q3rOCBj+xJyjcZ40AaAOGXg5SJ0lGhlkqo6K1xVb8jJVvfQn8C
         cVpgmSBRUhmezrvjBMge4aTqzgZokRNRY7831hOGdoMVCbt9UhBef93wm5UN1RMEzkwD
         bc5Cj3EJit3gKu4GaoV4yxCP4/1RWJYq9rle4=
Date: Wed, 16 Jun 2010 12:34:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100616093442.GA4230@swordfish.minsk.epam.com>
References: <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
 <20100615161303.GA4102@swordfish.minsk.epam.com>
 <20100615230541.5db5078e@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20100615230541.5db5078e@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/15/10 23:05), Arjan van de Ven wrote:
> can we do this bit once, when the ts structure gets initialized?
> it's not like the cpu value will ever change...
>=20
>=20
Hello Arjan,

Sure we can. The question is where is the "proper place"?
for_each_possible_cpu in __init?

or something like=20

static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
int cpu =3D get_cpu();
&per_cpu(tick_cpu_sched, cpu)->cpu =3D cpu;
put_cpu();


	Sergey

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwYmrIACgkQfKHnntdSXjTicQP+O7zv/3k+yZTVeijM1CkXnD0s
aZEPwo8rydiZVEp/5aNT/6n8c+4PDkgZ8KgoGKbUu/u6t7hV08uz2rvD3skKM+UR
3QnsiwcVq+kKVHlf80ztYTqVDLB5J0SjjPElWkixt70o2DzjKY4gDxGgB2JceJDs
xvkPcrVuhm8obfW78x8=
=ERuC
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
