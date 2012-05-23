Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab2EWTGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646Ab2EWTGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:06:08 -0400
Date: Wed, 23 May 2012 15:06:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] dynamic_debug: Remove __used attribute from metadata
Message-ID: <20120523190602.GD23940@redhat.com>
References: <1337284958.17726.51.camel@joe2Laptop>
 <CAJfuBxw4F-nsEwn6Nh2swo+j4xJprTb_e5o4tOjuJSqqEeCUhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfuBxw4F-nsEwn6Nh2swo+j4xJprTb_e5o4tOjuJSqqEeCUhA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:00:29PM -0600, Jim Cromie wrote:
> On Thu, May 17, 2012 at 2:02 PM, Joe Perches <joe@perches.com> wrote:
> > The __used attribute in the declaration of the
> > dynamic_debug metadata stops the compiler from
> > optimizing and eliminating constant tests and
> > the metadata declaration used in things like:
> >
> >   #define DEBUG_LEVEL 0
> >   if (DEBUG_LEVEL > 1)
> >        pr_debug("foo...");
> >
> > This is a common construct for debugging macros
> > with a constant "level" test.
> >
> > When dynamic_debug is not configured, this is
> > pr_debug and format string is eliminated unless
> > DEBUG_LEVEL is greater than 1.
> >
> > Remove the unnecessary __used attribute so the
> > even the dynamic_debug use of pr_debug can be
> > appropriately optimized away completely.
> >
> 
> 
> Im a bit puzzled - the __used attr is in the
> #if defined(CONFIG_DYNAMIC_DEBUG) branch.
> 
> If its not config'd, the METADATA is not compiled,
> and this should have no effect.
> Did you mean enabled instead of configured ?
> 
> FWIW, removing __used causes no harm here,
> ie it doesnt break dynamic-debug facility.
> 
> Still, Id like to hear from Jason, he wrote it.

Yeah, can't recall atm why its there. I agree that since the call sites
reference the '_ddebug' structure it should be unecessary. So feel free
to add:

Acked-by: Jason Baron <jbaron@redhat.com>

Thanks,

-Jason
