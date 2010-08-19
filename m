Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0HSIMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:12:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59388 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HSIMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jhit2gt87O8V0mvhcPRcLTJpgiIfH2TEXzIyoQOssLXJcVHYj0P3f3/DEJZzy1G7Zg
         UC/PyWFoP1o5M+t2RfOAdgk9qjK+03a7bu8NqlXcGLjtmozCIXYdPiVh1Yfz0av4jlqC
         s0DnHaBtAqJgVYJdELlh2YOWa8O9BdjtP3VEE=
Date: Thu, 19 Aug 2010 11:12:08 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at ffffffffffffffff
Message-ID: <20100819081208.GA5637@swordfish.minsk.epam.com>
References: <20100813134947.GB5235@swordfish.minsk.epam.com>
 <20100818120630.b258e128.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20100818120630.b258e128.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (08/18/10 12:06), Andrew Morton wrote:
> > Hello,
> >=20
> > yet another trace:
> >=20
> > [ 5845.374558] CPU 1 is now offline
> > [ 5845.376169] INFO: trying to register non-static key.
> > [ 5845.376251] the code is fine but needs lockdep annotation.
> > [ 5845.376327] turning off the locking correctness validator.
> > [ 5845.376405] Pid: 6754, comm: bash Not tainted 2.6.36-rc0-git12-07921=
-g60bf26a-dirty #122
> > [ 5845.376521] Call Trace:
> > [ 5845.376570]  [<ffffffff81063e89>] __lock_acquire+0x2d1/0x17fd
> > [ 5845.376657]  [<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
> > [ 5845.376747]  [<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
> > [ 5845.376834]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
> > [ 5845.376917]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0=
x3e/0x93
> > [ 5845.377021]  [<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
> > [ 5845.377113]  [<ffffffff81371446>] ? percpu_counter_hotcpu_callback+0=
x29/0x93
> > [ 5845.377218]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
> > [ 5845.377312]  [<ffffffff8137145b>] ? percpu_counter_hotcpu_callback+0=
x3e/0x93
> > [ 5845.377409]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3=
e/0x93
> > [ 5845.377475]  [<ffffffff81057344>] notifier_call_chain+0x32/0x5e
> > [ 5845.377529]  [<ffffffff8105738f>] __raw_notifier_call_chain+0x9/0xb
> > [ 5845.377587]  [<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
> > [ 5845.377638]  [<ffffffff8103c703>] cpu_notify+0xe/0x10
> > [ 5845.377684]  [<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
> > [ 5845.377738]  [<ffffffff81362d82>] _cpu_down+0x151/0x206
> > [ 5845.377786]  [<ffffffff81362ea8>] cpu_down+0x28/0x35
> > [ 5845.377833]  [<ffffffff8136430d>] store_online+0x27/0x6e
> > [ 5845.377884]  [<ffffffff812923ab>] sysdev_store+0x1b/0x1d
> > [ 5845.377933]  [<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
> > [ 5845.377990]  [<ffffffff810daf92>] vfs_write+0xb0/0x14f
> > [ 5845.378038]  [<ffffffff810db22e>] sys_write+0x45/0x6c
> > [ 5845.378088]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> > [ 5845.378166] BUG: unable to handle kernel paging request at fffffffff=
fffffff
> > [ 5845.378236] IP: [<ffffffff81371487>] percpu_counter_hotcpu_callback+=
0x6a/0x93
>=20
> It appears that one of the counters on the global list has been
> trashed: lockdep doesn't recognise its spinlock and its internal
> pointers are all-ones.
>=20
> We need to identify that counter and then go take a look at whichever
> subsystem ownes it.
>=20
> A crude approach is:
>=20
> --- a/lib/percpu_counter.c~a
> +++ a/lib/percpu_counter.c
> @@ -69,6 +69,8 @@ EXPORT_SYMBOL(__percpu_counter_sum);
>  int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
>  			  struct lock_class_key *key)
>  {
> +	printk("__percpu_counter_init(%p)\n", fbc);
> +	dump_stack();
>  	spin_lock_init(&fbc->lock);
>  	lockdep_set_class(&fbc->lock, key);
>  	fbc->count =3D amount;
> @@ -126,6 +128,7 @@ static int __cpuinit percpu_counter_hotc
>  		s32 *pcount;
>  		unsigned long flags;
> =20
> +		printk("percpu_counter_hotcpu_callback(%p)\n", fbc);
>  		spin_lock_irqsave(&fbc->lock, flags);
>  		pcount =3D per_cpu_ptr(fbc->counters, cpu);
>  		fbc->count +=3D *pcount;
> _
>=20
> If you can please apply that patch and then make it crash?  We can use
> the address from the percpu_counter_hotcpu_callback() printk to look up
> the stack trace from __percpu_counter_init() which will lead us to the
> code which owns that counter.
>=20

Sure, I'll try.


> Thanks.
>=20

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxs51gACgkQfKHnntdSXjRuxAP+K52AxH38vEQhSfqFRYFQAYjA
HPKLe55wt/1roU+2EekVOUu4Yvx3BZVRSxdJdqU84tW4EwH+z/JMMdHhFU6O35Bz
P8CCpzdiGgip8FtxBhYYR938iD5LrH0DuUp8AXKVW4hVpwoszUiHPHryT1EXvmur
W++eHKkqGMR79MNY5xo=
=uu1T
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
