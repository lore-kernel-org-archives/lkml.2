Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab0C0EkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 00:40:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54261 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0C0EkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aviIaTvcCyC6ymM5TWIYIByXj3TxoNCvyrJ4XLXXHrsAuJunvXngiYpnYQqgsJ4nzL
         ooemWfW1r+F3GVyg/B9YVobgCgvEFJfH6SDXeuiWFzhruwxAuFlwSOs/iEXEJjhUy+F4
         jx1Z/HFptFN+VH5HETdllLfrtB/iQYCsYMrWM=
Date: Sat, 27 Mar 2010 05:40:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 06/14] tracing: add tracing support for compat syscalls
Message-ID: <20100327044013.GO7166@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com> <a75e730f4fc49c3657d6e407fb16a3508ec321a9.1268749695.git.jbaron@redhat.com> <20100320061215.GN5085@nowhere> <20100322202141.GC2278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322202141.GC2278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 04:21:42PM -0400, Jason Baron wrote:
> On Sat, Mar 20, 2010 at 07:12:17AM +0100, Frederic Weisbecker wrote:
> > >  #else /* CONFIG_COMPAT */
> > >  
> > > +#define NR_syscalls_compat 0
> > > +
> > >  static inline int is_compat_task(void)
> > >  {
> > >  	return 0;
> > > diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> > > index 8f5ac38..1cc1d1e 100644
> > > --- a/include/trace/syscall.h
> > > +++ b/include/trace/syscall.h
> > > @@ -22,6 +22,7 @@
> > >  struct syscall_metadata {
> > >  	const char	*name;
> > >  	int		syscall_nr;
> > > +	int		compat_syscall_nr;
> > 
> > 
> > 
> > Why do you need both syscall_nr and compat_syscall_nr?
> > Compat and usual syscalls never share the same syscall
> > metadata.
> > 
> > 
> 
> For example, something like 'sys_read()' is pointed to by both
> syscalls_metadata and compat_syscalls_metadata. Thus, the same syscall
> metadata record is referenced by two different tables. That said, I'm not
> making use of compat_syscall_nr. Although it could be added to the
> checks in 'reg_event_syscall_enter()', to make sure that the
> compat_syscall_nr is valid. 



Yep, but we need it to be referenced by two different tables
as normal and compat syscalls don't have the exact same
parameters. It is not about the same syscall metadata.

Once we'll get support for user pointer dereferencing to get
user parameters content in the traces, we'll need to build a
table of types to be aware of the type. And these types will
be different between compat and normal syscalls.

