Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1BDWWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:22:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab1BDWWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:22:17 -0500
Date: Fri, 4 Feb 2011 14:21:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH v2] use %pK for /proc/kallsyms and /proc/modules
Message-Id: <20110204142147.006bf978.akpm@linux-foundation.org>
In-Reply-To: <20110204220944.GN5503@outflux.net>
References: <20110127004129.GH4981@outflux.net>
	<20110204140351.f9066af0.akpm@linux-foundation.org>
	<20110204220944.GN5503@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 14:09:44 -0800
Kees Cook <kees.cook@canonical.com> wrote:

> Hi Andrew,
> 
> On Fri, Feb 04, 2011 at 02:03:51PM -0800, Andrew Morton wrote:
> > kernel/kallsyms.c: In function 's_show':
> > kernel/kallsyms.c:481: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> > kernel/kallsyms.c:484: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> > kernel/module.c: In function 'module_sect_show':
> > kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> > kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> > 
> > I'm struggling to see how this could have been compile-time or runtime
> > tested?
> 
> I run-time tested it plenty. The thread contains the various discussions
> about compile-time warnings, so I suspect in the last version, I didn't go
> examine the warnings (since the origin of the other warnings went away).
> 

It's passing `unsigned long kallsym_iter.value' into vsprintf as a
pointer.  Won't vsprintf end up dereferenceing that unsigned long?

> I can send a patch to fix it up to cast everything to (void*) if you want?

No typecasts, please.  Get the types *correct* and they won't be needed.
