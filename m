Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0HXJPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:15:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52679 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0HXJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hf9k0DYv/pBqp8Hklo+EQu/LmChzhwyTU88/KLOlisvpNeWwgeRemxUXVilGrbEnT8
         8cAvac4n6v5vEmvkyKYjG6P7w/T8r3qKsKU+PaSeUDZRTf8dTRXwnJ0V5tePN86MbMY5
         UGmgVnXpuj5N2HDFhJDX/8r8dLx32uwN9ME34=
Date: Tue, 24 Aug 2010 12:15:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: general protection fault: 0000 [#1] PREEMPT SMP
Message-ID: <20100824091536.GA5440@swordfish.minsk.epam.com>
References: <20100813134756.GA5235@swordfish.minsk.epam.com>
 <4C73899A.304@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <4C73899A.304@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/24/10 10:58), Tejun Heo wrote:
> Hello,
>=20
> On 08/13/2010 03:47 PM, Sergey Senozhatsky wrote:
> > [   29.943019]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
> ..
> > [   29.943257]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
> ..
> > [   29.943376]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3=
e/0x93
>=20
> It's getting gpf at spin_lock_irqsave(&fbc->lock) in
> percpu_counter_hotplug_callback().  percpu_counter keeps track of all
> the allocated percpu counters and walk them on cpu up/down events.
> It's most likely one of its users freed or corrupted the percpu
> counter structure without properly destroying it.  Adding debugobj is
> probably the best way to track down the offending user.
>=20
> Thanks.
>=20
> --=20
> tejun
>=20

Hello,

Can't reproduce it so far.

	Sergey

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxzjbgACgkQfKHnntdSXjRuzAP/YwocZzjy0SAbjkuwVoTNSFp9
u14wUwX+vUIc/D7EH/YTRzMRdSZUxa1pXBF03uDEHz+FVka4znpnxFL3VIL78QMG
tRXKpMEx+F72IBMUCsEwtayFbHSC1uMfAi6XyeSpYEB31k1yx2adEPMUkvzSxpJz
7J4KzPcdP7FxsPrd0rA=
=2xMi
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
