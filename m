Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1I3DWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:22:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:43309 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1I3DWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:22:37 -0400
Date: Thu, 29 Sep 2011 23:22:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20110930032231.GB16194@windriver.com>
References: <20110930111241.829ed0ada733516b71ab120d@canb.auug.org.au>
 <CAP=VYLoycp1aUYGxQkb+U70CFRvu=nz6pdd63Zapn7a-+gXWVw@mail.gmail.com>
 <20110930130550.2f6597491fa1b59f3be839e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110930130550.2f6597491fa1b59f3be839e0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: linux-next: build failure after merge of the final tree] On 30/09/2011 (Fri 13:05) Stephen Rothwell wrote:

> Hi Paul,
> 
> On Thu, 29 Sep 2011 22:40:59 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> > On Thu, Sep 29, 2011 at 9:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > After merging the final tree, today's linux-next build (avr32 allnoconfig)
> > > failed like this:
> > >
> > > arch/avr32/mach-at32ap/pio.c: In function 'pio_probe':
> > > arch/avr32/mach-at32ap/pio.c:401: error: 'THIS_MODULE' undeclared (first use in this function)
> > >
> > > Probably revealed by the module.h split up.  I guess it needs export.h
> > > included.
> > 
> > Since export.h does not exist for most people, I'm OK adding it
> > in instances like this as a post-merge patch.
> 
> I had another look at this and it turns out that export.h is already
> included, but only conditionally.  I guess the include just needs moving
> to the top of the file.

Agreed.  A side effect of my "find a linux include and add another below
it" script.   These conditional includes (which are dubious to begin
with) seem to always get caught by that.  I'll fix this up and make it
unconditional for tomorrow.

Thanks,
Paul.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


