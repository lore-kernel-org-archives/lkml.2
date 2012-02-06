Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2BFW5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:57:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48110 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab2BFW5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:57:13 -0500
Date: Mon, 6 Feb 2012 20:58:56 -0200
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Subject: [ANNOUNCE] kmod 5
Message-ID: <20120206225856.GA20161@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!!

I'm glad to announce kmod 5! Signed tarball is available at

http://packages.profusion.mobi/kmod/kmod-5.tar.xz
http://packages.profusion.mobi/kmod/kmod-5.tar.sign

This version included several bug fixes and we needed to break the API
in order to be able to share code between the lib and modprobe. Now the
API udev should use is the same as used by modprobe. This way we can
more easily reproduce the bug reports.

We added a testsuite, too. Now it's possible to automate tests and check
for regressions. People out there reporting bugs (I'm looking at package
maintainers) could give a look in testsuite/README if they can add a
test case there to reproduce their problems. Most of the time will be a
copy and paste from other tests + some set up of configs.

This is the last version to be hosted at ProFUSION's servers. We are
finishing to set up stuff on kernel.org and repository and tarballs will
be available there soon.

Please check NEWS file that we ship with kmod for more information.
Shortlog is below.

Lucas De Marchi


---
Ambroz Bizjak (1):
      Fix unaligned memory access in hash function

Dan McGee (6):
      Fix simple grammar issue
      Update .gitignore files
      test-conversion: remove test/test-loaded
      test-conversion: remove test/test-init
      test-conversion: remove test/test-{insmod,rmmod,rmmod2}
      modinfo: handle arguments more carefully

Dave Reisner (9):
      modprobe: remove code referring to -t, --type
      build-sys: declare rootfs.tar.xz as dep of rootfs/
      modprobe: post-remove module deps with 0 refcnt
      testsuite: allow for expected failure of tests
      modprobe: properly handle errors from init_module
      whitespace fix -- no logical code changes
      lib/module: check initstate before inserting module
      modprobe: avoid breaking on insertion failure
      fix building and cleaning of manpages

Gustavo Sverzut Barbieri (3):
      improve log when debugging.
      improve logging to mention context.
      fix manpage build and install.

Khem Raj (1):
      depmod: Dont use errno unconditionally

Lucas De Marchi (67):
      Fix common misspelling with codespell
      modprobe: flush stdout before dumping indexes
      Check if struct stat has mtim member
      build-sys: create symlinks if we are installing tools
      libkmod-list: allow to append an empty list
      Add program to calculate the shortest relative path for symlinks
      build-sys: move modprobe to sbindir
      build-sys: forcefully create links
      TODO: system() should not be used inside a library
      modprobe: kill operations depending on path
      build-sys: do not create symlinks by default
      README: add link to packages place
      modprobe: fix build 'cause of excessive number of arguments
      testsuite: add skeleton
      testsuite: test libkmod initialization
      testsuite: trap calls to uname
      testsuite: move oneshot to inside the test struct
      testsuite: export environment with flags and LD_PRELOAD
      testsuite: fake kernel 4.0.20-kmod is out
      testsuite: add trap to fopen() including tests
      testsuite: add trap to open() including tests
      testsuite: add trap to stat() and friends including tests
      testsuite: add trap to opendir() including tests
      testsuite: allow to run tests outside of top_buildir
      testsuite: separate child from parent
      testsuite: match outputs of test with a known correct one
      testsuite: add simple test for list of loaded modules
      testsuite: add colors to test output
      testsuite: remind users to build tools
      testsuite: add test for modinfo
      elf: privately export kmod_elf_get_section()
      testsuite: add trap to init_module() including simple test
      build-sys: autotoolify build of check libraries
      testsuite: trap calls to delete_module() including simple test
      testsuite: add GPL license
      build-sys: extract rootfs for make check
      modprobe: print end of configuration files
      testsuite: remove unneeded call to memset()
      Use %zu for size_t
      testsuite: let stat.h take care of stat64
      build-sys: fix make dist
      libkmod-module: add visited field
      libkmod-module: probe: change insertion to cover more use cases
      libkmod-module: probe: add flag to ignore commands
      Partially fix parsing of alias with dots
      libkmod-module: split creation of new modules to share code
      testsuite: add test for kmod_module_new_from_name()
      testsuite: check if dots are allowed in aliases
      libkmod-module: probe: add flag to stop loading on already loaded
      libkmod-module: probe: remove useless flag to stop on failure
      libkmod-module: probe: ignore-command flag can't be used in return
      libkmod-module: probe: add room in flags for future extension
      libkmod-module: probe: add print_action callback
      libkmod-module: probe: add flag to ignore loaded modules
      libkmod-module: probe: add flag to dry-run
      kmod-modprobe: migrate to kmod_module_probe_insert_module()
      libkmod-module: probe: return -EEXIST if told to stop on already loaded
      libkmod-module: probe: remove useless KMOD_PROBE_STOP_ON_COMMAND
      Prepare for API bump
      libkmod: organize public header
      man: insmod: we don't handle modules from stdin
      TODO: add task to write testsuite/README
      libkmod-module: probe: rename flag to be more meaningful
      libkmod-module: probe: return -EEXIST if told to do so
      testsuite: add README
      Add WARNING file for test dir and improve testsuite README
      kmod 5

Miklos Vajna (1):
      man: spelling fixes

Pedro Pedruzzi (2):
      testsuite: add test for function alias_normalize
      libkmod: Fix handling of square brackets expressions in function alias_normalize

Thierry Vignaud (1):
      WEXITSTATUS is defined in sys/wait.h
