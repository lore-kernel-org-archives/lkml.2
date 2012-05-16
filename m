Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2EPOuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:50:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56326 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2EPOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:50:38 -0400
Date: Wed, 16 May 2012 07:50:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] slub: fix a memory leak in get_partial_node()
Message-ID: <20120516145032.GA1139@kroah.com>
References: <1337108498-4104-1-git-send-email-js1304@gmail.com>
 <alpine.DEB.2.00.1205151527150.11923@router.home>
 <alpine.LFD.2.02.1205160935340.1763@tux.localdomain>
 <CAAmzW4PWQiKbs+mdnwG18R=iWHLT=4Bwn8iA110PJaKuvG_AQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAmzW4PWQiKbs+mdnwG18R=iWHLT=4Bwn8iA110PJaKuvG_AQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:56:50PM +0900, JoonSoo Kim wrote:
> 2012/5/16 Pekka Enberg <penberg@kernel.org>:
> > <On Tue, 15 May 2012, Christoph Lameter wrote:
> >
> >> On Wed, 16 May 2012, Joonsoo Kim wrote:
> >>
> >> > In the case which is below,
> >> >
> >> > 1. acquire slab for cpu partial list
> >> > 2. free object to it by remote cpu
> >> > 3. page->freelist = t
> >> >
> >> > then memory leak is occurred.
> >>
> >> Hmmm... Ok so we cannot assign page->freelist in get_partial_node() for
> >> the cpu partial slabs. It must be done in the cmpxchg transition.
> >>
> >> Acked-by: Christoph Lameter <cl@linux.com>
> >
> > Joonsoo, can you please fix up the stable submission format, add
> > Christoph's ACK and resend?
> >
> >                        Pekka
> 
> Thanks for comment.
> I'm a kernel newbie,
> so could you please tell me how to fix up the stable submission format?
> I'm eager to fix it up, but I don't know how to.
> 
> I read stable_kernel_rules.txt, this article tells me I must note
> upstream commit ID.
> Above patch is not included in upstream currently, so I can't find
> upstream commit ID.
> Is 'Acked-by from MAINTAINER' sufficient for submitting to stable-kernel?
> Is below format right for stable submission format?

No.

Please read the second item in the list that says: "Procedure for
submitting patches to the -stable tree" in the file,
Documentation/stable_kernel_rulest.txt.  It states:

 - To have the patch automatically included in the stable tree, add the tag
     Cc: stable@vger.kernel.org
   in the sign-off area. Once the patch is merged it will be applied to
   the stable tree without anything else needing to be done by the author
   or subsystem maintainer.

Does that help?

thanks,

greg k-h
