Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1BDWe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:34:28 -0500
Received: from mail.perches.com ([173.55.12.10]:3603 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab1BDWe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:34:27 -0500
Subject: Re: [PATCH v2] use %pK for /proc/kallsyms and /proc/modules
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
In-Reply-To: <20110204142147.006bf978.akpm@linux-foundation.org>
References: <20110127004129.GH4981@outflux.net>
	 <20110204140351.f9066af0.akpm@linux-foundation.org>
	 <20110204220944.GN5503@outflux.net>
	 <20110204142147.006bf978.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 14:34:24 -0800
Message-ID: <1296858864.4133.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 14:21 -0800, Andrew Morton wrote:
> On Fri, 4 Feb 2011 14:09:44 -0800
> Kees Cook <kees.cook@canonical.com> wrote:
> > On Fri, Feb 04, 2011 at 02:03:51PM -0800, Andrew Morton wrote:
> > > kernel/kallsyms.c:481: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> > > I'm struggling to see how this could have been compile-time or runtime
> > > tested?
> > I run-time tested it plenty. The thread contains the various discussions
> > about compile-time warnings, so I suspect in the last version, I didn't go
> > examine the warnings (since the origin of the other warnings went away).
> It's passing `unsigned long kallsym_iter.value' into vsprintf as a
> pointer.  Won't vsprintf end up dereferenceing that unsigned long?

No it won't.  %p and %pK output the pointer value.

> > I can send a patch to fix it up to cast everything to (void*) if you want?
> No typecasts, please.  Get the types *correct* and they won't be needed.

There are many printk casts of longs to void *.

grep -rP --include=*.[ch] "\b(printk|pr_*[a-z]+).*\".*\(void \*\)" *

Typecast is the right way to fix this warning using %pK,
though there might be a different/better way altogether.

