Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1FPEgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:36:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34791 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1FPEgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:36:07 -0400
Date: Wed, 15 Jun 2011 21:35:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Cc: torvalds <torvalds@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS &
 VM_STACK_INCOMPLETE_SETUP
Message-Id: <20110615213549.9b399976.randy.dunlap@oracle.com>
In-Reply-To: <201106160359.p5G3x3j4020081@hera.kernel.org>
References: <201106160359.p5G3x3j4020081@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4DF98830.0095:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 03:59:03 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/linus/7f81c8890c15a10f5220bebae3b6dfae4961962a
> Commit:     7f81c8890c15a10f5220bebae3b6dfae4961962a
> Parent:     b0825ee3a8c570df4873ee397fa453e67fdad5d7
> Author:     Michal Hocko <mhocko@suse.cz>
> AuthorDate: Wed Jun 15 15:08:11 2011 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Jun 15 20:03:59 2011 -0700
> 
>     fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
>     
>     Commit a8bef8ff6ea1 ("mm: migration: avoid race between shift_arg_pages()
>     and rmap_walk() during migration by not migrating temporary stacks")
>     introduced a BUG_ON() to ensure that VM_STACK_FLAGS and
>     VM_STACK_INCOMPLETE_SETUP do not overlap.  The check is a compile time
>     one, so BUILD_BUG_ON is more appropriate.
>     
>     Signed-off-by: Michal Hocko <mhocko@suse.cz>
>     Cc: Mel Gorman <mel@csn.ul.ie>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

fwiw, I just reported that this causes a build error in UML on x86_64
in mmotm-2011-06-15:

When building UML for x86_64 (defconfig), I get:

fs/built-in.o: In function `__bprm_mm_init':
mmotm-2011-0615-1656/fs/exec.c:280: undefined reference to `__build_bug_on_failed'


> ---
>  fs/exec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 97e0d52..b54f74f 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -277,7 +277,7 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>  	 * use STACK_TOP because that can depend on attributes which aren't
>  	 * configured yet.
>  	 */
> -	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
> +	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
>  	vma->vm_end = STACK_TOP_MAX;
>  	vma->vm_start = vma->vm_end - PAGE_SIZE;
>  	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
