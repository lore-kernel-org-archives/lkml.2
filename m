Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0HWUXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:23:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab0HWUXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:23:32 -0400
Date: Mon, 23 Aug 2010 13:23:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Message-Id: <20100823132315.6906ddbe.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1008231303410.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
	<20100823130109.6da43a58.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231303410.17716@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 13:08:53 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 23 Aug 2010, Andrew Morton wrote:
> 
> > Hows about you add a helper function
> > 
> > 	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> > 
> > then convert the callsites to use that, then nuke __GFP_NOFAIL?
> > 
> 
> That would only serve as documentation

Is that bad?

> of a caller that could potentially 
> loop forever waiting for memory (which I did by adding "/* FIXME: this may 
> potentially loop forever */")

A helper function could check that appropriate gfp flags are being set.

> since all of the allocations in this 
> patchset never loop in the code that was added, they already loop forever 
> in the page allocator doing the same thing.  The hope is that kswapd will 
> eventually be able to free memory since direct reclaim will usually fail 
> for GFP_NOFS and we simply need to wait long enough for there to be 
> memory.

While holding locks which will prevent kswapd from doing anything useful.

