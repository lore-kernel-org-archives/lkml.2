Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1F2WRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 18:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1F2WRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 18:17:41 -0400
Date: Wed, 29 Jun 2011 18:17:31 -0400
From: David Teigland <teigland@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: Re: [PATCH] fs, dlm: Don't leak, don't do pointless NULL checks and
 use kzalloc
Message-ID: <20110629221731.GB11350@redhat.com>
References: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net>
 <20110629214056.GA11350@redhat.com>
 <alpine.LNX.2.00.1106292344110.3747@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106292344110.3747@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:51:00PM +0200, Jesper Juhl wrote:
> > I don't think so; num_nodes won't be set to zero.
> 
> Hmm. How so?  Maybe I'm missing something obvious, but;
> num_nodes is initialized to zero at the beginning of the function, which 
> means that we'll definately do the first allocation in the loop.

Zero is meant to mean "first time through the loop".

> We then set num_nodes equal to ls->ls_num_nodes - what guarantees that 
> this will not be zero so we won't do a second allocation (and leak) the 
> second time through the loop?

That's just the nature of a lockspace, I guess -- it doesn't make sense or
exist without nodes in it.  I doubt any of the dlm code would work if that
weren't true.

Dave
