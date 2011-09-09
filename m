Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab1IIEQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:16:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1IIEQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:16:35 -0400
Date: Thu, 8 Sep 2011 21:20:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        bvanassche@acm.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
Message-Id: <20110908212041.207d61a9.akpm@linux-foundation.org>
In-Reply-To: <1315540963.11939.12.camel@Joe-Laptop>
References: <cover.1314725877.git.jbaron@redhat.com>
	<94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	<20110908165230.a7505321.akpm@linux-foundation.org>
	<1315534396.11939.10.camel@Joe-Laptop>
	<20110908204200.6cf7abc2.akpm@linux-foundation.org>
	<1315540963.11939.12.camel@Joe-Laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Sep 2011 21:02:43 -0700 Joe Perches <joe@perches.com> wrote:

> On Thu, 2011-09-08 at 20:42 -0700, Andrew Morton wrote:
> > On Thu, 08 Sep 2011 19:13:16 -0700 Joe Perches <joe@perches.com> wrote:
> > > On Thu, 2011-09-08 at 16:52 -0700, Andrew Morton wrote:
> > > > On Tue, 30 Aug 2011 14:28:41 -0400
> > > > Jason Baron <jbaron@redhat.com> wrote:
> > > > > Replace the repetitive struct _ddebug descriptor definitions with
> > > > > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> > > > > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > > > > +	static struct _ddebug __used __aligned(8)		\
> > > > > +	__attribute__((section("__verbose"))) name = {		\
> > > > > +		.modname = KBUILD_MODNAME,			\
> > > > > +		.function = __func__,				\
> > > > > +		.filename = __FILE__,				\
> > > > > +		.format = (fmt),				\
> > > > > +		.lineno = __LINE__,				\
> > > > > +		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
> > > > > +		.enabled = false,				\
> > > > > +	}
> > > > <anal>That macro implements a definition, not a declaration</anal>
> > > Andrew, that's not quite true
> > It's precisely true.
> 
> Not according to the c99 standard section 6.7
> 

That doesn't address the distinction at all - it discusses syntax.

The reason the distinction matters (apart from being just wrong) is
that sometimes we want a macro for the definition and another for the
declaration.  DEFINE_TRACE/DECLARE_TRACE, DECLARE_LGLOCK/DEFINE_LGLOCK,
etc.


