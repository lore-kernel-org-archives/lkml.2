Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2JISiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab2JISiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:38:01 -0400
Date: Tue, 9 Oct 2012 11:37:53 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121009183753.GP26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349764760-21093-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:39:20PM -0700, Kent Overstreet wrote:
> Bunch of cleanup

Ugh.  That's way too much noisy change for one patch with no
description.  Break it up into functional pieces and actually describe
them.

> events off the ringbuffer without racing with io_getevents().

Are you sure this is safe in the presence of wrapping indices?  It's
been a very long time since I've looked at this, but I could never
convince myself that it was safe.

What I'm worried about is cmpxchg()s caller sampling, say, and index of
0, having another task GO NUTS and wrap that index all the way around
back to 0, and then having that initial cmpchg() caller see the wrapped
0 index and think that's nothing's changed in the interim.

Is this a problem?

(I wish I could find the comment I wrote in a very old patch to tear out
the mapped ring entirely.. It was a great list of its design mistakes.)

- z
