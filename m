Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2CYMdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 08:33:18 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab2CYMdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 08:33:16 -0400
Message-ID: <4F6F1081.5000307@nod.at>
Date: Sun, 25 Mar 2012 14:33:05 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML changes for 3.4-rc1
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDC20BD2B700A8299C286B57"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDC20BD2B700A8299C286B57
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Linus,

This are the UML changes for for 3.4-rc1.
Mostly bug fixes and cleanups.

Thanks,
//richard

---
The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7=
e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus-3.4-=
rc1

Al Viro (27):
      um: clean up the includes in ubd
      um: auxvec.h is never used
      um: switch line_remove() to setup_one_line()
      um: switch line_config() to setup_one_line()
      um: get rid of the init_prio mess
      um: convert count_lock to mutex, fix a race in line_open()
      um: fix races between line_open() and line_config()
      um: switch line.c tty drivers to dynamic device creation
      um: get rid of lines_init()
      um: finally kill ->init_str leaks
      um: sorting out the chan mess, part 1
      um: switch users of ->chan_list to ->chan_{in,out} (easy cases)
      um: chan_init_pri is dead now
      um: line->have_irq is never checked...
      um: race fix: initialize delayed_work *before* registering IRQ
      um: switch close_chan() to struct line
      um: merge processor_{32,64}.h a bit...
      um: asm-offsets.h might as well come from underlying arch...
      um: remove pointless include of asm/fixmap.h from asm/pgtable.h
      um: kill HOST_TASK_PID
      um: ptrace-generic.h doesn't need user.h
      um: a bunch of headers can be killed by using generic-y
      um: use the right ifdef around exports in user_syms.c
      um: don't bother trying to rebuild CHECKFLAGS for USER_OBJS
      um: deadlock in line_write_interrupt()
      um: most of the SUBARCH uses can be killed
      um: allow SUBARCH=3Dx86

Geert Uytterhoeven (1):
      uml/hostfs: Propagate dirent.d_type to filldir()

Richard Weinberger (6):
      Introduce CONFIG_GENERIC_IO
      um: Serve io_remap_pfn_range()
      um: Wire CONFIG_GENERIC_IO up
      MTD: Relax dependencies
      um: Switch to large mcmodel on x86_64
      um: Update defconfig

Yong Zhang (1):
      um: irq: Remove IRQF_DISABLED

 arch/um/Kconfig.common                  |    1 +
 arch/um/Makefile                        |    5 +-
 arch/um/defconfig                       |  655 ++++++++++++++++++++++---=
------
 arch/um/drivers/chan.h                  |   18 +-
 arch/um/drivers/chan_kern.c             |  198 ++++------
 arch/um/drivers/chan_user.h             |    2 -
 arch/um/drivers/line.c                  |  258 ++++++-------
 arch/um/drivers/line.h                  |   29 +-
 arch/um/drivers/mconsole_kern.c         |    2 +-
 arch/um/drivers/net_kern.c              |    2 +-
 arch/um/drivers/port_kern.c             |    4 +-
 arch/um/drivers/random.c                |    2 +-
 arch/um/drivers/ssl.c                   |   41 +-
 arch/um/drivers/stdio_console.c         |   46 ++--
 arch/um/drivers/{ubd_user.h =3D> ubd.h}   |    0
 arch/um/drivers/ubd_kern.c              |   46 +--
 arch/um/drivers/ubd_user.c              |    8 +-
 arch/um/drivers/xterm_kern.c            |    2 +-
 arch/um/include/asm/Kbuild              |    2 +-
 arch/um/include/asm/asm-offsets.h       |    1 -
 arch/um/include/asm/auxvec.h            |    4 -
 arch/um/include/asm/current.h           |   13 -
 arch/um/include/asm/delay.h             |   18 -
 arch/um/include/asm/io.h                |   57 ---
 arch/um/include/asm/mutex.h             |    9 -
 arch/um/include/asm/param.h             |   20 -
 arch/um/include/asm/pci.h               |    6 -
 arch/um/include/asm/pgalloc.h           |    3 +-
 arch/um/include/asm/pgtable.h           |    2 +
 arch/um/include/asm/ptrace-generic.h    |    1 -
 arch/um/include/shared/common-offsets.h |    2 -
 arch/um/include/shared/kern_util.h      |    2 +-
 arch/um/kernel/Makefile                 |    2 +-
 arch/um/kernel/process.c                |    4 +-
 arch/um/kernel/sigio.c                  |    2 +-
 arch/um/kernel/time.c                   |    2 +-
 arch/um/os-Linux/Makefile               |    2 -
 arch/um/os-Linux/user_syms.c            |    2 +-
 arch/um/scripts/Makefile.rules          |    7 +-
 arch/x86/Makefile.um                    |    4 -
 arch/x86/um/Kconfig                     |    4 +-
 arch/x86/um/asm/processor.h             |   10 +
 arch/x86/um/asm/processor_32.h          |   10 -
 arch/x86/um/asm/processor_64.h          |   10 -
 arch/x86/um/bugs_32.c                   |    4 +-
 drivers/mtd/Kconfig                     |    2 +-
 drivers/mtd/devices/Kconfig             |    1 +
 drivers/mtd/maps/Kconfig                |    1 +
 drivers/mtd/nand/Kconfig                |    2 +
 drivers/mtd/onenand/Kconfig             |    1 +
 fs/hostfs/hostfs.h                      |    3 +-
 fs/hostfs/hostfs_kern.c                 |    5 +-
 fs/hostfs/hostfs_user.c                 |    4 +-
 lib/Kconfig                             |    5 +
 54 files changed, 813 insertions(+), 733 deletions(-)
 rename arch/um/drivers/{ubd_user.h =3D> ubd.h} (100%)
 delete mode 100644 arch/um/include/asm/asm-offsets.h
 delete mode 100644 arch/um/include/asm/auxvec.h
 delete mode 100644 arch/um/include/asm/current.h
 delete mode 100644 arch/um/include/asm/delay.h
 delete mode 100644 arch/um/include/asm/io.h
 delete mode 100644 arch/um/include/asm/mutex.h
 delete mode 100644 arch/um/include/asm/param.h
 delete mode 100644 arch/um/include/asm/pci.h


--------------enigEDC20BD2B700A8299C286B57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPbxCHAAoJEPmeIjfg4UaamQYQAKntRGM45reT/4A1NgpJ8nPf
Xr3n9VfFH2TbgHFp9eFm6peLlenpI6RHIdFB1m1Tx8T4ab5Rlni76CuBstpG1ZJx
sOtsXgrtG5rm+s3nprzfNigHlMHnO77i/AMEHl7pLeK5FGdtylZoMiSvNZL5xmi7
boTMBzwcCyPXAWJoJNjaL0M0EgRcOHKR97G059pKGk/viiSEPeuNCiNdMUyNYGJ8
tbSPVyjSnSIPqEaLcWPI7Y1mbkzhKQxtRv7d2yDlSdlyDuBj2c4RITIlUCrmtLz5
cP0tu75EkNG8iJeSomfraeImlGAbhw2Za+n9TTiJhLe4v0/DlZTAGXBIJ46Fa0ad
akUF5cbhWe7tAr6+TAydTLlt/9+YJCHGPptSuOkVGhnGQbagdkqpbeiHaPo1Kdz0
VIfFzrnIXKbGD1QqjN03YrfETAnx8dVziknKfLJaUxpA6fVDQGUDFrYRpK3nd9El
SkNekJ7eUPUvW89BXun4KUkecMct4l+CvJ4Vpn7+QkQycFxe7Z32/k4AwE0fbapG
O+OiK/XKpdG6eTfMy1IbmzG8LnseCNMmoJkyoIAbRdcuRVcxHnerK62R6mCDBGyH
03EdvgwCS0nACdLcoRpJ448Ifj1bpLGtGWjLsOui6aMuZi0girGq43icSFVArxaZ
O23y7YS4Wwy3nqTkjeUT
=3LpE
-----END PGP SIGNATURE-----

--------------enigEDC20BD2B700A8299C286B57--
