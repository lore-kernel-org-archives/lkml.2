Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2GPP4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:56:20 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:6679 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2GPP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:56:18 -0400
Message-ID: <1342454176.2949.14.camel@lorien2>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Mon, 16 Jul 2012 09:56:16 -0600
In-Reply-To: <alpine.DEB.2.00.1207160915470.28952@router.home>
References: <1342221125.17464.8.camel@lorien2>
	 <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com>
	 <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com>
	 <1342407840.3190.5.camel@lorien2>
	 <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1207160915470.28952@router.home>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 09:17 -0500, Christoph Lameter wrote:
> On Mon, 16 Jul 2012, David Rientjes wrote:
> 
> > On Sun, 15 Jul 2012, Shuah Khan wrote:
> >
> > > I can work on reshuffling the code. Do have a question though. This
> > > following sanity check is currently done only when CONFIG_DEBUG_VM is
> > > defined. However, it does appear to be something that is that should be
> > > checked even in regular path.
> > >
> > > struct kmem_cache *kmem_cache_create(const char *name, size_t size,
> > > size_t align,
> > >                 unsigned long flags, void (*ctor)(void *))
> > > {
> > >         struct kmem_cache *s = NULL;
> > >
> > > #ifdef CONFIG_DEBUG_VM
> > >         if (!name || in_interrupt() || size < sizeof(void *) ||
> > >                 size > KMALLOC_MAX_SIZE) {
> > >                 printk(KERN_ERR "kmem_cache_create(%s) integrity check"
> > >                         " failed\n", name);
> > >                 goto out;
> > >         }
> > > #endif
> > >
> >
> > Agreed, this shouldn't depend on CONFIG_DEBUG_VM.
> 
> These checks are useless for regular kernel operations. They are
> only useful when developing code and should only be enabled during
> development. There is no point in testing the size and the name which are
> typically constant when a slab is created with a stable kernel.
> 

ok. The first debug section is done prior to holding the slab mutex and
the second debug section is after holding mutex. I will have to think
about the best way to restructure the code. I will send the re-worked
patch soon, so we start refining it if need be.

-- Shuah

