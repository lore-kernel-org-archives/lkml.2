Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2AEM2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:28:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54020 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2AEM2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:28:07 -0500
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 5 Jan 2012 10:27:44 -0200
Message-ID: <CAMOw1v5dPKLJjekMpCzDTNd2W3AGrfb12hmjcGap1DCttnWuRw@mail.gmail.com>
Subject: [ANNOUNCE] kmod 3
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm glad to announce kmod 3! Signed tarball is available at

http://packages.profusion.mobi/kmod/kmod-3.tar.xz

In this version we added a new implementation of depmod, the only missing tool
to completely replace module-init-tools. We have only a couple of options
missing yet and need more testing, so I'd not say distros could start shipping
kmod instead of module-init-tools yet. This will probably be possible with the
next version.

We removed the several kmod-* tools that mimic the module-init-tools ones. Now
there's only one tool called 'kmod' that does the right thing when symlinks are
used with the previous names.

I'd like to thank again Dave Reisner and Tom Gundersen for the really good work
at testing, reporting bugs and helping on solving them. Right now we received
feedback from them and other people that are testing on the following
architectures: i686, x86_64, sparcv9, sparc64, powerpc64, s390, ARM and sh4.
Any architecture missing here? With this version we also fixed a major bug on
architectures that do not support unaligned accesses.

It's also worth noting that now udev is already using kmod for loading
modules.For more information about new things, please check the NEWS file that
we ship with kmod.

For the next version we plan to review some APIs, extract documentation from
source code and generate the missing man pages. Hopefully we will already be
hosted on kernel.org, too.

Shortlog for kmod 3 is below.

Cristian Rodríguez (2):
      Fix leak on error path
      index_file_open: fix another fd leak on error path.

Dave Reisner (7):
      libkmod-config: remove warning for skipped config files
      modprobe: remove --list option
      modprobe: use lighter access call instead of stat
      kmodprobe: post-remove module deps with 0 refcnt
      tools: unify error verbiage and casing
      libkmod: Fix casing in error output
      libkmod/hash: check for NULL before freeing hash

Gustavo Sverzut Barbieri (33):
      Fix unaligned memory access
      kmod-modprobe: fix leak in command line option processing.
      file: speed up loading non-gzipped modules when zlib is enabled.
      elf: minimum size is enough.
      elf: add get_symbols()
      add test/test-elf
      elf: add bind type to kmod_modversion.
      elf: implement kmod_module_get_dependency_symbols()
      kmod-depmod: initial code (no files generated, untested)
      kmod-depmod: dump devname
      kmod-depmod: dump modules.symbols
      kmod-depmod: dump softdeps.
      kmod-depmod: dump aliases
      kmod-depmod: dump deps.
      kmod-depmod: copy code from module-init-tools/index.c
      kmod-depmod: add utility functions to be used by binary dumps.
      kmod-depmod: dump modules.builtin.bin
      kmod-depmod: dump modules.symbols.bin
      kmod-depmod: dump modules.alias.bin
      kmod-depmod: dump modules.dep.bin
      update TODO
      kmod-depmod: implement -F and -E options.
      kmod-depmod: implement -A (--quick)
      kmod-depmod: refactor extension matching array, support XZ.
      utils/read_str_safe(): fix wrong behavior and bugs.
      libkmod-file: refactor code to avoid ifdef mess.
      elf: zero *array when count is zero.
      kmod-depmod: add missing trailing \n to log messages.
      kmod-depmod: document --config/-C in help output.
      kmod-depmod: fix incorrect math finding out end of dirname.
      utils/array: add array_remove_at()
      kmod-depmod: fix comparison of module priority.
      kmod-depmod: fix replacement of existing modules.

Jan Engelhardt (4):
      build: use pkgconfig to detect zlib
      build: use AC_ARG_WITH for zlib
      Support for loading Xz-compressed modules
      libkmod: remove external cflags from .pc file

Kay Sievers (2):
      do not (mis-)use the config file generator for non-autobuild stuff
      introduce --with-rootlibdir=DIR

Leandro Pereira (3):
      kmod tool: don't keep iterating when command has been executed
      Do not forget parenthesis around if (streq(A, B)).
      libkmod-util: getline_wrapped: return NULL when buffer allocation fails

Lucas De Marchi (63):
      gitignore: ignore dist files
      Remove useless warning causing trouble in sparc64
      Initialize line number with 0
      kmod_modprobe: use basename(argv[0]) in help message
      build-sys: use MKDIR_P
      tools: add skeleton of kmod tool
      tools: kmod: Add global options
      tools: kmod: check progname for handling compat commands
      tools: kmod: Add handling of compat lsmod
      tools: kmod: Add handling of compat rmmod
      tools: kmod: Add handling of compat insmod
      tools: kmod: Add handling of compat modinfo
      tools: kmod: Add handling of compat modprobe
      tools: kmod: add list command
      tools: kmod: print help message when no commands given
      tools: kmod: show wrong command in err message
      build-sys: use AS_IF
      Fix version script with v3 symbols
      TODO: add task in modprobe's compatibility
      Reverse order of dependency list
      Fix kmod_list_remove_n_latest()
      Add functions to get ctx blacklists
      build-sys: remove unneeded _SOURCES var
      Allow to internally get dependencies without copying list
      Do not cache softdeps list
      Add implementation of modprobe's insertion
      Add test for probe insert
      kmod-depmod: Fix leak of dependency vector
      TODO: format and add task
      Log paths if kmod_module_new_from_path() failed
      Remove kmod_ prefix from hash implementation
      Copy missing hash functions from kmod-depmod to libkmod
      build-sys: create libkmod-util.la convenience lib
      hash: add iterator
      kmod-depmod: use hash implementation from util lib
      Move util functions to libkmod-util.c
      Fix header guard
      tools: kmod: bundle depmod together with the others
      Move array implementation from depmode to libkmod-util
      Move libkmod-util.c to convenience util lib
      Use errno instead of return value of init_module()
      Ignore "already loaded" error in module_probe_insert_module()
      Move function to the right place
      Do not call exported function for mod->name
      Use last enum value instead of ARRAY_SIZE
      TODO: add list of things that are different on kmod
      Fix leak of kmod_module and fix code style
      kmod-modprobe: mimic modprobe when removing deps with usecount=0
      util: add helper function to compare timestamps
      config: save list of config paths with their timestamps
      index: save timestamp of each loaded index
      Add call to check if resources are valid
      Add test to check kmod_validate_resources
      TODO: add task for providing man page
      Add missing static const
      config: take a weakref to ctx
      file: take a weakref to ctx
      file: use log facilities
      build-sys: do not install kmod-* tools
      kmod-depmod: demote messages to WRN when non-critical files are missing
      Add missing doc for function argument
      tools: use basename in help message
      kmod 3

--

Lucas De Marchi
