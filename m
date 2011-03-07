Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1CGOgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:36:54 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41817 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1CGOgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mzJrVtlAmHWNjrKuOVOJwkCaj/WbYcwJLhMVuQr5sCuJGL3cl1PX8jJUrcC/wk566p
         GeDP7RM4QPHeoZ9QD+TLPPcnBCCxpHCbxAC3FIEtJDL/DqMDdo0TbocRbSRUfYrwRcmY
         UjcoqP5VwAz59v4up2GFVaG0KdK0nG/Z+/mT0=
MIME-Version: 1.0
In-Reply-To: <4D71A88E.2060608@cygnusx-1.org>
References: <4D71668F.9050201@windriver.com>
	<4D71A88E.2060608@cygnusx-1.org>
Date: Mon, 7 Mar 2011 09:36:47 -0500
X-Google-Sender-Auth: BQlKfQBzNS26MHx-58TEO5pJ2-o
Message-ID: <AANLkTim3Bwhp4W2zOcAnNxBzz1hmgvPMjtewt1cW8V0s@mail.gmail.com>
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Nathan Grennan <linux-rt-users@cygnusx-1.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 10:05 PM, Nathan Grennan
<linux-rt-users@cygnusx-1.org> wrote:
> On 03/04/2011 02:24 PM, Paul Gortmaker wrote:
>>
>> As a value add to the 2.6.34 long term release, I'm happy to also
>> announce the availability of 2.6.34-RT.
>>
>> You can find it in the v2.6.34-rt branch at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
>>
>> as a repository of patches.  The v2.6.34-rt branch contains the latest
>> RT patches against the latest v2.6.34.8 kernel release. (The master
>> branch currently stops at v2.6.34 flat, i.e. 2.6.34.0 so to speak.)
>>
>> I've also created over 400 known working RT enabled bisection points
>> between 33 and 34 that you can make use of for testing.  The details
>> on how/why those exist follows - read on if it is of interest to you.
>>
>> Note that all credit of the thinking and engineering of the RT stuff
>> lies with the original patch authors -- to be clear, I'm just doing
>> the grunt work of a carry forward here.
>>
>> Have fun with it, maybe drop me a note if you find it useful etc.
>
> I tried compiling this, and it quickly failed. Ideas?

Yes, it is the header cleanup done in the 33-->34 dev cycle, seen
between the rev list ^9e74e7c b66696e that changes slab.h use.

If you look at 8a2032dba45e24 *in the patch repo* you will see where
I fixed it for the baseline RT-enabled defconfig.  (Meaning I did a
make defconfig, then enabled the RT options).  Your config must be
setting something different/extra.

If you do a git show on the above rev list and on the fix in the patch
repo, you will probably be able to tell what is going on.  Also please
send me your config (off list) so I can ensure it compiles properly myself.

Thanks,
Paul.

>
> I did this on a Fedora 14 x86_64 system with gcc-4.5.1-4.fc14.x86_64.
>
>
> Here is what I did:
>
> 1. Downloaded 2.6.34.8 tarball and extracted it
> 2. git clone -b v2.6.34-rt
> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/rt-patches.git
> 3. cat ../rt-patches/series | xargs -i cat ../rt-patches/{} | patch -p1
> (Applied just fine)
> 4. Copied an 2.6.31-rt configuration to .config
> 5. Ran make oldconfig
> 6. make bzImage
>
>
> CHK include/linux/version.h
> CHK include/generated/utsrelease.h
> HOSTCC scripts/basic/fixdep
> HOSTCC scripts/basic/docproc
> HOSTCC scripts/basic/hash
> CC kernel/bounds.s
> GEN include/generated/bounds.h
> CC arch/x86/kernel/asm-offsets.s
> GEN include/generated/asm-offsets.h
> CALL scripts/checksyscalls.sh
> HOSTCC scripts/genksyms/genksyms.o
> HOSTCC scripts/genksyms/lex.o
> HOSTCC scripts/genksyms/parse.o
> HOSTLD scripts/genksyms/genksyms
> CC scripts/mod/empty.o
> HOSTCC scripts/mod/mk_elfconfig
> MKELF scripts/mod/elfconfig.h
> HOSTCC scripts/mod/file2alias.o
> HOSTCC scripts/mod/modpost.o
> HOSTCC scripts/mod/sumversion.o
> HOSTLD scripts/mod/modpost
> HOSTCC scripts/selinux/genheaders/genheaders
> HOSTCC scripts/selinux/mdp/mdp
> HOSTCC scripts/kallsyms
> HOSTCC scripts/conmakehash
> CC init/main.o
> init/main.c: In function ‘do_one_initcall’:
> init/main.c:740:10: warning: ‘calltime.tv64’ may be used uninitialized in
> this function
> CHK include/generated/compile.h
> CC init/version.o
> CC init/do_mounts.o
> In file included from include/linux/suspend.h:8:0,
> from init/do_mounts.c:6:
> include/linux/mm.h: In function ‘pte_lock_init’:
> include/linux/mm.h:1125:2: error: implicit declaration of function ‘kmalloc’
> include/linux/mm.h:1125:12: warning: assignment makes pointer from integer
> without a cast
> include/linux/mm.h: In function ‘pte_lock_deinit’:
> include/linux/mm.h:1137:2: error: implicit declaration of function ‘kfree’
> In file included from include/linux/security.h:36:0,
> from init/do_mounts.c:8:
> include/linux/slab.h: At top level:
> include/linux/slab.h:144:6: warning: conflicting types for ‘kfree’
> include/linux/mm.h:1137:2: note: previous implicit declaration of ‘kfree’
> was here
> In file included from include/linux/slab.h:172:0,
> from include/linux/security.h:36,
> from init/do_mounts.c:8:
> include/linux/slab_def.h:128:52: error: conflicting types for ‘kmalloc’
> include/linux/mm.h:1125:14: note: previous implicit declaration of ‘kmalloc’
> was here
> make[1]: *** [init/do_mounts.o] Error 1
> make: *** [init] Error 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
