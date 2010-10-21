Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0JUG7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:59:39 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57656 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0JUG7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:59:38 -0400
Message-ID: <4CBFE4E2.7050001@kernel.dk>
Date: Thu, 21 Oct 2010 08:59:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
References: <E1P8kSE-0001DW-8C@tytso-glaptop>
In-Reply-To: <E1P8kSE-0001DW-8C@tytso-glaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-21 04:00, Theodore Ts'o wrote:
> Hey Jens,
> 
> I've been trying to figure out what I'm doing wrong.  I've been trying
> to convert the data writeback bath to use the bio layer.  It mostly
> works --- until all of sudden all calls to block_bio_queue(), either via
> submit_bh() or via submit_bio(), start turning into no-ops.
> 
> I'm sure I'm doing something wrong, but the bio layer isn't terribly
> well documented, so I'm not sure what it might be.  The patch which
> causes the problem can be found be found here:
> 
> http://userweb.kernel.org/~tytso/ext4-bio-patches/0006-Ext4-Use-bio-layer-instead-of-buffer-layer-in-mpage_.patch
> 
> Here is an except from an ftrace I've been taking to get to the bottom
> of it.  It's a combination of some trace_printk's, blktrace, and the
> block_bio_queue tracepoint.   The full log can be found at:
> 
> http://userweb.kernel.org/~tytso/ext4-bio-patches/kvm-console
> 
> It shows all of the blktrace events that shows up after block_bio_queue
> tracepoint, but at some point, after jbd2 or ext4 calls submit_bh() or
> submit_bio(), after the block_bio_queue tracepoint, we stop seeing the
> blktrace events, and it looks like the block I/O layer stops answering
> the phone.  No complaints in dmesg, no BUG_ON's, no errors....
> 
> If I back out the ext4 bio patches, things work correctly, and as I
> said, I'm pretty sure the bug is in my code.  But the failure is
> happening deep in the block I/O stack, and I can't figure out why it's
> failing.
> 
> I'm hoping this rings a bell, and perhaps we should consider some of the
> debugging trace_printk's as possible new tracepoints?
> 
> Any help you could give me would be greatly appreciated.  Ideally, you
> or someone can tell me what stupid thing I'm doing.  :-)

I don't see anything immediately wrong with your approach. I suspect
we'll need to see sysrq-t traces of the relevant processes to make a
more educated guess!

-- 
Jens Axboe

