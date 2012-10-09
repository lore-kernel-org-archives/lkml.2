Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2JISaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2JIS35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:29:57 -0400
Date: Tue, 9 Oct 2012 11:29:49 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121009182949.GO26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349764760-21093-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:39:19PM -0700, Kent Overstreet wrote:
> It simplifies a lot of stuff if the ringbuffer is contiguously mapped
> into kernel space, and we can delete a lot of code - in particular, this
> is useful for converting read_events() to cmpxchg.

1) I'm concerned that Our Favourite Database Benchmarkers will see an
effect of having more TLB pressure from that mapping.  kmap_atomic()
should be cheaper.  We'll need to measure the difference.

2) I'm not at all convinced that the current ring semantics are safe
with cmpxchg(), more in the next patch.

- z
