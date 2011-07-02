Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1GBSGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 14:06:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13686 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1GBSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:06:29 -0400
Date: Sat, 2 Jul 2011 19:57:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Teigland <teigland@redhat.com>
cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: Re: [PATCH] fs, dlm: Don't leak, don't do pointless NULL checks and
 use kzalloc
In-Reply-To: <20110629221731.GB11350@redhat.com>
Message-ID: <alpine.LNX.2.00.1107021956290.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net> <20110629214056.GA11350@redhat.com> <alpine.LNX.2.00.1106292344110.3747@swampdragon.chaosbits.net> <20110629221731.GB11350@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, David Teigland wrote:

> On Wed, Jun 29, 2011 at 11:51:00PM +0200, Jesper Juhl wrote:
> > > I don't think so; num_nodes won't be set to zero.
> > 
> > Hmm. How so?  Maybe I'm missing something obvious, but;
> > num_nodes is initialized to zero at the beginning of the function, which 
> > means that we'll definately do the first allocation in the loop.
> 
> Zero is meant to mean "first time through the loop".
> 
> > We then set num_nodes equal to ls->ls_num_nodes - what guarantees that 
> > this will not be zero so we won't do a second allocation (and leak) the 
> > second time through the loop?
> 
> That's just the nature of a lockspace, I guess -- it doesn't make sense or
> exist without nodes in it.  I doubt any of the dlm code would work if that
> weren't true.
> 
Thank you for the explanation.

I've prepared a new patch with just the changes you ack'ed. I'll send it 
in a minute.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

