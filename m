Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2JJAgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:36:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab2JJAgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:36:35 -0400
Date: Tue, 9 Oct 2012 17:36:26 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121010003626.GY26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
 <20121009225836.GU26187@lenny.home.zabbo.net>
 <20121010001630.GC26835@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010001630.GC26835@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only situation you have to worry about is when the ringbuffer fills
> up and stuff goes on the list, and then completions completely stop -
> this should be a rare enough situation that maybe we could just hack
> around it with a timer that gets flipped on when the list isn't empty.

Right.  And this is when we hopefully realize that we're adding overhead
and complexity (how long's the timer?  always fire it?  MAKE IT STOP)
and are actually making the system worse, not better.

> Also, for this to be an issue at all, _all_ the reaping would have to be
> done from userspace - since existing libaio doesn't do that, there may
> not be any code out there which triggers it.

And there may be.  We default to not breaking interfaces.  Seriously.

- z
