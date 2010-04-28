Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0D1LqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:46:02 -0400
Received: from verein.lst.de ([213.95.11.210]:45343 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0D1LqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:46:01 -0400
Date: Wed, 28 Apr 2010 13:45:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com
Cc: akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]: mark ptrace_traceme static
Message-ID: <20100428114541.GA4705@lst.de>
References: <20100201191855.GA11874@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201191855.GA11874@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason this never made it to Linus?

On Mon, Feb 01, 2010 at 08:18:55PM +0100, Christoph Hellwig wrote:
> It's not used outside of ptrace.c, so no need to allow access to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/include/linux/ptrace.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ptrace.h	2010-01-26 18:02:46.745004926 +0100
> +++ linux-2.6/include/linux/ptrace.h	2010-01-26 18:02:51.759268161 +0100
> @@ -81,7 +81,6 @@
>  
>  
>  extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
> -extern int ptrace_traceme(void);
>  extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
>  extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
>  extern int ptrace_attach(struct task_struct *tsk);
> Index: linux-2.6/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.orig/kernel/ptrace.c	2010-01-26 18:02:55.627012005 +0100
> +++ linux-2.6/kernel/ptrace.c	2010-01-26 18:04:22.163015407 +0100
> @@ -220,7 +220,7 @@ out:
>   * Performs checks and sets PT_PTRACED.
>   * Should be used by all ptrace implementations for PTRACE_TRACEME.
>   */
> -int ptrace_traceme(void)
> +static int ptrace_traceme(void)
>  {
>  	int ret = -EPERM;
>  
---end quoted text---
