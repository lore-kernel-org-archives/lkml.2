Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1HPOAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1HPOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:00:05 -0400
Date: Tue, 16 Aug 2011 09:59:55 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11 re-post take #2] dynamic_debug: consolidate
 repetitive struct _ddebug descriptor definitions
Message-ID: <20110816135955.GA2575@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
 <1313089327.13877.11.camel@Joe-Laptop>
 <20110811205253.GC6670@redhat.com>
 <1313131164.27549.18.camel@Joe-Laptop>
 <20110815204438.GA7157@redhat.com>
 <1313449947.22221.13.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313449947.22221.13.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 04:12:27PM -0700, Joe Perches wrote:
> On Mon, 2011-08-15 at 16:44 -0400, Jason Baron wrote:
> > Replace the repetitive  struct _ddebug descriptor definitions with
> > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> []
> > diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> []
> > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > +	static struct _ddebug __used __aligned(8)		\
> > +	__attribute__((section("__verbose"))) name = {		\
> []
> 
> Jason, just one more thing...
> 
> Because the original struct _ddebug definition
> above this uses __attribute__((aligned(8))),
> 
> struct _ddebug {
> 	[...]
> } __attribute__((aligned(8)));
> 
> ( and I suppose that should be __aligned(8) instead )
> 
> the __aligned(8) use in DECLARE_DYNAMIC_DEBUG_METADATA
> is not necessary.
> 
> cheers, Joe
> 

Hi Joe,

hmmm....what we probably need here, is an extra array of pointers into
the dynamic debug structures. The reason being is that 'aligned' only
specifies the minimum alignment, so the dynamic debug structures could
be aligned to higher multiples, thus leaving extra padding. Since the
dynamic debug code relies on a contiguous array this could lead to NULl
pointer exceptions. This has been implemented for tracepoints, see: 
https://lkml.org/lkml/2011/1/26/463. I haven't seen this issue in
practice though...

So I'm going to leave the extra alignment specifications for now (they
can't hurt), and at some point we probably need to look at the approach
mentioned above.

Thanks,

-Jason
