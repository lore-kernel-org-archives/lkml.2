Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2DAB71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:59:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37688 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2DAB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
Date: Sun, 1 Apr 2012 09:59:23 +0800
Message-ID: <CANE52KjOF2G_WQmms8+Xu9m2RXmb0=Bc5E94UUFvMc2xhhJ9mA@mail.gmail.com>
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
From: Jike Song <albcamus@gmail.com>
To: Yang Bai <hamo.by@gmail.com>
Cc: mmarek@suse.cz, rostedt@goodmis.org, sboyd@codeaurora.org,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 4:20 PM, Yang Bai <hamo.by@gmail.com> wrote:
> Since now it has some problems when generate TAGS,
> refactor this code. Now it will not show the error
> message and will remove declarations using emacs etags.

Seems broke cscope build:

$ make cscope
  GEN     cscope
sed: can't read cscope: No such file or directory
make: *** [cscope] Error 2

with V=1:

  /bin/sh /Sources/linux-2.6/scripts/tags.sh cscope
+ ignore='( -name SCCS -o -name BitKeeper -o -name .svn -o
-name CVS  -o -name .pc       -o -name .hg  -o           -name .git )
                                           -prune -o'
+ '[' '' = '' ']'
+ tree=
+ '[' '' = '' ']'
+ ALLSOURCE_ARCHS=x86
+ '[' x86_64 = um ']'
+ remove_structs=
+ case "$1" in
+ docscope
+ echo -k
+ echo -q
+ all_sources
+ find_arch_include_sources x86 '*.[chS]'
++ find arch/x86/ -name include -type d
+ include=arch/x86/include
+ '[' -n arch/x86/include ']'
+ archincludedir=' arch/x86/include'
+ find arch/x86/include '(' -name SCCS -o -name BitKeeper -o -name
.svn -o -name CVS -o -name .pc -o -name .hg -o -name .git ')' -prune
-o -name '*.[chS]' -print
+ '[' '!' -z '' ']'
+ find_include_sources '*.[chS]'
+ find include '(' -name SCCS -o -name BitKeeper -o -name .svn -o
-name CVS -o -name .pc -o -name .hg -o -name .git ')' -prune -o -name
config -prune -o -name '*.[chS]' -print
+ for arch in '$ALLSOURCE_ARCHS'
+ find_sources x86 '*.[chS]'
+ find_arch_sources x86 '*.[chS]'
+ for i in '$archincludedir'
+ prune=' -wholename arch/x86/include -prune -o'
+ find arch/x86 '(' -name SCCS -o -name BitKeeper -o -name .svn -o
-name CVS -o -name .pc -o -name .hg -o -name .git ')' -prune -o
-wholename arch/x86/include -prune -o -name '*.[chS]' -print
+ find_other_sources '*.[chS]'
+ find COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS
Makefile README REPORTING-BUGS arch block crypto cscope.files
cscope.out cscope.out.in cscope.out.po drivers firmware fs include
init ipc kernel lib mm net samples scripts security sound tags tools
usr virt '(' -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS
-o -name .pc -o -name .hg -o -name .git ')' -prune -o '(' -name
include -o -name arch -o -name '.tmp_*' ')' -prune -o -name '*.[chS]'
-print
+ cscope -b -f cscope.out
+ '[' -n ']'
+ LANG=C
+ sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
\1;.*\$\/;"\tx$/d' cscope
sed: can't read cscope: No such file or directory
make: *** [cscope] Error 2




-- 
Thanks,
Jike
