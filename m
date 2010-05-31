Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0EaMCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:02:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0EaMCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:02:33 -0400
Date: Mon, 31 May 2010 14:02:23 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       a.beregalov@gmail.com, andi@firstfloor.org, dzickus@redhat.com,
       fejes@joco.name, g.liakhovetski@gmx.de, gthelen@google.com,
       hschauhan@nulltrace.org, hui.zhu@windriver.com, jan3sobi3ski@gmail.com,
       jay@goldhive.com, jgunthorpe@obsidianresearch.com, jkacur@redhat.com,
       joe@perches.com, kirr@mns.spb.ru, lizf@cn.fujitsu.com,
       nir.tzachar@gmail.com, rabin@rab.in, rientjes@google.com,
       roland@redhat.com, saalwaechter@gmail.com, shemminger@vyatta.com,
       tabbott@ksplice.com, u.kleine-koenig@pengutronix.de, vbendeb@google.com,
       vda.linux@googlemail.com, wuzhangjin@gmail.com, xt28@gmx.de
Subject: Re: [GIT] kbuild changes for 2.6.35
Message-ID: <20100531120223.GA11700@sepie.suse.cz>
References: <20100527144459.GA14513@sepie.suse.cz>
 <alpine.LFD.2.00.1005300921000.4639@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1005300921000.4639@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ It seems that vger does not like the long Cc: line, let's try with email
addresses only ]


On Sun, May 30, 2010 at 09:22:20AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 27 May 2010, Michal Marek wrote:
> >
> > Denys Vlasenko (18):
> >       Rename .bss.stack to .bss..stack.
> 
> There's a ton of these, and none of them have any explanation 
> what-so-ever.
> 
> I refuse to take stuff like this. If I don't know why somethign happens, I 
> don't want to pull it.

Sorry, here is a more complete description of the changes.
Alternatively, would you pull a branch with the section rename stuff taken
out?

Summary of the changes:
- A new configuration interface (make nconfig)
- Improvements to the other *config interfaces
- Better modpost mismatch reporting
- Section rename to allow for -ffunction-sections -fdata-sections
- Untagged builds without LOCALVERSION_AUTO have a '+' appended to the
  version string
- Lots of minor fixes & improvements.


The following changes since commit abe94c756c08d50566c09a65b9c7fe72f83071c5:
  Linus Torvalds (1):
        Linux 2.6.33-rc6

are available in the git repository at:

  git://repo.or.cz/linux-kbuild.git for-35

Alexander Beregalov (1):
      genksyms: close ref_file after use

Andi Kleen (2):
      Improve kconfig symbol hashing
      kbuild: move -fno-dwarf2-cfi-asm to powerpc only

David Rientjes (1):
      kbuild: improve version string logic

Denys Vlasenko (18):
      Rename .bss.stack to .bss..stack.
      Rename .data.gate to .data..gate.
      Rename .data.init_irqstack to .data..init_irqstack.
      Rename .data..patch.XXX to .data..patch.XXX.
      Rename .data[.percpu][.XXX] to .data[..percpu][..XXX].
      Rename .data.read_mostly to .data..read_mostly.
      Rename .data.vmpages and .data.vm0.XXX to .data..vmpages and .data..vm0.XXX.
      Rename .rodata.compressed to .rodata..compressed.
      Rename .text.ivt to .text..ivt.
      Rename .text.lock to .text..lock.
      Rename .text.page_aligned to .text..page_aligned.
      Rename .text.startup to .text..startup.
      Rename .data.nosave to .data..nosave.
      Rename .data.init to .data..init.
      Rename .data.initvect to .data..initvect.
      Rename .data.lock_aligned to .data..lock_aligned.
      Rename special text sections in arch/frv from .text.XXX to .text..XXX.
      Rename .text.start to .text..start.

Don Zickus (1):
      scripts: change scripts to use system python instead of env

FEJES Jozsef (1):
      kbuild: deb-pkg md5sums

Greg Thelen (1):
      kbuild: Fix checking of scm-identifier variable

Guennadi Liakhovetski (1):
      tags: include headers before source files

Himanshu Chauhan (1):
      scripts/kallsyms: suppress build warning

Hui Zhu (3):
      markup_oops.pl: fix for faulting instruction in the first line of a range
      markup_oops.pl: add options to improve cross-sompilation environments
      markup_oops.pl: minor fixes

Jan III Sobieski (1):
      add random binaries to .gitignore

Jason Gunthorpe (1):
      kbuild: Include gen_initramfs_list.sh and the file list in the .d file

Jiafu He (1):
      kbuild: Fix linking error built-in.o no such file or directory

Joe Perches (1):
      Makefile: Document ability to make file.lst and file.S

John Kacur (2):
      tags: Fix spelling error in comment (is->if)
      tags: Add the ability to make tags for all archs using "all"

John Saalwaechter (1):
      scripts: use %_tmppath in "make rpm-pkg"

Kirill Smelkov (1):
      kbuild: fix a couple of typos in Documentation

Li Zefan (7):
      kconfig: recalc symbol value before showing search results
      kconfig: some small fixes
      kconfig: fix zconfdump()
      gconfig: remove dbg_print_ptype() and dbg_print_stype()
      gconfig: remove show_debug option
      menuconfig: add support to show hidden options which have prompts
      gconfig: add support to show hidden options that have prompts

Michal Marek (9):
      nconfig: mark local functions as such
      scripts/mkcompile_h: don't test for hardcoded paths
      MAINTAINERS: add a few more patterns to kbuild
      Merge branch 'modpost' of git://git.pengutronix.de/git/ukl/linux-2.6 into kbuild/for-next
      tags: Use $SRCARCH
      kbuild: Do not unnecessarily regenerate modules.builtin
      Revert "kbuild: specify absolute paths for cscope"
      kbuild: Generate modules.builtin in make modules_install
      kbuild: Revert part of e8d400a to resolve a conflict

Nir Tzachar (1):
      nconfig: minor fix

Philipp Kohlbecher (1):
      .gitignore: ignore *.lzo files

Rabin Vincent (1):
      scripts: add ARM support to decodecode

Roland McGrath (1):
      kconfig CROSS_COMPILE option

Stephen Hemminger (9):
      scripts: improve checkstack
      checkincludes: fix perlcritic warnings
      checkversion: perl cleanup
      namespace: perlcritic warnings
      profile2linkerlist: fix perl warnings
      export_report: fix perl warnings
      headers_check: fix perl warnings
      headers_install: use local file handles
      headerdep: perlcritic warning

Tim Abbott (5):
      Rename .data.cacheline_aligned to .data..cacheline_aligned.
      Rename .data.init_task to .data..init_task.
      powerpc: remove unused __page_aligned definition.
      Rename .data.page_aligned to .data..page_aligned.
      Rename .bss.page_aligned to .bss..page_aligned.

Uwe Kleine-König (7):
      modpost: members of *driver structs should not point to __init functions
      modpost: define ALL_XXX{IN,EX}IT_SECTIONS
      modpost: give most mismatch constants a better name
      modpost: pass around const struct sectioncheck * instead of enum mismatch
      modpost: remove now unused NO_MISMATCH constant
      modpost: make symbol white list a per mismatch type variable
      modpost: don't allow *driver to reference .init.*

Vadim Bendebury (вб) (1):
      menuconfig: wrap long help lines

Wu Zhangjin (1):
      scripts/Makefile.lib: Align the output of LZO

nir.tzachar@gmail.com (1):
      kconfig: new configuration interface (nconfig)

 .gitignore                                |    1 +
 Documentation/.gitignore                  |    7 +
 Documentation/kbuild/kbuild.txt           |    6 +-
 Documentation/kbuild/kconfig-language.txt |    2 +-
 Documentation/mutex-design.txt            |    4 +-
 MAINTAINERS                               |    5 +-
 Makefile                                  |   65 +-
 arch/frv/kernel/break.S                   |    4 +-
 arch/frv/kernel/entry.S                   |    2 +-
 arch/frv/kernel/head.S                    |    2 +-
 arch/frv/kernel/vmlinux.lds.S             |   10 +-
 arch/frv/mm/tlb-miss.S                    |    2 +-
 arch/h8300/boot/compressed/head.S         |    2 +-
 arch/h8300/boot/compressed/vmlinux.lds    |    2 +-
 arch/ia64/include/asm/asmmacro.h          |   12 +-
 arch/ia64/include/asm/cache.h             |    2 +-
 arch/ia64/include/asm/percpu.h            |    2 +-
 arch/ia64/kernel/Makefile.gate            |    2 +-
 arch/ia64/kernel/gate-data.S              |    2 +-
 arch/ia64/kernel/gate.S                   |    8 +-
 arch/ia64/kernel/gate.lds.S               |   10 +-
 arch/ia64/kernel/init_task.c              |    2 +-
 arch/ia64/kernel/ivt.S                    |    2 +-
 arch/ia64/kernel/minstate.h               |    4 +-
 arch/ia64/kernel/paravirtentry.S          |    2 +-
 arch/ia64/kernel/vmlinux.lds.S            |   28 +-
 arch/ia64/kvm/vmm_ivt.S                   |    2 +-
 arch/ia64/scripts/unwcheck.py             |    2 +-
 arch/ia64/xen/gate-data.S                 |    2 +-
 arch/ia64/xen/xensetup.S                  |    2 +-
 arch/m68knommu/kernel/vmlinux.lds.S       |    4 +-
 arch/m68knommu/platform/68360/head-ram.S  |    2 +-
 arch/m68knommu/platform/68360/head-rom.S  |    2 +-
 arch/mips/lasat/image/head.S              |    2 +-
 arch/mips/lasat/image/romscript.normal    |    2 +-
 arch/parisc/include/asm/cache.h           |    2 +-
 arch/parisc/include/asm/system.h          |    2 +-
 arch/parisc/kernel/head.S                 |    2 +-
 arch/parisc/kernel/init_task.c            |    6 +-
 arch/parisc/kernel/vmlinux.lds.S          |   12 +-
 arch/powerpc/Makefile                     |    5 +
 arch/powerpc/include/asm/cache.h          |    2 +-
 arch/powerpc/include/asm/page_64.h        |    8 -
 arch/powerpc/kernel/vmlinux.lds.S         |   10 +-
 arch/s390/include/asm/cache.h             |    2 +-
 arch/s390/kernel/swsusp_asm64.S           |    2 +-
 arch/sh/boot/compressed/vmlinux.scr       |    2 +-
 arch/sh/include/asm/cache.h               |    2 +-
 arch/sparc/boot/btfixupprep.c             |    2 +-
 arch/sparc/include/asm/cache.h            |    2 +-
 arch/um/kernel/dyn.lds.S                  |    2 +-
 arch/um/kernel/init_task.c                |    2 +-
 arch/um/kernel/uml.lds.S                  |    2 +-
 arch/x86/.gitignore                       |    3 +
 arch/x86/boot/compressed/mkpiggy.c        |    2 +-
 arch/x86/boot/compressed/vmlinux.lds.S    |    4 +-
 arch/x86/include/asm/cache.h              |    2 +-
 arch/x86/kernel/acpi/wakeup_32.S          |    2 +-
 arch/x86/kernel/init_task.c               |    2 +-
 arch/x86/kernel/setup_percpu.c            |    2 +-
 arch/x86/kernel/vmlinux.lds.S             |    4 +-
 include/asm-generic/percpu.h              |   10 +-
 include/asm-generic/vmlinux.lds.h         |   38 +-
 include/linux/cache.h                     |    2 +-
 include/linux/init.h                      |    2 +-
 include/linux/init_task.h                 |    2 +-
 include/linux/linkage.h                   |    8 +-
 include/linux/percpu-defs.h               |    4 +-
 include/linux/spinlock.h                  |    2 +-
 init/Kconfig                              |    8 +
 kernel/module.c                           |    2 +-
 scripts/Makefile.build                    |    2 +-
 scripts/Makefile.lib                      |    2 +-
 scripts/checkincludes.pl                  |   24 +-
 scripts/checkstack.pl                     |   16 +-
 scripts/checkversion.pl                   |   23 +-
 scripts/decodecode                        |   48 +-
 scripts/export_report.pl                  |   37 +-
 scripts/gen_initramfs_list.sh             |    3 +-
 scripts/genksyms/genksyms.c               |    4 +-
 scripts/headerdep.pl                      |    3 +-
 scripts/headers_check.pl                  |   11 +-
 scripts/headers_install.pl                |   19 +-
 scripts/kallsyms.c                        |    6 +-
 scripts/kconfig/Makefile                  |   16 +-
 scripts/kconfig/expr.c                    |   27 +-
 scripts/kconfig/expr.h                    |    5 +-
 scripts/kconfig/gconf.c                   |  113 +--
 scripts/kconfig/gconf.glade               |   26 +-
 scripts/kconfig/lkc.h                     |    7 +-
 scripts/kconfig/lkc_proto.h               |    6 +-
 scripts/kconfig/lxdialog/inputbox.c       |    4 +-
 scripts/kconfig/lxdialog/menubox.c        |   22 +-
 scripts/kconfig/mconf.c                   |   36 +-
 scripts/kconfig/menu.c                    |   28 +-
 scripts/kconfig/nconf.c                   | 1568 +++++++++++++++++++++++++++++
 scripts/kconfig/nconf.gui.c               |  617 ++++++++++++
 scripts/kconfig/nconf.h                   |   95 ++
 scripts/kconfig/symbol.c                  |   30 +-
 scripts/kconfig/util.c                    |    2 +
 scripts/kconfig/zconf.tab.c_shipped       |   25 +-
 scripts/kconfig/zconf.y                   |   25 +-
 scripts/markup_oops.pl                    |   54 +-
 scripts/mkcompile_h                       |    5 +-
 scripts/mod/modpost.c                     |  152 ++--
 scripts/namespace.pl                      |   65 +-
 scripts/package/builddeb                  |    2 +
 scripts/package/mkspec                    |    2 +-
 scripts/profile2linkerlist.pl             |    8 +-
 scripts/rt-tester/rt-tester.py            |    2 +-
 scripts/show_delta                        |    2 +-
 scripts/tags.sh                           |   45 +-
 112 files changed, 3024 insertions(+), 539 deletions(-)
 create mode 100644 Documentation/.gitignore
 create mode 100644 arch/x86/.gitignore
 create mode 100644 scripts/kconfig/nconf.c
 create mode 100644 scripts/kconfig/nconf.gui.c
 create mode 100644 scripts/kconfig/nconf.h
