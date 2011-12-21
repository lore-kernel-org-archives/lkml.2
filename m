Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1LUCfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:35:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49942 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1LUCfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:35:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAMOw1v5r8CqO3zWdw9YzhjJVcU7QntwLEeJECbgcU-f3ATWUSQ@mail.gmail.com>
References: <CAMOw1v5r8CqO3zWdw9YzhjJVcU7QntwLEeJECbgcU-f3ATWUSQ@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 21 Dec 2011 00:35:12 -0200
Message-ID: <CAMOw1v6_19WNnRw-vZdypfoJQT0wTjDVDLAfiWL=cnaNhTffAw@mail.gmail.com>
Subject: [ANNOUNCE] kmod 2
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

http://packages.profusion.mobi/kmod/kmod-2.tar.xz


I'm glad to announce the second version of kmod. I'm sorry for not
sending the announcement on this mailing list for the first version.
For those who didn't see the first announcement can check at
http://lwn.net/Articles/472354/.

I thank very much the feedback received for the first version and that
now Jon Masters, the maintainer of module-init-tools, is helping us
with kmod and already announced that kmod will replace
module-init-tools in future
(http://www.jonmasters.org/blog/2011/12/20/libkmod-replaces-module-init-tools/).

I'd like to especially thank Tom Gundersen, Dave Reisner, Marco
d'Itri, Jon Masters, Luis Felipe, Jan Engelhardt and Kay Sievers who
have been extensively testing kmod and helping with compatibility with
previous tools. Right now kmod is tested in i686, x86_64, sparcv9,
powepc64, s390 and ARM. More testers are greatly appreciated,
especially for architectures not mentioned here.

News for this version are (copying from NEWS file):

Some bugs fixed: the worst of them was with an infinite loop when an alias
matched more than one module.

- New APIs in libkmod to:
       - Get soft dependencies
       - Get info from module files parsing ELF
       - Get modversions from files parsing ELF
- Support to load gzipped kernel modules: kmod can be compiled with support to
 gzipped modules by giving the --enable-zlib flag
- Support to forcefully load modules, both vermagic and modversion
- Support to force and nowait removal flags
- Configuration files are parsed in the same order as modprobe: files are
 sorted alphabetically (independently of their dir) and files with the same
 name obey a precedence order
- New tool: kmod-modinfo
- kmod-modprobe gained several features to be a 1:1 replacement for modprobe.
 The only missing things are the options '--showconfig' and '-t / -l'. These
 last ones have been deprecated long ago and they will be removed from
 modprobe. A lot of effort has been put on kmod-modprobe to ensure it
 maintains compabitility with modprobe.
- linux-modules@vger.kernel.org became the official mailing list for kmod

For the next version, we plan to migrate our git repository to
kernel.org. Meanwhile, git repository can be found at
http://git.profusion.mobi/cgit.cgi/kmod.git/ and packages at
http://packages.profusion.mobi/kmod/

Shortlog for kmod 2 is below.

Cristian Rodríguez (2):
     Library must use O_CLOEXEC whenever it opens file descriptors
     Open more file descriptors with O_CLOEXEC

Gustavo Sverzut Barbieri (22):
     implement zlib module loading.
     fix error handling path.
     implement softdeps.
     fix kmod_list_prev().
     introduce kmod_list_last()
     introduce kmod_list_foreach_reverse().
     kmod-modprobe: implement softdeps.
     compatibility: match commands using fnmatch() instead of strcmp().
     TODO: add idea about single file with all compressed modules.
     ELF: initial support for modinfo and strip of modversions and vermagic.
     kmod-modprobe: implement --dump-modversions
     kmod-modprobe: improve --help output.
     elf: fix minimum file size calculation.
     Introduce kmod-modinfo.
     kmod-modinfo: add missing short options.
     kmod-modinfo: fix typo and output format.
     elf: do not output empty strings.
     kmod-modinfo: -p (-F parm) shows also parmtype in Debian
expected formatting.
     elf: fix typo that resulted in invalid uint reads for big-endian
platforms.
     elf: skip leading symbol dot in modversion.
     kmod_module_new_*: improve debugging.
     configure: disable static zlib build.

Jan Engelhardt (3):
     libkmod: use C99 __func__ over GNU-specific __FUNCTION__
     gitignore: only ignore build system files in the top directory
     build: use dist-xz

Kay Sievers (1):
     introduce --with-rootprefix=DIR

Lucas De Marchi (33):
     TODO: add new tasks and notes to future development
     tools: fix kmod-modprobe -R trying to insert module
     Add address of mailing list
     kmod_module: do not find more than the first command
     Lookup for commands in kmod_module_new_from_lookup()
     Use tab instead of spaces
     Fix leak of kmod_module
     Fix wrong name len when converting path to modname
     kmod_modprobe: fix handling of remove commands
     kmod_modprobe: properly handle install/remove commands
     Fix debug message formatting
     build-sys: remove unneeded _SOURCES vars
     Reduce ident by continuing early
     Terminate strv with NULL
     Put blank lines where it's due
     Remove unneeded reference to last string
     Optimize kmod_elf_get_strings() by reducing calls to memcpy
     Make section size constant since it's always the same
     Cache the offset of crc
     elf: fix regression with empty strings
     Fix check for opened indexes
     kmod_modprobe: Fix regression when inserting module
     kmod_config: fix kcmd line parser with dots after =
     Use sorted configuration files in precedence order
     kmod_modprobe: fix description of -C flag
     build-sys: default to "" as rootprefix
     build-sys: remove remaining _SOURCES var
     Move symbols introduced in libkmod2 to the right place
     Removing comments saying flags are not implemented
     build-sys: do not use some compile flags by default
     Update doc to reflect function behavior
     Change error message to reflect reality
     kmod 2

Luis Felipe Strano Moraes (2):
     Removing warnings when compiling on i686 platform.
     Testing for return of alias_normalize.

Ulisses Furquim (1):
     trivial: fix typo causing an infinite loop




Lucas De Marchi
