Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2ILPCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:02:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ILPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:17 -0400
Date: Wed, 12 Sep 2012 17:02:10 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Message-ID: <20120912150210.GA20961@avionic-0098.mockup.avionic-design.de>
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
 <504E0542.8020309@metafoo.de>
 <20120910173056.GA31611@avionic-0098.mockup.avionic-design.de>
 <504F7B4D.3030602@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <504F7B4D.3030602@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+RgVVIBL7qWruvdn/em8uZQcQo6zGZLlZIB7AeqE8Aq
 E1YwlznOeyS9TBRrckMempIamMGmmdBHIba5cyRoSfhzg9Mhu7
 mfxFBsZPqkJOEJeQeB6IEIhOlSi9Mi7B2Bgi2mKdS93VSc2eeJ
 TPIyXhwHxgVdimGZ8l2BEwIHUO9euySuHh7Wwswz3oQb1f1Mk0
 l8V1cN4G7Nyl1eKR6wdw0HAAKMijRq00Jfra3xywxPkH/MxJkA
 6A/4WlnFuoETSoDpOQjnDVA8aG3af2N1kvKS0YC0tmpugu1Bzs
 3dWFBm1t4pieDvz469QDCTGmZMpDq/289/uQ5atJQOARFA9MUh
 eFNSIqdwYXOOnaiB0ITFJN73xrdocTKWtO/YqnCmxq4VYlGsXJ
 /k23aDGapXxPmdR2FmKL2J6VekiD9oEeb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 07:56:29PM +0200, Lars-Peter Clausen wrote:
> On 09/10/2012 07:30 PM, Thierry Reding wrote:
> > On Mon, Sep 10, 2012 at 05:20:34PM +0200, Lars-Peter Clausen wrote:
> >> On 09/10/2012 02:05 PM, Thierry Reding wrote:
> >>> Hi,
> >>>
> >>
> >> [...]
> >=20
> >> Patch 1 should go through the MIPS tree, but I still can't see why the=
 issue
> >> should occur nor does it happen for anybody else except for you. Inste=
ad of
> >> moving the content over to the public irq.h I'd rather like to see the
> >> private irq.h being renamed.
> >=20
> > If we can solve this some other way I'm all for it. Maybe you can share
> > the defconfig or .config that you use so I can test under the same
> > conditions.
> >=20
> > Thierry
>=20
> This is the config I'm using:
> http://projects.qi-hardware.com/index.php/p/qi-kernel/source/tree/jz-3.4/=
arch/mips/configs/qi_lb60_defconfig

I can still reproduce the error with that configuration. Perhaps related
to the toolchain? I use a vanilla gcc 4.7.1 cross-compiler. This is all
on top of Linux v3.6-rc2.

Here's the complete error message:

$ nice make ARCH=3Dmips CROSS_COMPILE=3D/home/thierry.reding/pbs-stage1/bin=
/mips-linux-gnu- O=3Dbuild/jz4740
  Using /home/thierry.reding/src/kernel/linux-pwm.git as source for kernel
  GEN     /home/thierry.reding/src/kernel/linux-pwm.git/build/jz4740/Makefi=
le
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    /home/thierry.reding/src/kernel/linux-pwm.git/scripts/checksyscal=
ls.sh
  CHK     include/generated/compile.h
  CC      arch/mips/jz4740/irq.o
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:39:=
 error: 'struct irq_data' declared inside parameter list [-Werror]
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:39:=
 error: its scope is only this definition or declaration, which is probably=
 not what you want [-Werror]
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:21:38:=
 error: 'struct irq_data' declared inside parameter list [-Werror]
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:356:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/include/linux/irqdesc.h:75:33=
: error: 'NR_IRQS' undeclared here (not in a function)
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: In fu=
nction 'jz4740_cascade':
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:49:39:=
 error: 'JZ4740_IRQ_BASE' undeclared (first use in this function)
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:49:39:=
 note: each undeclared identifier is reported only once for each function i=
t appears in
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: At to=
p level:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:62:6: =
error: conflicting types for 'jz4740_irq_suspend'
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:13:=
 note: previous declaration of 'jz4740_irq_suspend' was here
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:68:6: =
error: conflicting types for 'jz4740_irq_resume'
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:21:13:=
 note: previous declaration of 'jz4740_irq_resume' was here
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: In fu=
nction 'arch_init_irq':
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:91:41:=
 error: 'JZ4740_IRQ_BASE' undeclared (first use in this function)
cc1: all warnings being treated as errors
make[3]: *** [arch/mips/jz4740/irq.o] Error 1
make[2]: *** [arch/mips/jz4740] Error 2
make[1]: *** [arch/mips] Error 2
make: *** [sub-make] Error 2
  Using /home/thierry.reding/src/kernel/linux-pwm.git as source for kernel
  GEN     /home/thierry.reding/src/kernel/linux-pwm.git/build/jz4740/Makefi=
le
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    /home/thierry.reding/src/kernel/linux-pwm.git/scripts/checksyscal=
ls.sh
  CHK     include/generated/compile.h
  CC      arch/mips/jz4740/irq.o
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:39:=
 error: 'struct irq_data' declared inside parameter list [-Werror]
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:39:=
 error: its scope is only this definition or declaration, which is probably=
 not what you want [-Werror]
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:21:38:=
 error: 'struct irq_data' declared inside parameter list [-Werror]
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:356:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/include/linux/irqdesc.h:75:33=
: error: 'NR_IRQS' undeclared here (not in a function)
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: In fu=
nction 'jz4740_cascade':
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:49:39:=
 error: 'JZ4740_IRQ_BASE' undeclared (first use in this function)
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:49:39:=
 note: each undeclared identifier is reported only once for each function i=
t appears in
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: At to=
p level:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:62:6: =
error: conflicting types for 'jz4740_irq_suspend'
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:20:13:=
 note: previous declaration of 'jz4740_irq_suspend' was here
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:68:6: =
error: conflicting types for 'jz4740_irq_resume'
In file included from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/irq.h:18:0,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/irq.h:27,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/asm-generic/hardirq.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/include/asm/hardirq.h:16,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/hardirq.h:7,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/include=
/linux/interrupt.h:12,
                 from /home/thierry.reding/src/kernel/linux-pwm.git/arch/mi=
ps/jz4740/irq.c:19:
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.h:21:13:=
 note: previous declaration of 'jz4740_irq_resume' was here
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c: In fu=
nction 'arch_init_irq':
/home/thierry.reding/src/kernel/linux-pwm.git/arch/mips/jz4740/irq.c:91:41:=
 error: 'JZ4740_IRQ_BASE' undeclared (first use in this function)
cc1: all warnings being treated as errors
make[3]: *** [arch/mips/jz4740/irq.o] Error 1
make[2]: *** [arch/mips/jz4740] Error 2
make[1]: *** [arch/mips] Error 2
make: *** [sub-make] Error 2

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUKPyAAoJEN0jrNd/PrOhUJwP/1dIPL5IM60pGY/bOYYQ9Jff
FK/Y8wiQjTfYFvdO7qlM5bzfAbifb0KeHNGVgk+Qyxj80EF3kK3finWCR2MdYKN7
55fXKYDVbpeAcHQ1OAAN5i2fYhiCcs/uw0xXCqDw4miHoCo9BHPsHAX3/UdC4ILW
oHV7kTAYYmP2sLGFTVgzpnr5s7ChPcddNZ7rY+uH4yalaYJhQgDP/JZygwsZc0p9
upOtak5qPv9xQtyuTlhJ3PeEF94N7gT7/gOafbJibfXChV4kzh1fAFdlA8gQif6t
hhjGta7bZS2SknFG+d0nqtyn/2/Iej41HKssIrvXNPX/5+Cm2L7YXEAXBxze4AwH
VSQiFJF6okT8esl+ZYl24dF4trC4N9csLr2Do48sAikGIpI6U7zWDlIlMwTKC0Ig
ZdO/qfK3X7+a/V18QpNW49xvWhaIIogxxvDTurPUeWm15/4QnIGTZHq1MMsvchOg
IK6s8k52bwR0ad1/olx/w+RiM1/9WWaThAkHXhwnr/bK4YpJHAKa/ZD1kD+ue71u
goqHK+3qRJL+bYzqqdtZPXuuxbFM68TECevyQ+9JXwzm7LqwskgMJcw+T+hbinSI
NbmtrfM5JhrmeKMuaoclOUichAVld+TSzo5jiorDOJGXCWFnQRLZHgDLA7SMzQE1
khK67KXm6n48kjmYb0Rl
=GSpW
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
