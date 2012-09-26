Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2IZMWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:22:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:8101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2IZMWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="asc'?scan'208";a="213535992"
Message-ID: <1348662131.24309.74.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v18)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Date: Wed, 26 Sep 2012 15:22:11 +0300
In-Reply-To: <1348511492-91606-1-git-send-email-richard@nod.at>
References: <1348511492-91606-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JPCnyz0DNSyglLXiYNU7"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JPCnyz0DNSyglLXiYNU7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-09-24 at 20:31 +0200, Richard Weinberger wrote:
> UBI Fastmap is an optional feature which stores the physical to
> logical eraseblock relations in a checkpoint (called fastmap) to reduce
> the initialization time of UBI. The current init time of UBI is
> proportional to the number of physical erase blocks on the FLASH
> device. With fastmap enabled the scan time is limited to a fixed
> number of blocks.

Aiaiai!

Please, take a look at Aiaiai's complaints below. I did not go through
them myself.

dedekind@blue:~/git/maintaining$ ../aiaiai/aiaiai-concat-mboxes ~/tmp/richa=
rd* | ./verify ../linux-ubi gen
Tested the patch(es) on top of the following commits:
311a256 Quick fixes - applied by aiaiai
55393ba UBI: fix trivial typo 'it' =3D> 'is'
cf38aca UBI: load after mtd device drivers
719bb84 UBI: print less

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "arm-omap2plus_defconfig,arm,a=
rm-unknown-linux-gnueabi-"

Failed to build the following commit for configuration "arm-omap2plus_defco=
nfig"":

cabfa2b UBI: Add fastmap stuff to ubi.h


drivers/mtd/ubi/attach.c: In function 'scan_all':
drivers/mtd/ubi/attach.c:1220:2: error: implicit declaration of function 'u=
bi_destroy_ai' [-Werror=3Dimplicit-function-declaration]
drivers/mtd/ubi/attach.c: At top level:
drivers/mtd/ubi/attach.c:1231:5: error: conflicting types for 'ubi_attach'
drivers/mtd/ubi/ubi.h:713:5: note: previous declaration of 'ubi_attach' was=
 here
drivers/mtd/ubi/attach.c:1309:6: warning: no previous prototype for 'ubi_de=
stroy_ai' [-Wmissing-prototypes]
drivers/mtd/ubi/attach.c:1309:6: warning: conflicting types for 'ubi_destro=
y_ai' [enabled by default]
drivers/mtd/ubi/attach.c:1220:2: note: previous implicit declaration of 'ub=
i_destroy_ai' was here
cc1: some warnings being treated as errors
make[4]: *** [drivers/mtd/ubi/attach.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "arm-omap2plus_defconfig,arm,arm-unknown-l=
inux-gnueabi-", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "i386_defconfig,i386,"

Failed to build the following commit for configuration "i386_defconfig"":

258cfe8 UBI: Add fastmap stuff to ubi.h


drivers/mtd/ubi/build.c: In function =E2=80=98ubi_attach_mtd_dev=E2=80=99:
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function =E2=80=
=98ubi_attach=E2=80=99
In file included from drivers/mtd/ubi/build.c:44:0:
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "i386_defconfig,i386,", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function =E2=80=98ubi_attach=E2=80=99:
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter =E2=80=98force_scan=
=E2=80=99 set but not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function =E2=80=98find_wl_entry=E2=80=99:
+drivers/mtd/ubi/wl.c:363:27: warning: variable =E2=80=98prev_e=E2=80=99 se=
t but not used [-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function =E2=80=98wear_leveling_worker=E2=80=99:
+drivers/mtd/ubi/wl.c:998:6: warning: variable =E2=80=98anchor=E2=80=99 set=
 but not used [-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "ia64_defconfig,ia64,ia64-linu=
x-"

Failed to build the following commit for configuration "ia64_defconfig"":

f1b826b UBI: Add fastmap stuff to ubi.h


warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP ||=
 PM_RUNTIME)
warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP ||=
 PM_RUNTIME)
warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP ||=
 PM_RUNTIME)
kernel/sys.c: In function 'sys_prctl':
kernel/sys.c:2026:4: warning: comparison of unsigned expression < 0 is alwa=
ys false [-Wtype-limits]
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1484:6: warning: variable 'nowarn' set but not used [-Wunus=
ed-but-set-variable]
kernel/module.c: At top level:
kernel/module.c:3531:6: warning: no previous prototype for 'module_layout' =
[-Wmissing-prototypes]
drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "ia64_defconfig,ia64,ia64-linux-", results=
:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "m68k-m5208evb_defconfig,m68k,=
m68k-linux-"

Failed to build the following commit for configuration "m68k-m5208evb_defco=
nfig"":

638c620 UBI: Add fastmap stuff to ubi.h


kernel/sys.c: In function 'sys_prctl':
kernel/sys.c:2026:4: warning: comparison of unsigned expression < 0 is alwa=
ys false [-Wtype-limits]
drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "m68k-m5208evb_defconfig,m68k,m68k-linux-"=
, results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "mips64_defconfig,mips,mips64-=
linux-"

Failed to build the following commit for configuration "mips64_defconfig"":

d5665b7 UBI: Add fastmap stuff to ubi.h

kernel/sys.c:1365:1: warning: no previous prototype for 'SyS_sethostname' [=
-Wmissing-prototypes]
kernel/sys.c:1391:1: warning: no previous prototype for 'SyS_gethostname' [=
-Wmissing-prototypes]
kernel/sys.c:1416:1: warning: no previous prototype for 'SyS_setdomainname'=
 [-Wmissing-prototypes]
kernel/sys.c:1440:1: warning: no previous prototype for 'SyS_getrlimit' [-W=
missing-prototypes]
kernel/sys.c:1459:1: warning: no previous prototype for 'SyS_old_getrlimit'=
 [-Wmissing-prototypes]
kernel/sys.c:1601:1: warning: no previous prototype for 'SyS_prlimit64' [-W=
missing-prototypes]
kernel/sys.c:1641:1: warning: no previous prototype for 'SyS_setrlimit' [-W=
missing-prototypes]
kernel/sys.c:1774:1: warning: no previous prototype for 'SyS_getrusage' [-W=
missing-prototypes]
kernel/sys.c:1782:1: warning: no previous prototype for 'SyS_umask' [-Wmiss=
ing-prototypes]
kernel/sys.c:2000:1: warning: no previous prototype for 'SyS_prctl' [-Wmiss=
ing-prototypes]
kernel/sys.c: In function 'SYSC_prctl':
kernel/sys.c:2026:4: warning: comparison of unsigned expression < 0 is alwa=
ys false [-Wtype-limits]
kernel/sys.c: At top level:
kernel/sys.c:2171:1: warning: no previous prototype for 'SyS_getcpu' [-Wmis=
sing-prototypes]
kernel/module.c:769:1: warning: no previous prototype for 'SyS_delete_modul=
e' [-Wmissing-prototypes]
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1484:6: warning: variable 'nowarn' set but not used [-Wunus=
ed-but-set-variable]
kernel/module.c: At top level:
kernel/module.c:3011:1: warning: no previous prototype for 'SyS_init_module=
' [-Wmissing-prototypes]
kernel/module.c:3531:6: warning: no previous prototype for 'module_layout' =
[-Wmissing-prototypes]
drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "mips64_defconfig,mips,mips64-linux-", res=
ults:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "mips-bcm63xx_defconfig,mips,m=
ips-linux-"

Failed to build the following commit for configuration "mips-bcm63xx_defcon=
fig"":

aef58e8 UBI: Add fastmap stuff to ubi.h


drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "mips-bcm63xx_defconfig,mips,mips-linux-",=
 results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "ppc32_defconfig,powerpc,power=
pc-linux-"

Failed to build the following commit for configuration "ppc32_defconfig"":

18ae4d4 UBI: Add fastmap stuff to ubi.h


warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "ppc32_defconfig,powerpc,powerpc-linux-", =
results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "ppc64_defconfig,powerpc,power=
pc64-linux-"

Failed to build the following commit for configuration "ppc64_defconfig"":

d1ad70b UBI: Add fastmap stuff to ubi.h


warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL=
_LBC which has unmet direct dependencies (FSL_SOC)
drivers/mtd/ubi/build.c: In function 'ubi_attach_mtd_dev':
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function 'ubi_at=
tach'
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "ppc64_defconfig,powerpc,powerpc64-linux-"=
, results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function 'ubi_attach':
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter 'force_scan' set but =
not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function 'find_wl_entry':
+drivers/mtd/ubi/wl.c:363:27: warning: variable 'prev_e' set but not used [=
-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function 'wear_leveling_worker':
+drivers/mtd/ubi/wl.c:998:6: warning: variable 'anchor' set but not used [-=
Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

Bisectability test results for configuration "x86_64_defconfig,x86_64,"

Failed to build the following commit for configuration "x86_64_defconfig"":

9d3e659 UBI: Add fastmap stuff to ubi.h


drivers/mtd/ubi/build.c: In function =E2=80=98ubi_attach_mtd_dev=E2=80=99:
drivers/mtd/ubi/build.c:941:2: error: too few arguments to function =E2=80=
=98ubi_attach=E2=80=99
In file included from drivers/mtd/ubi/build.c:44:0:
drivers/mtd/ubi/ubi.h:713:5: note: declared here
make[4]: *** [drivers/mtd/ubi/build.o] Error 1

---------------------------------------------------------------------------=
-----

Successfully built configuration "x86_64_defconfig,x86_64,", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/attach.c: In function =E2=80=98ubi_attach=E2=80=99:
+drivers/mtd/ubi/attach.c:1400:44: warning: parameter =E2=80=98force_scan=
=E2=80=99 set but not used [-Wunused-but-set-parameter]
@@ @@
+drivers/mtd/ubi/eba.c:1260:2-11: alloc with no test, possible model on lin=
e 1270 [coccinelle]
@@ @@
+drivers/mtd/ubi/wl.c: In function =E2=80=98find_wl_entry=E2=80=99:
+drivers/mtd/ubi/wl.c:363:27: warning: variable =E2=80=98prev_e=E2=80=99 se=
t but not used [-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c: In function =E2=80=98wear_leveling_worker=E2=80=99:
+drivers/mtd/ubi/wl.c:998:6: warning: variable =E2=80=98anchor=E2=80=99 set=
 but not used [-Wunused-but-set-variable]
+drivers/mtd/ubi/wl.c:284:3-9: preceding lock on line 282 [coccinelle]

---------------------------------------------------------------------------=
-----

checkpatch.pl has some complaints:

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 05/10] UBI: Add fastmap bits to bui=
ld.c"

WARNING:SPLIT_STRING: quoted string split across lines
#151: FILE: drivers/mtd/ubi/build.c:1469:
+MODULE_PARM_DESC(fm_autoconvert, "Set this parameter to enable fastmap "
+                                "automatically on images without a fastmap=
.");

total: 0 errors, 1 warnings, 133 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 07/10] UBI: Add fastmap stuff to at=
tach.c"

WARNING:SPLIT_STRING: quoted string split across lines
#113: FILE: drivers/mtd/ubi/attach.c:1009:
+                               ubi_msg("\"delete\" compatible internal vol=
ume"
+                                       " %d:%d found, will remove it",

total: 0 errors, 1 warnings, 535 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for the entire squashed patch-set

WARNING:SPLIT_STRING: quoted string split across lines
#794: FILE: drivers/mtd/ubi/build.c:1469:
+MODULE_PARM_DESC(fm_autoconvert, "Set this parameter to enable fastmap "
+                                "automatically on images without a fastmap=
.");

WARNING:SPLIT_STRING: quoted string split across lines
#996: FILE: drivers/mtd/ubi/attach.c:1009:
+                               ubi_msg("\"delete\" compatible internal vol=
ume"
+                                       " %d:%d found, will remove it",

total: 0 errors, 2 warnings, 3712 lines checked

---------------------------------------------------------------------------=
-----

--=20
Best Regards,
Artem Bityutskiy

--=-JPCnyz0DNSyglLXiYNU7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQYvNzAAoJECmIfjd9wqK04agP/2J2pAA290n6Qwvy3uCPytVB
jYvK2Xq8wcgcCAYUz17N/gM8Yw5OQbScGPuwBuVwk6UvnBils5IOxiIZG/kRT3Mh
HyM6rx0/LOgRBzTy0sJiKkRB6UPc3XRDpBr39EZg5FNSKlSjG1/cPWisw4x84Qdq
bBQ3EqjeLvK1r3Oz3tpUtUhgR6+2xTpbFicNC2/4+4X+FSn8I5+5p0OCat3eQC6w
Uh84pwS5+CFTFatkLzGSU0RRBBKwrqH479Ntq0xEUCHHAj+YGggF7USFcr7Lbj5+
o0rr00H5au2WIagpPmynupn9mQmKxIDfNZ5w0tVOngBhcUx5odUyu8RVOAZv0WjN
z2qdvDeTgSxpRng3tBZ62PnMJoXp76Q+3l6XBOHKLcPMQ2v8gpIrHHcXJp8ikV9g
1XLAAfcNPwaY6CKDPdTiqhpWlD61JRkUy4AZavDzTX6GcdlwwltzS88HuWGwf8Dl
RoOBn1iGI9vIevJhISWeRqcMMSFEvrYX04ZXF9k3fsyQ0KR3sUakRx/SsfwJ8Owl
Ftvt6Ght2heYEIuYkolD727UIRha/zn5JMlFadoJtIPgcbKVEBJTijG4uaWAL5q5
2YwOq74AAX5DGzASSsg8t7ngN35Y1S6YK1zXtzdFpWp7/1RM4w6QGP6YorEjRVqy
DF4BZf7y7CPGhD5a8D+K
=AnBa
-----END PGP SIGNATURE-----

--=-JPCnyz0DNSyglLXiYNU7--

