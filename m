Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0IPJLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:11:18 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:58960 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab0IPJLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:11:16 -0400
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Documentation/kbuild: major edit of modules.txt sections 1-4
Date: Thu, 16 Sep 2010 02:10:30 -0700
Message-Id: <1284628230-910-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omit needless words and sentences; reorganize and tighten sentence structure;
swap sections 2.2 and 2.3 for a more logical flow; and cleanup some of the
inconsistency with the margin width.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
A couple of notes: 
    I chose to use the environment variable $PWD in the examples for both the commandline
    and Makefile; however, I was wondering if I should have set PWD in the Makefile and
    used $(PWD) instead. Also, the $@ variable was removed from the 'make' command within
    the Makefile. I did not understand the purpose of this for building kernel modules and
    it would break my test build.

Documentation/kbuild/modules.txt |  264 ++++++++++++++++++-------------------
 1 files changed, 128 insertions(+), 136 deletions(-)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 0767cf6..42d7329 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -10,8 +10,8 @@ In this document you will find information about:
 	=== 1 Introduction
 	=== 2 How to build external modules
 	   --- 2.1 Building external modules
-	   --- 2.2 Available targets
-	   --- 2.3 Available options
+	   --- 2.2 Options
+	   --- 2.3 Targets
 	   --- 2.4 Preparing the kernel tree for module build
 	   --- 2.5 Building separate files for a module
 	=== 3. Example commands
@@ -34,128 +34,123 @@ In this document you will find information about:
 
 === 1. Introduction
 
-kbuild includes functionality for building modules both
-within the kernel source tree and outside the kernel source tree.
-The latter is usually referred to as external or "out-of-tree"
-modules and is used both during development and for modules that
-are not planned to be included in the kernel tree.
+kbuild is the build system that is used by the Linux kernel. It includes
+functionality for building modules both inside and outside of the kernel
+source tree. The latter is usually referred to as an external or
+"out-of-tree" module. This is commonly used during development, and for a
+module that is not planned for inclusion within the kernel tree.
 
-What is covered within this file is mainly information to authors
-of modules. The author of an external module should supply
-a makefile that hides most of the complexity, so one only has to type
-'make' to build the module. A complete example will be presented in
-chapter 4, "Creating a kbuild file for an external module".
+Covered in this document is information aimed at developers interested in
+building modules. The author of an external module should supply a Makefile
+that hides most of the complexity, so one only has to type 'make' to build
+the module. A complete example will be presented in section 4, "Creating a
+kbuild file for an external module".
 
 
 === 2. How to build external modules
 
-kbuild offers functionality to build external modules, with the
-prerequisite that there is a pre-built kernel available with full source.
-A subset of the targets available when building the kernel is available
-when building an external module.
+To build external modules you must have a pre-built kernel available with
+full source. If you are using a distribution kernel, there will be a package
+containing the source for their kernel build.
 
 --- 2.1 Building external modules
 
 	Use the following command to build an external module:
 
-		make -C <path-to-kernel> M=`pwd`
+		make -C <path-to-kernel> M=$PWD
 
 	For the running kernel use:
 
-		make -C /lib/modules/`uname -r`/build M=`pwd`
+		make -C /lib/modules/`uname -r`/build M=$PWD
 
 	For the above command to succeed, the kernel must have been
 	built with modules enabled.
 
 	To install the modules that were just built:
 
-		make -C <path-to-kernel> M=`pwd` modules_install
+		make -C <path-to-kernel> M=$PWD modules_install
 
 	More complex examples will be shown later, the above should
 	be enough to get you started.
 
---- 2.2 Available targets
+--- 2.2 Options
 
-	$KDIR refers to the path to the kernel source top-level directory
+	$KDIR is the path to the kernel source directory.
 
-	make -C $KDIR M=`pwd`
-		Will build the module(s) located in current directory.
-		All output files will be located in the same directory
-		as the module source.
-		No attempts are made to update the kernel source, and it is
-		a precondition that a successful make has been executed
-		for the kernel.
+	make -C $KDIR
+		-C is used to specify where to find the kernel source.
+		'make' will actually change to the specified directory
+		when executing and will change back when finished.
 
-	make -C $KDIR M=`pwd` modules
-		The modules target is implied when no target is given.
-		Same functionality as if no target was specified.
-		See description above.
+	make -C $KDIR M=$PWD
+		M= is used to tell kbuild that an external module is being
+		built. The option given to M= is the directory where the
+		external module (kbuild file) is located.
 
-	make -C $KDIR M=`pwd` modules_install
-		Install the external module(s).
-		Installation default is in /lib/modules/<kernel-version>/extra,
-		but may be prefixed with INSTALL_MOD_PATH - see separate
-		chapter.
+	make -C $KDIR SUBDIRS=$PWD
+		Same as M=. The SUBDIRS= syntax is kept for backwards
+		compatibility, but its usage is deprecated.
 
-	make -C $KDIR M=`pwd` clean
-		Remove all generated files for the module - the kernel
-		source directory is not modified.
+--- 2.3 Targets
 
-	make -C $KDIR M=`pwd` help
-		help will list the available target when building external
-		modules.
+	When building an external module, only a subset of the 'make'
+	targets are available.
 
---- 2.3 Available options:
+	make -C $KDIR M=$PWD
+		Build the module(s) located in the current directory; all
+		output files will also be generated in this directory. No
+		attempts are made to update the kernel source, and it is a
+		precondition that a successful 'make' has been executed for
+		the kernel.
 
-	$KDIR refers to the path to the kernel source top-level directory
+	make -C $KDIR M=$PWD modules
+		modules is the default target, it has the same functionality
+		as if no target was specified. See description above.
 
-	make -C $KDIR
-		Used to specify where to find the kernel source.
-		'$KDIR' represent the directory where the kernel source is.
-		Make will actually change directory to the specified directory
-		when executed but change back when finished.
-
-	make -C $KDIR M=`pwd`
-		M= is used to tell kbuild that an external module is
-		being built.
-		The option given to M= is the directory where the external
-		module (kbuild file) is located.
-		When an external module is being built only a subset of the
-		usual targets are available.
-
-	make -C $KDIR SUBDIRS=`pwd`
-		Same as M=. The SUBDIRS= syntax is kept for backwards
-		compatibility.
+	make -C $KDIR M=$PWD modules_install
+		Install the external module(s). The default location is
+		/lib/modules/<kernel-version>/extra, but a prefix may be
+		added with INSTALL_MOD_PATH (discussed in section 6).
+
+	make -C $KDIR M=$PWD clean
+		Remove all generated files in the module directory only.
+
+	make -C $KDIR M=$PWD help
+		help will list the available targets when building external
+		modules.
 
 --- 2.4 Preparing the kernel tree for module build
 
 	To make sure the kernel contains the information required to
-	build external modules the target 'modules_prepare' must be used.
-	'modules_prepare' exists solely as a simple way to prepare
-	a kernel source tree for building external modules.
+	build external modules the target modules_prepare must be used.
+	modules_prepare exists solely as a simple way to prepare a kernel
+	source tree for building external modules.
+
 	Note: modules_prepare will not build Module.symvers even if
-	CONFIG_MODVERSIONS is set. Therefore a full kernel build
+	CONFIG_MODVERSIONS is set; therefore, a full kernel build
 	needs to be executed to make module versioning work.
 
 --- 2.5 Building separate files for a module
-	It is possible to build single files which are part of a module.
-	This works equally well for the kernel, a module and even for
+
+	It is possible to build single files that are part of a module.
+	This works equally well for the kernel, a module, and even for
 	external modules.
-	Examples (module foo.ko, consist of bar.o, baz.o):
-		make -C $KDIR M=`pwd` bar.lst
-		make -C $KDIR M=`pwd` bar.o
-		make -C $KDIR M=`pwd` foo.ko
-		make -C $KDIR M=`pwd` /
+
+	Example (The module foo.ko, consist of bar.o and baz.o):
+		make -C $KDIR M=$PWD bar.o
+		make -C $KDIR M=$PWD baz.o
+		make -C $KDIR M=$PWD foo.ko
+		make -C $KDIR M=$PWD /
 
 
 === 3. Example commands
 
-This example shows the actual commands to be executed when building
-an external module for the currently running kernel.
-In the example below, the distribution is supposed to use the
-facility to locate output files for a kernel compile in a different
-directory than the kernel source - but the examples will also work
-when the source and the output files are mixed in the same directory.
+This example shows the actual commands to be executed when building an
+external module for the currently running kernel. In the example below,
+the distribution is supposed to use the facility to locate output files
+for a kernel compile in a different directory than the kernel source;
+however, the example will also work when the source and the output files
+are mixed in the same directory, provided the links exist.
 
 # Kernel source
 /lib/modules/<kernel-version>/source -> /usr/src/linux-<version>
@@ -164,39 +159,36 @@ when the source and the output files are mixed in the same directory.
 /lib/modules/<kernel-version>/build -> /usr/src/linux-<version>-up
 
 Change to the directory where the kbuild file is located and execute
-the following commands to build the module:
+the following command to build the module:
+
+	cd /home/<username>/src/module
 
-	cd /home/user/src/module
 	make -C /usr/src/`uname -r`/source            \
 	        O=/lib/modules/`uname-r`/build        \
-	        M=`pwd`
+	        M=$PWD
 
 Then, to install the module use the following command:
 
 	make -C /usr/src/`uname -r`/source            \
 	        O=/lib/modules/`uname-r`/build        \
-	        M=`pwd`                               \
+	        M=$PWD                                \
 		modules_install
 
-If you look closely you will see that this is the same command as
-listed before - with the directories spelled out.
-
-The above are rather long commands, and the following chapter
-lists a few tricks to make it all easier.
+Since the commands above are rather long, the subsequent section lists a
+few tricks to make it easier.
 
 
 === 4. Creating a kbuild file for an external module
 
-kbuild is the build system for the kernel, and external modules
-must use kbuild to stay compatible with changes in the build system
-and to pick up the right flags to gcc etc.
+External modules must use kbuild to stay compatible with changes in the
+build system and to pick up the right flags to gcc. As you will soon learn,
+this can be done by using a separate Kbuild file or by using a conditional
+branch within a Makefile. Further documentation describing the syntax used
+by kbuild is located in Documentation/kbuild/makefiles.txt.
 
-The kbuild file used as input shall follow the syntax described
-in Documentation/kbuild/makefiles.txt. This chapter will introduce a few
-more tricks to be used when dealing with external modules.
+The examples below demonstrate how to create a Makefile for the module
+8123.ko, which is built from the following files:
 
-In the following a Makefile will be created for a module with the
-following files:
 	8123_if.c
 	8123_if.h
 	8123_pci.c
@@ -204,26 +196,24 @@ following files:
 
 --- 4.1 Shared Makefile for module and kernel
 
-	An external module always includes a wrapper Makefile supporting
-	building the module using 'make' with no arguments.
-	The Makefile provided will most likely include additional
-	functionality such as test targets etc. and this part shall
-	be filtered away from kbuild since it may impact kbuild if
-	name clashes occurs.
+	An external module always includes a wrapper Makefile that supports
+	building the module using 'make' with no arguments. The Makefile
+	provided may include additional functionality, such as test targets,
+	that will be filtered out from kbuild due to possible name clashes.
 
 	Example 1:
 		--> filename: Makefile
 		ifneq ($(KERNELRELEASE),)
-		# kbuild part of makefile
+		# kbuild part of Makefile
 		obj-m  := 8123.o
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
 		else
 		# Normal Makefile
+		KDIR := /lib/modules/`uname -r`/build
 
-		KERNELDIR := /lib/modules/`uname -r`/build
 		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
@@ -231,15 +221,14 @@ following files:
 
 		endif
 
-	In example 1, the check for KERNELRELEASE is used to separate
-	the two parts of the Makefile. kbuild will only see the two
-	assignments whereas make will see everything except the two
-	kbuild assignments.
+	In example 1, the check for KERNELRELEASE is used to separate the
+	two parts of the Makefile. kbuild will only see the two assignments
+	whereas 'make' will see everything except the two kbuild assignments.
 
-	In recent versions of the kernel, kbuild will look for a file named
-	Kbuild and as second option look for a file named Makefile.
-	Utilising the Kbuild file makes us split up the Makefile in example 1
-	into two files as shown in example 2:
+	In newer versions of the kernel, kbuild will first look for a file
+	named Kbuild and only if that is not found, will it look for a
+	Makefile. Utilizing a Kbuild file allows us to split up the Makefile
+	from example 1 into two files:
 
 	Example 2:
 		--> filename: Kbuild
@@ -247,20 +236,21 @@ following files:
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
 		--> filename: Makefile
-		KERNELDIR := /lib/modules/`uname -r`/build
+		KDIR := /lib/modules/`uname -r`/build
+
 		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
 			echo "X" > 8123_bin.o_shipped
 
+	The split in example 2 is questionable due to the simplicity of
+	each file; however, some external modules use Makefiles consisting
+	of several hundred lines, and here it really pays off to separate
+	the kbuild part from the rest.
 
-	In example 2, we are down to two fairly simple files and for simple
-	files as used in this example the split is questionable. But some
-	external modules use Makefiles of several hundred lines and here it
-	really pays off to separate the kbuild part from the rest.
-	Example 3 shows a backward compatible version.
+	The next example shows a backward compatible version.
 
 	Example 3:
 		--> filename: Kbuild
@@ -269,13 +259,14 @@ following files:
 
 		--> filename: Makefile
 		ifneq ($(KERNELRELEASE),)
+		# kbuild part of Makefile
 		include Kbuild
 		else
 		# Normal Makefile
+		KDIR := /lib/modules/`uname -r`/build
 
-		KERNELDIR := /lib/modules/`uname -r`/build
 		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
@@ -283,28 +274,29 @@ following files:
 
 		endif
 
-	The trick here is to include the Kbuild file from Makefile, so
-	if an older version of kbuild picks up the Makefile, the Kbuild
-	file will be included.
+	Here the Kbuild file is included from the Makefile. This allows an
+	older version of kbuild, which only knows of Makefiles, to be used
+	when the 'make' and kbuild parts are split into separate files.
 
 --- 4.2 Binary blobs included in a module
 
-	Some external modules needs to include a .o as a blob. kbuild
-	has support for this, but requires the blob file to be named
-	<filename>_shipped. In our example the blob is named
-	8123_bin.o_shipped and when the kbuild rules kick in the file
-	8123_bin.o is created as a simple copy off the 8213_bin.o_shipped file
-	with the _shipped part stripped of the filename.
-	This allows the 8123_bin.o filename to be used in the assignment to
-	the module.
+	Some external modules need to include an object file as a blob.
+	kbuild has support for this, but requires the blob file to be
+	named <filename>_shipped. When the kbuild rules kick in, a copy
+	of <filename>_shipped is created with _shipped stripped off
+	giving us <filename>. The shortened filename can be used in the
+	assignment to the module.
+
+	Throughout this section, 8123_bin.o_shipped has been used to build
+	the kernel module 8123.ko; it has been included as 8123_bin.o.
 
 	Example 4:
 		obj-m  := 8123.o
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
-	In example 4, there is no distinction between the ordinary .c/.h files
-	and the binary file. But kbuild will pick up different rules to create
-	the .o file.
+	Although there is no distinction between the ordinary source files
+	and the binary file, kbuild will pick up different rules to create
+	the object file.
 
 
 === 5. Include files
-- 
1.7.2.1

