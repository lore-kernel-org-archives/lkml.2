Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2JCIZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:25:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:24641 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2JCIZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229918758"
Message-ID: <1349252745.2017.120.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, Heinz.Egger@linutronix.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 11:25:45 +0300
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Va8NZIt+YvIrHPhUQ/D8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Va8NZIt+YvIrHPhUQ/D8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-26 at 17:51 +0200, Richard Weinberger wrote:
> UBI Fastmap is an optional feature which stores the physical to
> logical eraseblock relations in a checkpoint (called fastmap) to reduce
> the initialization time of UBI. The current init time of UBI is
> proportional to the number of physical erase blocks on the FLASH
> device. With fastmap enabled the scan time is limited to a fixed
> number of blocks.

Aiaiai complains and linux-next build fails :-( Last time I forgot to
enable the fastmap kbuild option so aiaiai checked with that option
disabled. Now I enabled it with a simple hack (default n -> default y)
and here are aiaiai's complaints - there is a build failure for
ARCH=3Di386.

I should improve aiaiai to automatically enable new Kconfig features, or
at least warn about them. This is not the first time someone sends a new
driver which is default off, and I forget to enable it :-(


dedekind@blue:~/git/maintaining$ ../aiaiai/aiaiai-concat-mboxes ../linux-ub=
i/00* | ./verify ../linux-ubi gen -c 55393ba1bdedc5ded79b34b4cc08898a7776cd=
db
Tested the patch(es) on top of the following commits:
e4e9957 Quick fixes - applied by aiaiai
55393ba UBI: fix trivial typo 'it' =3D> 'is'
cf38aca UBI: load after mtd device drivers
719bb84 UBI: print less

---------------------------------------------------------------------------=
-----

Successfully built configuration "arm-omap2plus_defconfig,arm,arm-unknown-l=
inux-gnueabi-", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----
Failed to build the following commit for configuration "i386_defconfig" (ar=
chitecture i386)":

88f4a02 UBI: Wire-up fastmap

drivers/mtd/nand/r852.c:571:6: warning: no previous prototype for =E2=80=98=
r852_engine_disable=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:581:6: warning: no previous prototype for =E2=80=98=
r852_card_update_present=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:596:6: warning: no previous prototype for =E2=80=98=
r852_update_card_detect=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:610:9: warning: no previous prototype for =E2=80=98=
r852_media_type_show=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:625:6: warning: no previous prototype for =E2=80=98=
r852_update_media_status=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:654:5: warning: no previous prototype for =E2=80=98=
r852_register_nand_device=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:692:6: warning: no previous prototype for =E2=80=98=
r852_unregister_nand_device=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:706:6: warning: no previous prototype for =E2=80=98=
r852_card_detect_work=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:845:6: warning: no previous prototype for =E2=80=98=
r852_probe=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:986:6: warning: no previous prototype for =E2=80=98=
r852_remove=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:1017:6: warning: no previous prototype for =E2=80=
=98r852_shutdown=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:44:9: warning: no previous prototype for =E2=80=98sm_a=
ttr_show=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:57:25: warning: no previous prototype for =E2=80=98sm_=
create_sysfs_attributes=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:110:6: warning: no previous prototype for =E2=80=98sm_=
delete_sysfs_attributes=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:575:5: warning: no previous prototype for =E2=80=98sm_=
get_media_info=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:882:18: warning: no previous prototype for =E2=80=98sm=
_get_zone=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:903:6: warning: no previous prototype for =E2=80=98sm_=
cache_init=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:913:6: warning: no previous prototype for =E2=80=98sm_=
cache_put=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:921:5: warning: no previous prototype for =E2=80=98sm_=
cache_get=E2=80=99 [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:932:5: warning: no previous prototype for =E2=80=98sm_=
cache_flush=E2=80=99 [-Wmissing-prototypes]
ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
make[2]: *** [__modpost] Error 1

---------------------------------------------------------------------------=
-----
Failed to build the following commit for configuration "ia64_defconfig" (ar=
chitecture ia64)":

88f4a02 UBI: Wire-up fastmap

drivers/mtd/nand/r852.c:381:5: warning: no previous prototype for 'r852_wai=
t' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:410:5: warning: no previous prototype for 'r852_rea=
dy' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:421:6: warning: no previous prototype for 'r852_ecc=
_hwctl' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:453:5: warning: no previous prototype for 'r852_ecc=
_calculate' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:485:5: warning: no previous prototype for 'r852_ecc=
_correct' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:553:6: warning: no previous prototype for 'r852_eng=
ine_enable' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:571:6: warning: no previous prototype for 'r852_eng=
ine_disable' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:581:6: warning: no previous prototype for 'r852_car=
d_update_present' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:596:6: warning: no previous prototype for 'r852_upd=
ate_card_detect' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:610:9: warning: no previous prototype for 'r852_med=
ia_type_show' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:625:6: warning: no previous prototype for 'r852_upd=
ate_media_status' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:654:5: warning: no previous prototype for 'r852_reg=
ister_nand_device' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:692:6: warning: no previous prototype for 'r852_unr=
egister_nand_device' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:706:6: warning: no previous prototype for 'r852_car=
d_detect_work' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:845:6: warning: no previous prototype for 'r852_pro=
be' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:986:6: warning: no previous prototype for 'r852_rem=
ove' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:1017:6: warning: no previous prototype for 'r852_sh=
utdown' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:1028:12: warning: 'r852_suspend' defined but not us=
ed [-Wunused-function]
drivers/mtd/nand/r852.c:1049:12: warning: 'r852_resume' defined but not use=
d [-Wunused-function]
WARNING: modpost: Found 1 section mismatch(es).
ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
make[2]: *** [__modpost] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "m68k-m5208evb_defconfig,m68k,m68k-linux-"=
, results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----
Failed to build the following commit for configuration "mips64_defconfig" (=
architecture mips)":

88f4a02 UBI: Wire-up fastmap

drivers/mtd/nand/r852.c:571:6: warning: no previous prototype for 'r852_eng=
ine_disable' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:581:6: warning: no previous prototype for 'r852_car=
d_update_present' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:596:6: warning: no previous prototype for 'r852_upd=
ate_card_detect' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:610:9: warning: no previous prototype for 'r852_med=
ia_type_show' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:625:6: warning: no previous prototype for 'r852_upd=
ate_media_status' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:654:5: warning: no previous prototype for 'r852_reg=
ister_nand_device' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:692:6: warning: no previous prototype for 'r852_unr=
egister_nand_device' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:706:6: warning: no previous prototype for 'r852_car=
d_detect_work' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:845:6: warning: no previous prototype for 'r852_pro=
be' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:986:6: warning: no previous prototype for 'r852_rem=
ove' [-Wmissing-prototypes]
drivers/mtd/nand/r852.c:1017:6: warning: no previous prototype for 'r852_sh=
utdown' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:44:9: warning: no previous prototype for 'sm_attr_show=
' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:57:25: warning: no previous prototype for 'sm_create_s=
ysfs_attributes' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:110:6: warning: no previous prototype for 'sm_delete_s=
ysfs_attributes' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:575:5: warning: no previous prototype for 'sm_get_medi=
a_info' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:882:18: warning: no previous prototype for 'sm_get_zon=
e' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:903:6: warning: no previous prototype for 'sm_cache_in=
it' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:913:6: warning: no previous prototype for 'sm_cache_pu=
t' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:921:5: warning: no previous prototype for 'sm_cache_ge=
t' [-Wmissing-prototypes]
drivers/mtd/sm_ftl.c:932:5: warning: no previous prototype for 'sm_cache_fl=
ush' [-Wmissing-prototypes]
ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
make[2]: *** [__modpost] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "mips-bcm63xx_defconfig,mips,mips-linux-",=
 results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Successfully built configuration "ppc32_defconfig,powerpc,powerpc-linux-", =
results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Successfully built configuration "ppc64_defconfig,powerpc,powerpc64-linux-"=
, results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Successfully built configuration "x86_64_defconfig,x86_64,", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/fastmap.c:1012 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1012:9-11: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1017:7-11: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1027 ubi_scan_fastmap() error: double free of 'f=
m' [smatch]
+drivers/mtd/ubi/fastmap.c:1027:8-10: ERROR: reference preceded by free on =
line 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1033 ubi_scan_fastmap() error: dereferencing fre=
ed memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1033:1-3: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:1077 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:1479 ubi_update_fastmap() error: we previously a=
ssumed 'tmp_e' could be null (see line 1463) [smatch]
+drivers/mtd/ubi/fastmap.c:925 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:925:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:926 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:926:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:933 ubi_scan_fastmap() error: double free of 'fm=
sb' [smatch]
+drivers/mtd/ubi/fastmap.c:933:8-12: ERROR: reference preceded by free on l=
ine 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:934 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:934:8-10: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:940 ubi_scan_fastmap() error: dereferencing free=
d memory 'fmsb' [smatch]
+drivers/mtd/ubi/fastmap.c:940:21-25: ERROR: reference preceded by free on =
line 918 [coccinelle]
+drivers/mtd/ubi/fastmap.c:944 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:944:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:956 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:956:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:959 ubi_scan_fastmap() error: dereferencing free=
d memory 'fm' [smatch]
+drivers/mtd/ubi/fastmap.c:959:3-5: ERROR: reference preceded by free on li=
ne 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:967 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:967:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:976 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:976:9-11: ERROR: reference preceded by free on l=
ine 919 [coccinelle]
+drivers/mtd/ubi/fastmap.c:988 ubi_scan_fastmap() error: double free of 'fm=
' [smatch]
+drivers/mtd/ubi/fastmap.c:988:10-12: ERROR: reference preceded by free on =
line 919 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

checkpatch.pl has some complaints:

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 07/10] UBI: Add fastmap stuff to at=
tach.c"

WARNING:LONG_LINE: line over 80 characters
#115: FILE: drivers/mtd/ubi/attach.c:1008:
+                               ubi_msg("\"delete\" compatible internal vol=
ume %d:%d found, will remove it",

total: 0 errors, 1 warnings, 550 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for the entire squashed patch-set

WARNING:LONG_LINE: line over 80 characters
#987: FILE: drivers/mtd/ubi/attach.c:1008:
+                               ubi_msg("\"delete\" compatible internal vol=
ume %d:%d found, will remove it",

total: 0 errors, 1 warnings, 3708 lines checked

---------------------------------------------------------------------------=
-----

--=20
Best Regards,
Artem Bityutskiy

--=-Va8NZIt+YvIrHPhUQ/D8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQa/aJAAoJECmIfjd9wqK0bfIP/j0AJRqd/Myg5SgBvy1p2/F+
JPYu1P7W+R4XQlhqMcFil6u6rlJzhOilEDVK+6wMNJqkRbWrJ+Yw2HD3dpMhcvBC
IHQeBiD3Fsqsoow+rtAhCygVZq9xcZ2sOxzJgxlvV6tnTVpQSGgFazVr1j82aZ4J
gz7+1K8BAGrylocmqSI6TR7IjutLNGldrBnmh3PsmPwqzoyBfd1EqN4f+Zj4rEAd
tvxo24fJ9rQ89hNDSxBzOSOQMhjm0ScibWS+zc/MULXwjEfiC2XThvJTwmo3vKRn
9BcB3K5NHfFHL0KfpsYpgP/oheV4cW7kYTTWoiEI/ptHocR47YOXVXA5pp9ZkWxM
7qMkN7jUajYj1LlHRFI0UKclUDSqApnXaLMWrxbWTzqP2ylOYcLiwNgmuPFjnU7q
E4cViOdRTozqrdwLdnDtHoLT3u70bNOyuRwh9HKERiWaUsfXR19xt7rUQexp9J87
gJv/ytg+TQkJOdjVzZwmg/A6skwPZaV5w+CWr3WntRgAM8RdX0iZC22DIP9WHTfC
VWPHEZMw6k+xwtVfoap7vH+ZQgrGNh4jliqbP1C4+qxO5QKM3WLUIaCZztEq6TuV
iH1mgn32p4wOj3gMU/Oh4kb182InwRyQcDBa+FAklL+vkgFJim1VODWJR4Rxto78
AZkWkkwsA3PFCVoctrU0
=jUIv
-----END PGP SIGNATURE-----

--=-Va8NZIt+YvIrHPhUQ/D8--

