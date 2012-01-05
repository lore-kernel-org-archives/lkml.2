Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2AEH3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:29:55 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57911 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2AEH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:29:52 -0500
Date: Thu, 5 Jan 2012 18:29:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitri Sivanich <sivanich@sgi.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120105182949.e35b2430b915b50e4bb9bc04@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_18_29_49_+1100_9GQUtW1Y9+Z8tMhf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_18_29_49_+1100_9GQUtW1Y9+Z8tMhf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/time/tick-sched.c:874:7: warning: 'struct sysdev_attribute' declared=
 inside parameter list [enabled by default]
kernel/time/tick-sched.c:874:7: warning: its scope is only this definition =
or declaration, which is probably not what you want [enabled by default]
kernel/time/tick-sched.c:874:7: warning: 'struct sys_device' declared insid=
e parameter list [enabled by default]
kernel/time/tick-sched.c: In function 'sysfs_store_do_timer_cpu':
kernel/time/tick-sched.c:876:9: error: implicit declaration of function 'SY=
SDEV_TO_EXT_ATTR' [-Werror=3Dimplicit-function-declaration]
kernel/time/tick-sched.c:876:36: warning: initialization makes pointer from=
 integer without a cast [enabled by default]
kernel/time/tick-sched.c:898:22: error: dereferencing pointer to incomplete=
 type
kernel/time/tick-sched.c: At top level:
kernel/time/tick-sched.c:905:15: error: variable 'attr_jiffies_cpu' has ini=
tializer but incomplete type
kernel/time/tick-sched.c:906:4: error: implicit declaration of function '_S=
YSDEV_ATTR' [-Werror=3Dimplicit-function-declaration]
kernel/time/tick-sched.c:906:17: error: 'jiffies_cpu' undeclared here (not =
in a function)
kernel/time/tick-sched.c:906:36: error: 'sysdev_show_int' undeclared here (=
not in a function)
kernel/time/tick-sched.c:907:6: warning: excess elements in struct initiali=
zer [enabled by default]
kernel/time/tick-sched.c:907:6: warning: (near initialization for 'attr_jif=
fies_cpu') [enabled by default]
kernel/time/tick-sched.c:908:4: warning: excess elements in struct initiali=
zer [enabled by default]
kernel/time/tick-sched.c:908:4: warning: (near initialization for 'attr_jif=
fies_cpu') [enabled by default]
kernel/time/tick-sched.c:910:15: error: variable 'timekeeping_sysclass' has=
 initializer but incomplete type
kernel/time/tick-sched.c:911:2: error: unknown field 'name' specified in in=
itializer
kernel/time/tick-sched.c:911:2: warning: excess elements in struct initiali=
zer [enabled by default]
kernel/time/tick-sched.c:911:2: warning: (near initialization for 'timekeep=
ing_sysclass') [enabled by default]
kernel/time/tick-sched.c:914:15: error: variable 'device_timekeeping' has i=
nitializer but incomplete type
kernel/time/tick-sched.c:915:2: error: unknown field 'id' specified in init=
ializer
kernel/time/tick-sched.c:915:2: warning: excess elements in struct initiali=
zer [enabled by default]
kernel/time/tick-sched.c:915:2: warning: (near initialization for 'device_t=
imekeeping') [enabled by default]
kernel/time/tick-sched.c:916:2: error: unknown field 'cls' specified in ini=
tializer
kernel/time/tick-sched.c:916:2: warning: excess elements in struct initiali=
zer [enabled by default]
kernel/time/tick-sched.c:916:2: warning: (near initialization for 'device_t=
imekeeping') [enabled by default]
kernel/time/tick-sched.c: In function 'init_timekeeping_sysfs':
kernel/time/tick-sched.c:921:2: error: implicit declaration of function 'sy=
sdev_class_register' [-Werror=3Dimplicit-function-declaration]
kernel/time/tick-sched.c:924:3: error: implicit declaration of function 'sy=
sdev_register' [-Werror=3Dimplicit-function-declaration]
kernel/time/tick-sched.c:926:3: error: implicit declaration of function 'sy=
sdev_create_file' [-Werror=3Dimplicit-function-declaration]
kernel/time/tick-sched.c:928:5: error: invalid use of undefined type 'struc=
t sysdev_ext_attribute'

Caused by commit 629d589817da ("tick-sched: add specific do_timer_cpu
value for nohz off mode") interacting with the removal of sysdevs in the
driver-core tree.  This patch will need reworking for that.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_18_29_49_+1100_9GQUtW1Y9+Z8tMhf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBVFtAAoJEECxmPOUX5FEjfgP/AsBCpyvqL5HZlG3NEGShKmL
ej4spLyYv+bZvMoKrKaIOfdVm81LVhfTxrAgLzXiU44r4OcXHhbb501SJkcYzvUN
LhVkZgykjXlzqsWnXGxGVNd1H5PlVVkv7YQOa0j0fgJ2dLGxXuPGSi3t8YGFvZYu
2J219a6ZmiEa3k5gariE3Fysf2bM+U7ck+8AlnsfzEKeCMQah35U0z2w2u2317ja
289KAmwHYx04EWQmIaOQMevIZF9wIv3mGLZncyuu/ZkAR+MvuIirUG49a1Zxj31t
94ZOYpi2kmbL8QPwVt2Aa2R8n23tZfnZc9Ap9MPX33OYsHPjVCXzHHObEcfWSA6K
iw2e8Fl+ja0QZfBsDGmd2cyTarxx95luxdT4IgnZsg0PwT5TnHF3WkjosQ0trPaM
qMaQi8cPfwVIN/ggFCDjRvuF69xI9Yy/MXzh2i4buytf/Nb0TSOukgMhjUI/uFWH
n0Y6StVeGOW3AWirLzb2el7UOfjsbBb8io+EmUohzKWQ4aigN0KjwYtX9SryVkHd
Qmhf85OsIw3UBW4h+h5AU6rDhWOpwXtDPtSpAiKx9Cehdt0DkbWB3UfWr4cCzlHG
omzTwaWZdR7cnzRqJya6qbZDgy85lCqHS5dudTMO2XQQAX8xk6Cw1mHBjG/BBnyj
T/UodPYyco1gK6G0Oqyd
=I63B
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_18_29_49_+1100_9GQUtW1Y9+Z8tMhf--
