Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2GLIsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:48:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53718 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab2GLIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:48:08 -0400
Date: Thu, 12 Jul 2012 09:47:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chris@zankel.net" <chris@zankel.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>
Subject: Re: [PATCH 2/3] ipc: allow compat IPC version field parsing if
 !ARCH_WANT_OLD_COMPAT_IPC
Message-ID: <20120712084756.GB2816@mudshark.cambridge.arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
 <1342020741-12758-3-git-send-email-will.deacon@arm.com>
 <20120711144001.b1f7c21d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711144001.b1f7c21d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for picking these up.

On Wed, Jul 11, 2012 at 10:40:01PM +0100, Andrew Morton wrote:
> On Wed, 11 Jul 2012 16:32:20 +0100
> Will Deacon <will.deacon@arm.com> wrote:
> > diff --git a/include/linux/compat.h b/include/linux/compat.h
> > index 4e89039..9f68e90 100644
> > --- a/include/linux/compat.h
> > +++ b/include/linux/compat.h
> > @@ -256,6 +256,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
> >  			   compat_size_t __user *len_ptr);
> >  
> >  #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
> > +#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
> >  long compat_sys_semctl(int first, int second, int third, void __user *uptr);
> >  long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
> >  long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
> > diff --git a/ipc/compat.c b/ipc/compat.c
> > index 53cebdf..a41600f 100644
> > --- a/ipc/compat.c
> > +++ b/ipc/compat.c
> > @@ -118,7 +118,7 @@ extern int sem_ctls[];
> >  
> >  static inline int compat_ipc_parse_version(int *cmd)
> >  {
> > -#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
> > +#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
> >  	int version = *cmd & IPC_64;
> >  
> >  	/* this is tricky: architectures that have support for the old
> 
> Could we do this purely in Kconfig?  Add a new
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION and always set it true if
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC?

That would also work, although the current approach mirrors what is done for
the native case (i.e. this is the compat equivalent of
__ARCH_WANT_IPC_PARSE_VERSION).

I'm not too fussed either way, so I can change it if you prefer?

Will
