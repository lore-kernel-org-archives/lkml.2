Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2KHFCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:02:23 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45511 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2KHFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:02:21 -0500
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 8 Nov 2012 03:02:00 -0200
Message-ID: <CAMOw1v6ngskF4mM_oRUA+TpgAAF3U0Gjp-4vC+eJHkKmBBx1KQ@mail.gmail.com>
Subject: [ANNOUNCE] kmod 11
To: linux-modules <linux-modules@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmod 11 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-11.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-11.tar.sign

This is the greatest release ever for those using compressed modules
(I'd like to rather remove it, but some distros are using it so it's
unlikely to happen soon). When using compressed modules there was a
bug regarding modules.order since forever. Now distros don't have to
tweak this file anymore and user can freely mix compressed and
non-compressed modules.

The time needed for running depmod has been greatly reduced with this
release. And this is not exclusive to those using compressed modules.
For non-compressed modules there were reports of a speedup of 3x in
depmod. Check http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=commit;h=1eff942e37adda55bd8c506d4e2a7970fdbf7a74
for details... the timings got improved even more after that commit.

Testsuite also got bug fixes and is now capable of comparing output
files to decide if a test succeeded. Other projects using our
testsuite should upgrade to this new version.

Due to the major refactor in depmod needed to accomplish the speedup
mentioned above, I thought about releasing a -rc1 but then decided to
go straight with a release since it would probably not help a lot.
Please give it more time than usual in your distro testing repository.
If a major bug is found I'll just release another version sooner than
usual.

Last but not least, "--wait" option to rmmod is gone. Or at least it's
now hidden and causing a sleep of 10s if user decides to use it. The
reason is that this feature is being deprecated on kernel side since
it doesn't have any good reason to exist and causes some pain to
maintain.

Take a look in NEWS file for more details on changes. Shortlog is below.

Cheers!
Lucas De Marchi

---

Dave Reisner (5):
      Revert "build-sys: disable jobserver for rootfs target"
      Define rootfs as dependency of check-am
      Makefile: remove redundant flags to $(RM)
      modinfo: clarify verbiage for field shortcuts
      build-sys: Remove --with-rootprefix option

Jan Engelhardt (1):
      NEWS: language corrections

Leandro Pereira (1):
      libkmod-hash: Plug possible memory leak when free_value is defined

Lucas De Marchi (38):
      testsuite: Fix double definition of 64-bits variant
      build-sys: Append -Werror when testing flags
      depmod: fix parsing of modules.order with compressed modules
      testsuite: allow to check generated files
      testsuite: add depmod test for modules.alias
      libkmod: Add support for '.' in module parameter on kcmdline
      rmmod: Deprecate --wait option
      libkmod: cache open file for later access
      build-sys: use AS_IF autoconf macro
      depmod: do not create a hole in struct depmod
      depmod: cache info_list in struct mod
      depmod: cache dependency_symbol list in struct mod
      depmod: use our copy of modname instead of calling libkmod
      depmod: unref kmod_module once we don't need it anymore
      modprobe: exit in one place
      modprobe: use prio_to_str() helper
      modprobe: prefix libkmod messages to stderr with modprobe:
      modprobe: move log function
      modprobe: prefix log messages to stderr with modprobe
      modprobe: use ERR() instead of fprintf(stderr, ...)
      depmod: prefer ERR and WRN over plain fprintf
      TODO: update file with tasks
      depmod: remove inline from _log
      depmod: add depmod prefix to log messages
      insmod: prefer ERR over plain fprintf
      modinfo: prefer ERR over plain fprintf
      rmmod: prefer ERR over plain fprintf
      rmmod: route all messages to syslog if told to
      tools: share getting program name from argv for all tools
      tools: share function to convert prio to string
      tools: make usage() messages go to stdout rather than stderr
      tools: use a single function for logging libkmod output
      tools: share setting up libkmod log
      tools: share function for logging
      tools: staticize functions that are now only used in log.c
      tools: use program_invocation_short_name provided by libc
      TODO: remove completed action
      kmod 11

Sami Kerola (1):
      build-sys: require xsltproc when manpages are enabled
