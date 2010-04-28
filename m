Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0D1NJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0D1NJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:09:05 -0400
Date: Wed, 28 Apr 2010 15:06:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, akpm@linux-foundation.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]: mark ptrace_traceme static
Message-ID: <20100428130652.GA31069@redhat.com>
References: <20100201191855.GA11874@lst.de> <20100428114541.GA4705@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428114541.GA4705@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Christoph Hellwig wrote:
>
> Any reason this never made it to Linus?

The patch is obviously fine, and iirc it was explicitly acked by Roland.

Probably you can resend it to Andrew?

> On Mon, Feb 01, 2010 at 08:18:55PM +0100, Christoph Hellwig wrote:
> > It's not used outside of ptrace.c, so no need to allow access to it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6/include/linux/ptrace.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/ptrace.h	2010-01-26 18:02:46.745004926 +0100
> > +++ linux-2.6/include/linux/ptrace.h	2010-01-26 18:02:51.759268161 +0100
> > @@ -81,7 +81,6 @@
> >  
> >  
> >  extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
> > -extern int ptrace_traceme(void);
> >  extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
> >  extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
> >  extern int ptrace_attach(struct task_struct *tsk);
> > Index: linux-2.6/kernel/ptrace.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/ptrace.c	2010-01-26 18:02:55.627012005 +0100
> > +++ linux-2.6/kernel/ptrace.c	2010-01-26 18:04:22.163015407 +0100
> > @@ -220,7 +220,7 @@ out:
> >   * Performs checks and sets PT_PTRACED.
> >   * Should be used by all ptrace implementations for PTRACE_TRACEME.
> >   */
> > -int ptrace_traceme(void)
> > +static int ptrace_traceme(void)
> >  {
> >  	int ret = -EPERM;
> >  
> ---end quoted text---

