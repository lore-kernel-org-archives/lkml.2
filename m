Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1CYSaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:30:35 -0400
Received: from tex.lwn.net ([70.33.254.29]:49894 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab1CYSae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:30:34 -0400
Date: Fri, 25 Mar 2011 12:30:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] docs: update the development process document
Message-ID: <20110325123031.45b6a217@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Greg CC'd since many of the changes relate to his work]

The following is some rather belated documentation maintenance; if there
are no objections, I'll try to sneak it upstream before the window closes.

Thanks,

jon
---

Here's a set of changes updating Documentation/development-process.  I have
update kernel releases and relevant statistics, added information for a
couple of tools, zapped some trailing white space, and generally tried to
make it more closely match the current state of affairs.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/development-process/1.Intro          |   18 +-
 Documentation/development-process/2.Process        |  177 ++++++++++----------
 Documentation/development-process/3.Early-stage    |   31 +++-
 Documentation/development-process/4.Coding         |   21 ++-
 Documentation/development-process/5.Posting        |   28 ++--
 Documentation/development-process/6.Followthrough  |   16 +-
 Documentation/development-process/7.AdvancedTopics |    4 +-
 7 files changed, 167 insertions(+), 128 deletions(-)

diff --git a/Documentation/development-process/1.Intro b/Documentation/development-process/1.Intro
index 8cc2cba..9b61448 100644
--- a/Documentation/development-process/1.Intro
+++ b/Documentation/development-process/1.Intro
@@ -56,13 +56,13 @@ information on kernel development.
 
 1.2: WHAT THIS DOCUMENT IS ABOUT
 
-The Linux kernel, at over 6 million lines of code and well over 1000 active
-contributors, is one of the largest and most active free software projects
-in existence.  Since its humble beginning in 1991, this kernel has evolved
-into a best-of-breed operating system component which runs on pocket-sized
-digital music players, desktop PCs, the largest supercomputers in
-existence, and all types of systems in between.  It is a robust, efficient,
-and scalable solution for almost any situation.
+The Linux kernel, at over 8 million lines of code and well over 1000
+contributors to each release, is one of the largest and most active free
+software projects in existence.  Since its humble beginning in 1991, this
+kernel has evolved into a best-of-breed operating system component which
+runs on pocket-sized digital music players, desktop PCs, the largest
+supercomputers in existence, and all types of systems in between.  It is a
+robust, efficient, and scalable solution for almost any situation.
 
 With the growth of Linux has come an increase in the number of developers
 (and companies) wishing to participate in its development.  Hardware
@@ -115,7 +115,7 @@ This document was written by Jonathan Corbet, corbet@lwn.net.  It has been
 improved by comments from Johannes Berg, James Berry, Alex Chiang, Roland
 Dreier, Randy Dunlap, Jake Edge, Jiri Kosina, Matt Mackall, Arthur Marsh,
 Amanda McPherson, Andrew Morton, Andrew Price, Tsugikazu Shibata, and
-Jochen Voﬂ. 
+Jochen Voﬂ.
 
 This work was supported by the Linux Foundation; thanks especially to
 Amanda McPherson, who saw the value of this effort and made it all happen.
@@ -221,7 +221,7 @@ include:
 - Everything that was said above about code review applies doubly to
   closed-source code.  Since this code is not available at all, it cannot
   have been reviewed by the community and will, beyond doubt, have serious
-  problems. 
+  problems.
 
 Makers of embedded systems, in particular, may be tempted to disregard much
 of what has been said in this section in the belief that they are shipping
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 911a451..32584d2 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -14,16 +14,15 @@ The kernel developers use a loosely time-based release process, with a new
 major kernel release happening every two or three months.  The recent
 release history looks like this:
 
-	2.6.26	July 13, 2008
-	2.6.25	April 16, 2008
-	2.6.24	January 24, 2008
-	2.6.23	October 9, 2007
-	2.6.22	July 8, 2007
-	2.6.21	April 25, 2007
-	2.6.20	February 4, 2007
+	2.6.38	March 14, 2011
+	2.6.37	January 4, 2011
+	2.6.36	October 20, 2010
+	2.6.35	August 1, 2010
+	2.6.34	May 15, 2010
+	2.6.33	February 24, 2010
 
 Every 2.6.x release is a major kernel release with new features, internal
-API changes, and more.  A typical 2.6 release can contain over 10,000
+API changes, and more.  A typical 2.6 release can contain nearly 10,000
 changesets with changes to several hundred thousand lines of code.  2.6 is
 thus the leading edge of Linux kernel development; the kernel uses a
 rolling development model which is continually integrating major changes.
@@ -42,13 +41,13 @@ merge window do not come out of thin air; they have been collected, tested,
 and staged ahead of time.  How that process works will be described in
 detail later on).
 
-The merge window lasts for two weeks.  At the end of this time, Linus
-Torvalds will declare that the window is closed and release the first of
-the "rc" kernels.  For the kernel which is destined to be 2.6.26, for
-example, the release which happens at the end of the merge window will be
-called 2.6.26-rc1.  The -rc1 release is the signal that the time to merge
-new features has passed, and that the time to stabilize the next kernel has
-begun.
+The merge window lasts for approximately two weeks.  At the end of this
+time, Linus Torvalds will declare that the window is closed and release the
+first of the "rc" kernels.  For the kernel which is destined to be 2.6.40,
+for example, the release which happens at the end of the merge window will
+be called 2.6.40-rc1.  The -rc1 release is the signal that the time to
+merge new features has passed, and that the time to stabilize the next
+kernel has begun.
 
 Over the next six to ten weeks, only patches which fix problems should be
 submitted to the mainline.  On occasion a more significant change will be
@@ -66,20 +65,19 @@ will get up to somewhere between -rc6 and -rc9 before the kernel is
 considered to be sufficiently stable and the final 2.6.x release is made.
 At that point the whole process starts over again.
 
-As an example, here is how the 2.6.25 development cycle went (all dates in
-2008): 
-
-	January 24	2.6.24 stable release
-	February 10	2.6.25-rc1, merge window closes
-	February 15	2.6.25-rc2
-	February 24	2.6.25-rc3
-	March 4	 	2.6.25-rc4
-	March 9		2.6.25-rc5
-	March 16	2.6.25-rc6
-	March 25	2.6.25-rc7
-	April 1		2.6.25-rc8
-	April 11	2.6.25-rc9
-	April 16	2.6.25 stable release
+As an example, here is how the 2.6.38 development cycle went (all dates in
+2011):
+
+	January 4	2.6.37 stable release
+	January 18	2.6.38-rc1, merge window closes
+	January 21	2.6.38-rc2
+	February 1	2.6.38-rc3
+	February 7	2.6.38-rc4
+	February 15	2.6.38-rc5
+	February 21	2.6.38-rc6
+	March 1		2.6.38-rc7
+	March 7		2.6.38-rc8
+	March 14	2.6.38 stable release
 
 How do the developers decide when to close the development cycle and create
 the stable release?  The most significant metric used is the list of
@@ -87,7 +85,7 @@ regressions from previous releases.  No bugs are welcome, but those which
 break systems which worked in the past are considered to be especially
 serious.  For this reason, patches which cause regressions are looked upon
 unfavorably and are quite likely to be reverted during the stabilization
-period. 
+period.
 
 The developers' goal is to fix all known regressions before the stable
 release is made.  In the real world, this kind of perfection is hard to
@@ -99,26 +97,34 @@ kernels go out with a handful of known regressions though, hopefully, none
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
-"stable team," currently comprised of Greg Kroah-Hartman and Chris Wright.
-The stable team will release occasional updates to the stable release using
-the 2.6.x.y numbering scheme.  To be considered for an update release, a
-patch must (1) fix a significant bug, and (2) already be merged into the
-mainline for the next development kernel.  Continuing our 2.6.25 example,
-the history (as of this writing) is:
-
-	May 1		2.6.25.1
-	May 6		2.6.25.2 
-	May 9		2.6.25.3 
-	May 15		2.6.25.4
-	June 7		2.6.25.5
-	June 9		2.6.25.6
-	June 16		2.6.25.7
-	June 21		2.6.25.8
-	June 24		2.6.25.9
-
-Stable updates for a given kernel are made for approximately six months;
-after that, the maintenance of stable releases is solely the responsibility
-of the distributors which have shipped that particular kernel.
+"stable team," currently consisting of Greg Kroah-Hartman.  The stable team
+will release occasional updates to the stable release using the 2.6.x.y
+numbering scheme.  To be considered for an update release, a patch must (1)
+fix a significant bug, and (2) already be merged into the mainline for the
+next development kernel.  Kernels will typically receive stable updates for
+a little more than one development cycle past their initial release.  So,
+for example, the 2.6.36 kernel's history looked like:
+
+	October 10	2.6.36 stable release
+	November 22	2.6.36.1
+	December 9	2.6.36.2
+	January 7	2.6.36.3
+	February 17	2.6.36.4
+
+2.6.36.4 was the final stable update for the 2.6.36 release.
+
+Some kernels are designated "long term" kernels; they will receive support
+for a longer period.  As of this writing, the current long term kernels
+and their maintainers are:
+
+	2.6.27	Willy Tarreau		(Deep-frozen stable kernel)
+	2.6.32	Greg Kroah-Hartman
+	2.6.35	Andi Kleen		(Embedded flag kernel)
+
+The selection of a kernel for long-term support is purely a matter of a
+maintainer having the need and the time to maintain that release.  There
+are no known plans for long-term support for any specific upcoming
+release.
 
 
 2.2: THE LIFECYCLE OF A PATCH
@@ -130,7 +136,7 @@ each patch implements a change which is desirable to have in the mainline.
 This process can happen quickly for minor fixes, or, in the case of large
 and controversial changes, go on for years.  Much developer frustration
 comes from a lack of understanding of this process or from attempts to
-circumvent it.  
+circumvent it.
 
 In the hopes of reducing that frustration, this document will describe how
 a patch gets into the kernel.  What follows below is an introduction which
@@ -193,8 +199,8 @@ involved.
 2.3: HOW PATCHES GET INTO THE KERNEL
 
 There is exactly one person who can merge patches into the mainline kernel
-repository: Linus Torvalds.  But, of the over 12,000 patches which went
-into the 2.6.25 kernel, only 250 (around 2%) were directly chosen by Linus
+repository: Linus Torvalds.  But, of the over 9,500 patches which went
+into the 2.6.28 kernel, only 112 (around 1.3%) were directly chosen by Linus
 himself.  The kernel project has long since grown to a size where no single
 developer could possibly inspect and select every patch unassisted.  The
 way the kernel developers have addressed this growth is through the use of
@@ -229,7 +235,7 @@ first in trees dedicated to network device drivers, wireless networking,
 etc.  This chain of repositories can be arbitrarily long, though it rarely
 exceeds two or three links.  Since each maintainer in the chain trusts
 those managing lower-level trees, this process is known as the "chain of
-trust." 
+trust."
 
 Clearly, in a system like this, getting patches into the kernel depends on
 finding the right maintainer.  Sending patches directly to Linus is not
@@ -254,7 +260,7 @@ The answer comes in the form of -next trees, where subsystem trees are
 collected for testing and review.  The older of these trees, maintained by
 Andrew Morton, is called "-mm" (for memory management, which is how it got
 started).  The -mm tree integrates patches from a long list of subsystem
-trees; it also has some patches aimed at helping with debugging.  
+trees; it also has some patches aimed at helping with debugging.
 
 Beyond that, -mm contains a significant collection of patches which have
 been selected by Andrew directly.  These patches may have been posted on a
@@ -264,8 +270,8 @@ subsystem tree of last resort; if there is no other obvious path for a
 patch into the mainline, it is likely to end up in -mm.  Miscellaneous
 patches which accumulate in -mm will eventually either be forwarded on to
 an appropriate subsystem tree or be sent directly to Linus.  In a typical
-development cycle, approximately 10% of the patches going into the mainline
-get there via -mm.
+development cycle, approximately 5-10% of the patches going into the
+mainline get there via -mm.
 
 The current -mm patch is available in the "mmotm" (-mm of the moment)
 directory at:
@@ -275,7 +281,7 @@ directory at:
 Use of the MMOTM tree is likely to be a frustrating experience, though;
 there is a definite chance that it will not even compile.
 
-The other -next tree, started more recently, is linux-next, maintained by
+The primary tree for next-cycle patch merging is linux-next, maintained by
 Stephen Rothwell.  The linux-next tree is, by design, a snapshot of what
 the mainline is expected to look like after the next merge window closes.
 Linux-next trees are announced on the linux-kernel and linux-next mailing
@@ -287,25 +293,14 @@ Some information about linux-next has been gathered at:
 
 	http://linux.f-seidel.de/linux-next/pmwiki/
 
-How the linux-next tree will fit into the development process is still
-changing.  As of this writing, the first full development cycle involving
-linux-next (2.6.26) is coming to an end; thus far, it has proved to be a
-valuable resource for finding and fixing integration problems before the
-beginning of the merge window.  See http://lwn.net/Articles/287155/ for
-more information on how linux-next has worked to set up the 2.6.27 merge
-window.
-
-Some developers have begun to suggest that linux-next should be used as the
-target for future development as well.  The linux-next tree does tend to be
-far ahead of the mainline and is more representative of the tree into which
-any new work will be merged.  The downside to this idea is that the
-volatility of linux-next tends to make it a difficult development target.
-See http://lwn.net/Articles/289013/ for more information on this topic, and
-stay tuned; much is still in flux where linux-next is involved.
+Linux-next has become an integral part of the kernel development process;
+all patchs merged during a given merge window should really have found
+their way into linux-next some time before the merge window opens.
+
 
 2.4.1: STAGING TREES
 
-The kernel source tree now contains the drivers/staging/ directory, where
+The kernel source tree contains the drivers/staging/ directory, where
 many sub-directories for drivers or filesystems that are on their way to
 being added to the kernel tree live.  They remain in drivers/staging while
 they still need more work; once complete, they can be moved into the
@@ -313,15 +308,23 @@ kernel proper.  This is a way to keep track of drivers that aren't
 up to Linux kernel coding or quality standards, but people may want to use
 them and track development.
 
-Greg Kroah-Hartman currently (as of 2.6.36) maintains the staging tree.
-Drivers that still need work are sent to him, with each driver having
-its own subdirectory in drivers/staging/.  Along with the driver source
-files, a TODO file should be present in the directory as well.  The TODO
-file lists the pending work that the driver needs for acceptance into
-the kernel proper, as well as a list of people that should be Cc'd for any
-patches to the driver.  Staging drivers that don't currently build should
-have their config entries depend upon CONFIG_BROKEN.  Once they can
-be successfully built without outside patches, CONFIG_BROKEN can be removed.
+Greg Kroah-Hartman currently maintains the staging tree.  Drivers that
+still need work are sent to him, with each driver having its own
+subdirectory in drivers/staging/.  Along with the driver source files, a
+TODO file should be present in the directory as well.  The TODO file lists
+the pending work that the driver needs for acceptance into the kernel
+proper, as well as a list of people that should be Cc'd for any patches to
+the driver.  Current rules require that drivers contributed to staging
+must, at a minimum, compile properly.
+
+Staging can be a relatively easy way to get new drivers into the mainline
+where, with luck, they will come to the attention of other developers and
+improve quickly.  Entry into staging is not the end of the story, though;
+code in staging which is not seeing regular progress will eventually be
+removed.  Distributors also tend to be relatively reluctant to enable
+staging drivers.  So staging is, at best, a stop on the way toward becoming
+a proper mainline driver.
+
 
 2.5: TOOLS
 
@@ -347,11 +350,7 @@ page at:
 
 	http://git-scm.com/
 
-That page has pointers to documentation and tutorials.  One should be
-aware, in particular, of the Kernel Hacker's Guide to git, which has
-information specific to kernel development:
-
-	http://linux.yyz.us/git-howto.html
+That page has pointers to documentation and tutorials.
 
 Among the kernel developers who do not use git, the most popular choice is
 almost certainly Mercurial:
@@ -408,7 +407,7 @@ There are a few hints which can help with linux-kernel survival:
   important to filter on both the topic of interest (though note that
   long-running conversations can drift away from the original subject
   without changing the email subject line) and the people who are
-  participating.  
+  participating.
 
 - Do not feed the trolls.  If somebody is trying to stir up an angry
   response, ignore them.
diff --git a/Documentation/development-process/3.Early-stage b/Documentation/development-process/3.Early-stage
index 307a159..f87ba7b 100644
--- a/Documentation/development-process/3.Early-stage
+++ b/Documentation/development-process/3.Early-stage
@@ -110,8 +110,8 @@ the kernel community's standards.  Some examples include:
 
  - The AppArmor security module made use of internal virtual filesystem
    data structures in ways which were considered to be unsafe and
-   unreliable.  This code has since been significantly reworked, but
-   remains outside of the mainline.
+   unreliable.  This concern (among others) kept AppArmor out of the
+   mainline for years.
 
 In each of these cases, a great deal of pain and extra work could have been
 avoided with some early discussion with the kernel developers.
@@ -138,6 +138,19 @@ patches, and who, if anybody, is attaching Signed-off-by lines to those
 patches.  Those are the people who will be best placed to help with a new
 development project.
 
+The task of finding the right maintainer is sometimes challenging enough
+that the kernel developers have added a script to ease the process:
+
+	.../scripts/get_maintainer.pl
+
+This script will return the current maintainer(s) for a given file or
+directory when given the "-f" option.  If passed a patch on the
+command line, it will list the maintainers who should probably receive
+copies of the patch.  There are a number of options regulating how hard
+get_maintainer.pl will search for maintainers; please be careful about
+using the more aggressive options as you may end up including developers
+who have no real interest in the code you are modifying.
+
 If all else fails, talking to Andrew Morton can be an effective way to
 track down a maintainer for a specific piece of code.
 
@@ -155,11 +168,15 @@ reaction, but, instead, little or no reaction at all.  The sad truth of the
 matter is (1) kernel developers tend to be busy, (2) there is no shortage
 of people with grand plans and little code (or even prospect of code) to
 back them up, and (3) nobody is obligated to review or comment on ideas
-posted by others.  If a request-for-comments posting yields little in the
-way of comments, do not assume that it means there is no interest in the
-project.  Unfortunately, you also cannot assume that there are no problems
-with your idea.  The best thing to do in this situation is to proceed,
-keeping the community informed as you go.
+posted by others.  Beyond that, high-level designs often hide problems
+which are only reviewed when somebody actually tries to implement those
+designs; for that reason, kernel developers would rather see the code.
+
+If a request-for-comments posting yields little in the way of comments, do
+not assume that it means there is no interest in the project.
+Unfortunately, you also cannot assume that there are no problems with your
+idea.  The best thing to do in this situation is to proceed, keeping the
+community informed as you go.
 
 
 3.5: GETTING OFFICIAL BUY-IN
diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index 2278693..f3f1a46 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -131,6 +131,11 @@ classic time/space tradeoff taught in beginning data structures classes
 often does not apply to contemporary hardware.  Space *is* time, in that a
 larger program will run slower than one which is more compact.
 
+More recent compilers take an increasingly active role in deciding whether
+a given function should actually be inlined or not.  So the liberal
+placement of "inline" keywords may not just be excessive; it could also be
+irrelevant.
+
 
 * Locking
 
@@ -285,6 +290,13 @@ be found at https://sparse.wiki.kernel.org/index.php/Main_Page if your
 distributor does not package it); it can then be run on the code by adding
 "C=1" to your make command.
 
+The "Coccinelle" tool (http://coccinelle.lip6.fr/) is able to find a wide
+variety of potential coding problems; it can also propose fixes for those
+problems.  Quite a few "semantic patches" for the kernel have been packaged
+under the scripts/coccinelle directory; running "make coccicheck" will run
+through those semantic patches and report on any problems found.  See
+Documentation/coccinelle.txt for more information.
+
 Other kinds of portability errors are best found by compiling your code for
 other architectures.  If you do not happen to have an S/390 system or a
 Blackfin development board handy, you can still perform the compilation
@@ -308,7 +320,9 @@ The first piece of documentation for any patch is its associated
 changelog.  Log entries should describe the problem being solved, the form
 of the solution, the people who worked on the patch, any relevant
 effects on performance, and anything else that might be needed to
-understand the patch.
+understand the patch.  Be sure that the changelog says *why* the patch is
+worth applying; a surprising number of developers fail to provide that
+information.
 
 Any code which adds a new user-space interface - including new sysfs or
 /proc files - should include documentation of that interface which enables
@@ -321,7 +335,7 @@ boot-time parameters.  Any patch which adds new parameters should add the
 appropriate entries to this file.
 
 Any new configuration options must be accompanied by help text which
-clearly explains the options and when the user might want to select them. 
+clearly explains the options and when the user might want to select them.
 
 Internal API information for many subsystems is documented by way of
 specially-formatted comments; these comments can be extracted and formatted
@@ -372,7 +386,8 @@ which is broken by the change.  For a widely-used function, this duty can
 lead to literally hundreds or thousands of changes - many of which are
 likely to conflict with work being done by other developers.  Needless to
 say, this can be a large job, so it is best to be sure that the
-justification is solid.
+justification is solid.  Note that the Coccinelle tool can help with
+wide-ranging API changes.
 
 When making an incompatible API change, one should, whenever possible,
 ensure that code which has not been updated is caught by the compiler.
diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index f622c1e..903a254 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -60,12 +60,15 @@ even in the short term.
 
 Patches must be prepared against a specific version of the kernel.  As a
 general rule, a patch should be based on the current mainline as found in
-Linus's git tree.  It may become necessary to make versions against -mm,
-linux-next, or a subsystem tree, though, to facilitate wider testing and
-review.  Depending on the area of your patch and what is going on
-elsewhere, basing a patch against these other trees can require a
-significant amount of work resolving conflicts and dealing with API
-changes.
+Linus's git tree.  When basing on mainline, start with a well-known release
+point - a stable or -rc release - rather than branching off the mainline at
+an arbitrary spot.
+
+It may become necessary to make versions against -mm, linux-next, or a
+subsystem tree, though, to facilitate wider testing and review.  Depending
+on the area of your patch and what is going on elsewhere, basing a patch
+against these other trees can require a significant amount of work
+resolving conflicts and dealing with API changes.
 
 Only the most simple changes should be formatted as a single patch;
 everything else should be made as a logical series of changes.  Splitting
@@ -100,11 +103,11 @@ rules of thumb, however, which can help considerably:
    result is a broken kernel, you will make life harder for developers and
    users who are engaging in the noble work of tracking down problems.
 
- - Do not overdo it, though.  One developer recently posted a set of edits
+ - Do not overdo it, though.  One developer once posted a set of edits
    to a single file as 500 separate patches - an act which did not make him
    the most popular person on the kernel mailing list.  A single patch can
    be reasonably large as long as it still contains a single *logical*
-   change. 
+   change.
 
  - It can be tempting to add a whole new infrastructure with a series of
    patches, but to leave that infrastructure unused until the final patch
@@ -162,7 +165,8 @@ To that end, the summary line should describe the effects of and motivation
 for the change as well as possible given the one-line constraint.  The
 detailed description can then amplify on those topics and provide any
 needed additional information.  If the patch fixes a bug, cite the commit
-which introduced the bug if possible.  If a problem is associated with
+which introduced the bug if possible (and please provide both the commit ID
+and the title when citing commits).  If a problem is associated with
 specific log or compiler output, include that output to help others
 searching for a solution to the same problem.  If the change is meant to
 support other changes coming in later patch, say so.  If internal APIs are
@@ -230,7 +234,7 @@ take care of:
    which have had gratuitous white-space changes or line wrapping performed
    by the mail client will not apply at the other end, and often will not
    be examined in any detail.  If there is any doubt at all, mail the patch
-   to yourself and convince yourself that it shows up intact.  
+   to yourself and convince yourself that it shows up intact.
 
    Documentation/email-clients.txt has some helpful hints on making
    specific mail clients work for sending patches.
@@ -287,7 +291,7 @@ something like:
 
 where "nn" is the ordinal number of the patch, "mm" is the total number of
 patches in the series, and "subsys" is the name of the affected subsystem.
-Clearly, nn/mm can be omitted for a single, standalone patch.  
+Clearly, nn/mm can be omitted for a single, standalone patch.
 
 If you have a significant series of patches, it is customary to send an
 introductory description as part zero.  This convention is not universally
@@ -299,5 +303,5 @@ In general, the second and following parts of a multi-part patch should be
 sent as a reply to the first part so that they all thread together at the
 receiving end.  Tools like git and quilt have commands to mail out a set of
 patches with the proper threading.  If you have a long series, though, and
-are using git, please provide the --no-chain-reply-to option to avoid
+are using git, please stay away from the --chain-reply-to option to avoid
 creating exceptionally deep nesting.
diff --git a/Documentation/development-process/6.Followthrough b/Documentation/development-process/6.Followthrough
index a8fba3d8..41d324a 100644
--- a/Documentation/development-process/6.Followthrough
+++ b/Documentation/development-process/6.Followthrough
@@ -66,6 +66,11 @@ be easy to become blinded by your own solution to a problem to the point
 that you don't realize that something is fundamentally wrong or, perhaps,
 you're not even solving the right problem.
 
+Andrew Morton has suggested that every review comment which does not result
+in a code change should result in an additional code comment instead; that
+can help future reviewers avoid the questions which came up the first time
+around.
+
 One fatal mistake is to ignore review comments in the hope that they will
 go away.  They will not go away.  If you repost code without having
 responded to the comments you got the time before, you're likely to find
@@ -100,7 +105,7 @@ entry into a subsystem maintainer's tree.  How that works varies from one
 subsystem to the next; each maintainer has his or her own way of doing
 things.  In particular, there may be more than one tree - one, perhaps,
 dedicated to patches planned for the next merge window, and another for
-longer-term work.  
+longer-term work.
 
 For patches applying to areas for which there is no obvious subsystem tree
 (memory management patches, for example), the default tree often ends up
@@ -109,11 +114,10 @@ through the -mm tree.
 
 Inclusion into a subsystem tree can bring a higher level of visibility to a
 patch.  Now other developers working with that tree will get the patch by
-default.  Subsystem trees typically feed into -mm and linux-next as well,
-making their contents visible to the development community as a whole.  At
-this point, there's a good chance that you will get more comments from a
-new set of reviewers; these comments need to be answered as in the previous
-round.
+default.  Subsystem trees typically feed linux-next as well, making their
+contents visible to the development community as a whole.  At this point,
+there's a good chance that you will get more comments from a new set of
+reviewers; these comments need to be answered as in the previous round.
 
 What may also happen at this point, depending on the nature of your patch,
 is that conflicts with work being done by others turn up.  In the worst
diff --git a/Documentation/development-process/7.AdvancedTopics b/Documentation/development-process/7.AdvancedTopics
index 8371794..26dc3fa 100644
--- a/Documentation/development-process/7.AdvancedTopics
+++ b/Documentation/development-process/7.AdvancedTopics
@@ -119,7 +119,7 @@ can affect your ability to get trees pulled in the future.  Quoting Linus:
 	to trust things *without* then having to go and check every
 	individual change by hand.
 
-(http://lwn.net/Articles/224135/).  
+(http://lwn.net/Articles/224135/).
 
 To avoid this kind of situation, ensure that all patches within a given
 branch stick closely to the associated topic; a "driver fixes" branch
@@ -138,7 +138,7 @@ When requesting a pull, be sure to give all the relevant information: where
 your tree is, what branch to pull, and what changes will result from the
 pull.  The git request-pull command can be helpful in this regard; it will
 format the request as other developers expect, and will also check to be
-sure that you have remembered to push those changes to the public server. 
+sure that you have remembered to push those changes to the public server.
 
 
 7.2: REVIEWING PATCHES
-- 
1.7.4.1

