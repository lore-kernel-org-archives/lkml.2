Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1BDWKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:10:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52011 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab1BDWKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:10:02 -0500
Date: Fri, 4 Feb 2011 14:09:44 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH v2] use %pK for /proc/kallsyms and /proc/modules
Message-ID: <20110204220944.GN5503@outflux.net>
References: <20110127004129.GH4981@outflux.net>
 <20110204140351.f9066af0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204140351.f9066af0.akpm@linux-foundation.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, Feb 04, 2011 at 02:03:51PM -0800, Andrew Morton wrote:
> kernel/kallsyms.c: In function 's_show':
> kernel/kallsyms.c:481: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> kernel/kallsyms.c:484: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> kernel/module.c: In function 'module_sect_show':
> kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> kernel/module.c:1171: warning: format '%p' expects type 'void *', but argument 3 has type 'long unsigned int'
> 
> I'm struggling to see how this could have been compile-time or runtime
> tested?

I run-time tested it plenty. The thread contains the various discussions
about compile-time warnings, so I suspect in the last version, I didn't go
examine the warnings (since the origin of the other warnings went away).

I can send a patch to fix it up to cast everything to (void*) if you want?

-Kees

-- 
Kees Cook
Ubuntu Security Team
