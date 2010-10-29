Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab0J2Jsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:48:40 -0400
Received: from ozlabs.org ([203.10.76.45]:46426 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0J2Jsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:48:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] kdb: avoid on-stack cpumask, old-style accessors
Date: Fri, 29 Oct 2010 20:18:26 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
References: <201010272030.34310.rusty@rustcorp.com.au> <4CC810A0.80609@windriver.com>
In-Reply-To: <4CC810A0.80609@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010292018.26776.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 10:14:32 pm Jason Wessel wrote:
> On 10/27/2010 05:00 AM, Rusty Russell wrote:
> > That's quite a big stack already; I assume moving it to a static bitmap
> > is OK for this usage (a cpumask_var_t might require kmalloc, not sure
> > that's a good idea here).
> >
> >   
> Hi Rusty,
> 
> This patch seems fine to me, and I'll gladly put it in the merge queue.

Thanks!

> The kdb shell has a 2 phase initialization, in order to support early
> debugging (before the kernel allocators are ready as well as before
> console init).  In the later initialization phase, kmalloc() is
> available.  We could return an error up until the structure is allocated
> by the kdb late init phase.  It is also possible to avoid allocating the
> structure at all if kdb is not configured and free it if you deactivate kdb.

We could, or look harder at that code to see if the mask is really needed?

Thanks,
Rusty.
