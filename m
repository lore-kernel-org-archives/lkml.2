Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab0HJOcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:32:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38996 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab0HJOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:32:43 -0400
Date: Tue, 10 Aug 2010 16:32:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>, David Miller <davem@davemloft.net>,
        willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810143241.GB15073@merkur.ravnborg.org>
References: <20100809.235746.115919762.davem@davemloft.net> <4C6147DE.9050608@tilera.com> <20100810124445.GA14843@merkur.ravnborg.org> <20100810134600.GF18824@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810134600.GF18824@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 10:46:00AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Aug 10, 2010 at 02:44:45PM +0200, Sam Ravnborg escreveu:
> > IMO the patch that moves list_head to types.h is fine.
> > And perf needs to learn good manner with respect to
> > kernel headers.
> 
> Idea is to try to have the perf tools, since they are hosted in the
> kernel and developed mostly by people with kernel background, to use
> code and practices used in the kernel proper.
> 
> It started just keeping private copies, I guess it should get back to
> that since the reaction to this kind of same source repo code sharing
> was, well, not good :-)
> 
> Alternatives?

I have not analyzed deeper in what parts perf uses so the
following may not fly at all.

One solution could be to let perf rely on a set of
exported userspace headers from the kernel.

And on top of this copy a small set of kernel internal
headers for use by perf only.
The copying will be a good way to document what is actually
used of the kernel internal stuff.

But I also realize that just copying over list.h does
not suffice. It pulls in lots of other stuff.
So this is most likely hard to do.

I guess first step is to identify what is really used
beside the exported stuff and start to conclude from there.

	Sam
