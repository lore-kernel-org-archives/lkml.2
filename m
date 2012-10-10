Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2JJBJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:09:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48148 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2JJBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:09:37 -0400
Date: Tue, 9 Oct 2012 18:09:03 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121010010903.GC24174@moria.home.lan>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
 <20121009225836.GU26187@lenny.home.zabbo.net>
 <20121010001630.GC26835@google.com>
 <20121010003626.GY26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010003626.GY26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:36:26PM -0700, Zach Brown wrote:
> > The only situation you have to worry about is when the ringbuffer fills
> > up and stuff goes on the list, and then completions completely stop -
> > this should be a rare enough situation that maybe we could just hack
> > around it with a timer that gets flipped on when the list isn't empty.
> 
> Right.  And this is when we hopefully realize that we're adding overhead
> and complexity (how long's the timer?  always fire it?  MAKE IT STOP)
> and are actually making the system worse, not better.

Can still prototype it, and if it's that ugly... I throw away code all
the time :P

> > Also, for this to be an issue at all, _all_ the reaping would have to be
> > done from userspace - since existing libaio doesn't do that, there may
> > not be any code out there which triggers it.
> 
> And there may be.  We default to not breaking interfaces.  Seriously.

All the more reason to think about it now so we don't screw up the next
interfaces :)
