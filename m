Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0HYFat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:30:49 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:42817 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab0HYFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:30:47 -0400
Date: Wed, 25 Aug 2010 07:32:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] s390: Fix prototype for execve
Message-ID: <20100825053242.GA2153@osiris.boeblingen.de.ibm.com>
References: <4C73F25D.5010205@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C73F25D.5010205@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 12:25:01PM -0400, Jeff Mahoney wrote:
>  Commit d7627467b7a8dd6944885290a03a07ceb28c10eb constified the
>  arguments to execve but missed the s390 prototype.
> 
>  This patch fixes it up.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> 
>  arch/s390/kernel/entry.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/s390/kernel/entry.h
> +++ b/arch/s390/kernel/entry.h
> @@ -42,8 +42,8 @@ long sys_clone(unsigned long newsp, unsi
>  	       int __user *parent_tidptr, int __user *child_tidptr);
>  long sys_vfork(void);
>  void execve_tail(void);
> -long sys_execve(const char __user *name, char __user * __user *argv,
> -		char __user * __user *envp);
> +long sys_execve(const char __user *name, const char __user *const __user *argv,
> +		const char __user *const __user *envp);
>  long sys_sigsuspend(int history0, int history1, old_sigset_t mask);
>  long sys_sigaction(int sig, const struct old_sigaction __user *act,
>  		   struct old_sigaction __user *oact);

A similar patch just got merged. Thanks!
