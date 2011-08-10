Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab1HJXf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:35:57 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48436 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751111Ab1HJXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:35:56 -0400
Date: Wed, 10 Aug 2011 16:35:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: EDAC: Correct Kconfig dependencies
Message-Id: <20110810163554.e4c6cd8e.rdunlap@xenotime.net>
In-Reply-To: <20110810223816.GA28802@redhat.com>
References: <201108101859.p7AIx1tU027687@hera.kernel.org>
	<20110810223816.GA28802@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 18:38:16 -0400 Dave Jones wrote:

> On Wed, Aug 10, 2011 at 06:59:01PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/af9d220bac41dc3201893e1601cc7c44f7da4498
>  > Commit:     af9d220bac41dc3201893e1601cc7c44f7da4498
>  > Parent:     f2c0d0266cc5eb36a4aa44944b4096ec121490aa
>  > Author:     Borislav Petkov <borislav.petkov@amd.com>
>  > AuthorDate: Wed Aug 10 14:43:30 2011 +0200
>  > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
>  > CommitDate: Wed Aug 10 10:57:42 2011 -0700
>  > 
>  >     EDAC: Correct Kconfig dependencies
>  >     
>  >     Both AMD and Intel i7 EDAC drivers use MCE features and are thus
>  >     dependent of this functionality present in the kernel. Express this in
>  >     Kconfig so that randconfig builds don't break.
>  >     
>  >     Reported-by: Randy Dunlap <rdunlap@xenotime.net>
>  >     Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>  >     Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>  >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> This commit broke the build for me..
> 
> drivers/edac/i7core_edac.c:259:18: error: field ‘edac_mce’ has incomplete type
> drivers/edac/i7core_edac.c:262:23: error: ‘MCE_LOG_LEN’ undeclared here (not in a function)
> drivers/edac/i7core_edac.c: In function ‘i7core_mce_output_error’:
> drivers/edac/i7core_edac.c:1671:25: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1672:20: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1673:23: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1674:15: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1675:18: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1676:18: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1680:7: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1742:22: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1742:31: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1743:39: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1744:15: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1751:7: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function ‘i7core_check_error’:
> drivers/edac/i7core_edac.c:1787:50: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1791:3: error: invalid use of undefined type ‘struct mce’
> drivers/edac/i7core_edac.c:1793:49: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function ‘i7core_mce_check_error’:
> drivers/edac/i7core_edac.c:1838:11: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1842:9: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1847:293: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1859:52: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c:1864:9: error: dereferencing pointer to incomplete type
> drivers/edac/i7core_edac.c: In function ‘i7core_unregister_mci’:
> drivers/edac/i7core_edac.c:1910:2: error: implicit declaration of function ‘edac_mce_unregister’ [-Werror=implicit-function-declaration]
> drivers/edac/i7core_edac.c: In function ‘i7core_register_mci’:
> drivers/edac/i7core_edac.c:2008:2: error: implicit declaration of function ‘edac_mce_register’ [-Werror=implicit-function-declaration]
> 
> it needs at least to include asm/mce.h for all the missing types, but the bigger problem
> is that CONFIG_EDAC_MCE not being select'd means that we never build edac_mce.o
> (it's an unselectable bool in drivers/edac/Kconfig)


I mistakenly reported this as a linux 3.1-rc1 build error when in fact it
was a linux-next build error, as Borislav pointed out.

Borislav, did you mean for this patch to be applied to mainline or are there also
patches in linux-next that are needed for mainline with this one?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
