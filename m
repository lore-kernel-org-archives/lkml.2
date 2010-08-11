Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0HKT6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:58:50 -0400
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:46885 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756171Ab0HKT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:58:49 -0400
Subject: Re: [PATCH] DRM: Replace kmalloc/memset combos with kzalloc
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Joe Perches <joe@perches.com>
Cc: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        eric@anholt.net, dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281537344.3976.32.camel@Joe-Laptop.home>
References: <1281532732.2067.11.camel@cowboy>
	 <1281537344.3976.32.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 15:58:43 -0400
Message-ID: <1281556723.1861.3.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 07:35 -0700, Joe Perches wrote:
> On Wed, 2010-08-11 at 09:18 -0400, Davidlohr Bueso wrote:
> > memory allocation in drm_bufs.c is followed by initializing the memory with 0.
> > 
> > Replace the use of kmalloc+memset with kzalloc.
> 
> Perhaps kzalloc's with a multiply could/should also be converted
> to kcalloc.
> 
> > +	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
> 
> 	entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
> 
> etc.
> 
> > +	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
> > +	entry->seglist = kzalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
> > +	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
> > +	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
> 

Doable, but don't see much difference. David, what do you think?

Thanks,
Davidlohr

