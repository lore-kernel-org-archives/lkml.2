Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1IIDiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:38:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab1IIDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:37:57 -0400
Date: Thu, 8 Sep 2011 20:42:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        bvanassche@acm.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
Message-Id: <20110908204200.6cf7abc2.akpm@linux-foundation.org>
In-Reply-To: <1315534396.11939.10.camel@Joe-Laptop>
References: <cover.1314725877.git.jbaron@redhat.com>
	<94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	<20110908165230.a7505321.akpm@linux-foundation.org>
	<1315534396.11939.10.camel@Joe-Laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Sep 2011 19:13:16 -0700 Joe Perches <joe@perches.com> wrote:

> On Thu, 2011-09-08 at 16:52 -0700, Andrew Morton wrote:
> > On Tue, 30 Aug 2011 14:28:41 -0400
> > Jason Baron <jbaron@redhat.com> wrote:
> > > Replace the repetitive struct _ddebug descriptor definitions with
> > > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> > > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > > +	static struct _ddebug __used __aligned(8)		\
> > > +	__attribute__((section("__verbose"))) name = {		\
> > > +		.modname = KBUILD_MODNAME,			\
> > > +		.function = __func__,				\
> > > +		.filename = __FILE__,				\
> > > +		.format = (fmt),				\
> > > +		.lineno = __LINE__,				\
> > > +		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
> > > +		.enabled = false,				\
> > > +	}
> > <anal>That macro implements a definition, not a declaration</anal>
> 
> Andrew, that's not quite true

It's precisely true.

: Exercise 2.8
: 
: A declaration introduces a name and a type for something.  It does not
: necessarily reserve any storage.
: 
: Exercise 2.9
: 
: A definition is a declaration that also reserves storage.

(http://publications.gbdirect.co.uk/c_book/answers/chapter_2.html)

> and that's how
> DECLARE is normally used in linux.

It's how it's sometimes used, when we screwed up.

> DECLARE_BITMAP, DECLARE_COMPLETION, DECLARE_RWSEM, etc.

Mistakes.
