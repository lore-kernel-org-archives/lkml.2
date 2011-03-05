Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab1CEDQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 22:16:15 -0500
Received: from okcforum.org ([173.8.189.10]:41350 "EHLO mail.okcforum.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1CEDQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 22:16:14 -0500
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 22:16:14 EST
Message-ID: <4D71A88E.2060608@cygnusx-1.org>
Date: Fri, 04 Mar 2011 19:05:50 -0800
From: Nathan Grennan <linux-rt-users@cygnusx-1.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com>
In-Reply-To: <4D71668F.9050201@windriver.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:24 PM, Paul Gortmaker wrote:
> As a value add to the 2.6.34 long term release, I'm happy to also
> announce the availability of 2.6.34-RT.
>
> You can find it in the v2.6.34-rt branch at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
>
> as a repository of patches.  The v2.6.34-rt branch contains the latest
> RT patches against the latest v2.6.34.8 kernel release. (The master
> branch currently stops at v2.6.34 flat, i.e. 2.6.34.0 so to speak.)
>
> I've also created over 400 known working RT enabled bisection points
> between 33 and 34 that you can make use of for testing.  The details
> on how/why those exist follows - read on if it is of interest to you.
>
> Note that all credit of the thinking and engineering of the RT stuff
> lies with the original patch authors -- to be clear, I'm just doing
> the grunt work of a carry forward here.
>
> Have fun with it, maybe drop me a note if you find it useful etc.

I tried compiling this, and it quickly failed. Ideas?

I did this on a Fedora 14 x86_64 system with gcc-4.5.1-4.fc14.x86_64.


Here is what I did:

1. Downloaded 2.6.34.8 tarball and extracted it
2. git clone -b v2.6.34-rt 
git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
3. cat ../rt-patches/series | xargs -i cat ../rt-patches/{} | patch -p1 
(Applied just fine)
4. Copied an 2.6.31-rt configuration to .config
5. Ran make oldconfig
6. make bzImage


CHK include/linux/version.h
CHK include/generated/utsrelease.h
HOSTCC scripts/basic/fixdep
HOSTCC scripts/basic/docproc
HOSTCC scripts/basic/hash
CC kernel/bounds.s
GEN include/generated/bounds.h
CC arch/x86/kernel/asm-offsets.s
GEN include/generated/asm-offsets.h
CALL scripts/checksyscalls.sh
HOSTCC scripts/genksyms/genksyms.o
HOSTCC scripts/genksyms/lex.o
HOSTCC scripts/genksyms/parse.o
HOSTLD scripts/genksyms/genksyms
CC scripts/mod/empty.o
HOSTCC scripts/mod/mk_elfconfig
MKELF scripts/mod/elfconfig.h
HOSTCC scripts/mod/file2alias.o
HOSTCC scripts/mod/modpost.o
HOSTCC scripts/mod/sumversion.o
HOSTLD scripts/mod/modpost
HOSTCC scripts/selinux/genheaders/genheaders
HOSTCC scripts/selinux/mdp/mdp
HOSTCC scripts/kallsyms
HOSTCC scripts/conmakehash
CC init/main.o
init/main.c: In function ‘do_one_initcall’:
init/main.c:740:10: warning: ‘calltime.tv64’ may be used uninitialized 
in this function
CHK include/generated/compile.h
CC init/version.o
CC init/do_mounts.o
In file included from include/linux/suspend.h:8:0,
from init/do_mounts.c:6:
include/linux/mm.h: In function ‘pte_lock_init’:
include/linux/mm.h:1125:2: error: implicit declaration of function ‘kmalloc’
include/linux/mm.h:1125:12: warning: assignment makes pointer from 
integer without a cast
include/linux/mm.h: In function ‘pte_lock_deinit’:
include/linux/mm.h:1137:2: error: implicit declaration of function ‘kfree’
In file included from include/linux/security.h:36:0,
from init/do_mounts.c:8:
include/linux/slab.h: At top level:
include/linux/slab.h:144:6: warning: conflicting types for ‘kfree’
include/linux/mm.h:1137:2: note: previous implicit declaration of 
‘kfree’ was here
In file included from include/linux/slab.h:172:0,
from include/linux/security.h:36,
from init/do_mounts.c:8:
include/linux/slab_def.h:128:52: error: conflicting types for ‘kmalloc’
include/linux/mm.h:1125:14: note: previous implicit declaration of 
‘kmalloc’ was here
make[1]: *** [init/do_mounts.o] Error 1
make: *** [init] Error 2
