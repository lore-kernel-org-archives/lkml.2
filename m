Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0HODo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 23:44:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59083 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab0HODo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 23:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tj8vRjM+d0/TBSvhTUffvhR7OyFLzUXo8XkmbeDmRr6yemPoBA3tIK+jSl5Me3enSQ
         uKfPin2xAm7YPqHh1ZVn1PrurUXqMVWt+haHmAd/eb1cJwn5hog82WPXhflxGVGQTtb3
         i29ywz856VuQWiLaJ2O2jhM1BV4dV5x2gmVZA=
Date: Sat, 14 Aug 2010 23:44:53 -0400
From: tmhikaru@gmail.com
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [stable] 2.6.34.4 build failure
Message-ID: <20100815034453.GA29703@roll>
References: <87sk2h1yki.fsf@turtle.gmx.de> <20100814211043.GC7799@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20100814211043.GC7799@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 14, 2010 at 02:10:43PM -0700, Greg KH wrote:
> On Sat, Aug 14, 2010 at 08:46:21AM +0200, Sven Joachim wrote:
> > 2.6.34.4 failed to build here:
> >=20
> > ,----
> > |   CC      arch/x86/kernel/cpu/vmware.o
> > | arch/x86/kernel/cpu/vmware.c: In function 'vmware_get_tsc_khz':
> > | arch/x86/kernel/cpu/vmware.c:66: error: 'preset_lpj' undeclared (firs=
t use in this function)
> > | arch/x86/kernel/cpu/vmware.c:66: error: (Each undeclared identifier i=
s reported only once
> > | arch/x86/kernel/cpu/vmware.c:66: error: for each function it appears =
in.)
> > | arch/x86/kernel/cpu/vmware.c:68: error: 'HZ' undeclared (first use in=
 this function)
> > | make[3]: *** [arch/x86/kernel/cpu/vmware.o] Error 1
> > | make[2]: *** [arch/x86/kernel/cpu] Error 2
> > | make[1]: *** [arch/x86/kernel] Error 2
> > | make: *** [arch/x86] Error 2
> > `----
> >=20
> > The .config file follows.
>=20
> If you add:
> 	#include <linux/jiffies.h>
> to that file, does it then build?
>=20
> Odd that this isn't showing up in the .35 kernel :(
>=20
> thanks,
>=20
> greg k-h

	I am having an identical build failure. Adding that include line
indeed fixes it for me.

	Tim McGrath

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTGditZEncCrqzVruAQLkfgf8DF/RIrrnZqAENBvEA4QESROicLTtvksv
+QHmb3FFiej6tmxzG/o+R692OQUVPwf2ASNC/esX3y9ExXeaIMCGtYIsit54lA1v
q8gYowSNiR0FVl4+4KVLtUeLN2vKg4V+yG5vBE5H9PZ0ShoLmLArHyaahRYt2aUl
QXkld2vnQ4LmAZAFeH6stW4c54jn5DP0sA7GiEXn0eWq6D19e83tXGf9pyz3rQJq
vDpiS9cOPY3DqIRI/KgYwVRu/NKNTtBoteJ+h4quttDpQigb9YPmq5YFRDNZnOcs
vxnE9rfcOnFv1iex1/FqgKUPWaJwSy4O0jaKWluBe7x8DisnJmPlEg==
=qh4G
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
