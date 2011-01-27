Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1A0A3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:29:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34170 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1A0A3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:29:21 -0500
Date: Wed, 26 Jan 2011 16:28:02 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH] use %pK for /proc/kallsyms and /proc/modules
Message-ID: <20110127002802.GF4981@outflux.net>
References: <20110125181058.GA25670@outflux.net>
 <1296087309.2448.33.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1296087309.2448.33.camel@Joe-Laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 04:15:09PM -0800, Joe Perches wrote:
> On Tue, 2011-01-25 at 10:10 -0800, Kees Cook wrote:
> > Note that when compiling with -Wformat, these harmless warnings will
> > be emitted, and can be ignored:
> >   warning: '0' flag used with ‘%p’ gnu_printf format
> 
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> []
> > @@ -477,11 +477,11 @@ static int s_show(struct seq_file *m, void *p)
> >  		 */
> >  		type = iter->exported ? toupper(iter->type) :
> >  					tolower(iter->type);
> > -		seq_printf(m, "%0*lx %c %s\t[%s]\n",
> > +		seq_printf(m, "%0*pK %c %s\t[%s]\n",
> >  			   (int)(2 * sizeof(void *)),
> >  			   iter->value, type, iter->name, iter->module_name);
> 
> You can change this to
> 
> 		seq_printf(m, "%pK %c %s\t[%s]\n",
>   			   iter->value, type, iter->name, iter->module_name);
> 
> as that's the normal size.
> 
> Presto.  No warnings.  Same output.

Ah-ha! I was comparing against POSIX %p, which doesn't zeropad. The
kernel's %p does, so that's perfect! Yay, no warnings. Thanks! I'll send an
updated patch.

-- 
Kees Cook
Ubuntu Security Team
