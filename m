Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558Ab0HGDi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:38:59 -0400
Received: from ozlabs.org ([203.10.76.45]:46741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762546Ab0HGDiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:38:55 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [26/34] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
In-reply-to: <20100806210619.GA5863@suse.de>
References: <20100806185836.185076461@clark.site> <1281127997.7543.0.camel@localhost> <20100806210619.GA5863@suse.de>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Fri, 06 Aug 2010 14:06:19 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 07 Aug 2010 13:38:53 +1000
Message-ID: <17422.1281152333@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100806210619.GA5863@suse.de> you wrote:
> On Fri, Aug 06, 2010 at 09:53:17PM +0100, Ben Hutchings wrote:
> > On Fri, 2010-08-06 at 11:57 -0700, Greg KH wrote:
> > > 2.6.32-stable review patch.  If anyone has any objections, please let us 
know.
> > > 
> > > ------------------
> > >  [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in ci
fs_init_dns_resolver() definition
> > > 
> > > From: Michael Neuling <mikey@neuling.org>
> > > 
> > > An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this erro
r
> > > 
> > > fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attr
ibute__' before 'cifs_init_dns_resolver'
> > > 
> > > This adds the correct header file to fix this.
> > [...]
> > 
> > Why <linux/module.h> and not <linux/init.h>?
> 
> Heh, it works :)
> 
> Michael?

It's what David Howells wanted.....

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-08/msg01316.html
(below as well)


> An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> 
> fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'
> 
> This removes the __init from cifs_init_dns_resolver()

That's not really a good idea as the assembler may choose different pieces of
assembly to do variable references and jumps, depending on the section
information.

A better fix is to add:

	#include <linux/module.h>

to the header file.

David

