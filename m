Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab1DZUov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab1DZUot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:44:49 -0400
Subject: Re: [PATCH 2/3] flex_arrays: allow zero length flex arrays
From: Eric Paris <eparis@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Date: Tue, 26 Apr 2011 16:44:31 -0400
In-Reply-To: <1303850332.9308.17366.camel@nimitz>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
	 <20110426014537.1740.68472.stgit@paris.rdu.redhat.com>
	 <1303850332.9308.17366.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1303850672.2101.20.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 13:38 -0700, Dave Hansen wrote:
> On Mon, 2011-04-25 at 21:45 -0400, Eric Paris wrote:
> > Just like kmalloc will allow one to allocate a 0 length segment of memory
> > flex arrays should do the same thing.  It should bomb if you try to use
> > something, but it should at least allow the allocation.
> > 
> > Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> >  lib/flex_array.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> > 
> > diff --git a/lib/flex_array.c b/lib/flex_array.c
> > index 0c33b24..2554a5f 100644
> > --- a/lib/flex_array.c
> > +++ b/lib/flex_array.c
> > @@ -253,9 +253,16 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
> >  	unsigned int end;
> >  	struct flex_array_part *part;
> > 
> > +	if (!fa->total_nr_elements && !start)
> > +		return 0;
> 
> I guess it works either way, but I'd say that checking for a zero 'len'
> prealloc would be more important (and meaningful) than checking a zero
> 'start'.
> 
> If someone passed start=0 and len=44 for a fa->total_nr_elements=0
> array, I'd expect -ENOSPC, but this would return 0.

will fix.

if (!nr_elements && !start)
	return 0;

-Eric

> 
> -- Dave
> 


