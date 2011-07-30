Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1G3Mqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 08:46:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54410 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1G3Mqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 08:46:49 -0400
Date: Sat, 30 Jul 2011 14:46:44 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Osterlund <peterosterlund2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: Can you please take a look at bug39852?
Message-ID: <20110730124644.GM2622@htj.dyndns.org>
References: <20110730112946.GL2622@htj.dyndns.org>
 <alpine.LFD.2.00.1107301431580.13015@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1107301431580.13015@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens and LKML)

On Sat, Jul 30, 2011 at 02:38:26PM +0200, Peter Osterlund wrote:
> On Sat, 30 Jul 2011, Tejun Heo wrote:
> 
> >It looks like spurious lockdep warning via pkt_open().  Seems like the
> >problem has been there since the beginning.  What do you think?
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=39852
> 
> Yes, it is a spurious warning that has been there since the
> beginning. There were patches to silence the warning back in 2006
> 
> 	https://lkml.org/lkml/2006/7/25/41
> 
> but they were considered not the right approach. I don't know what
> the right approach is.

I see.  I think the proper solution would be adding a variant of
blkdev_get(), say blkdev_get_nested(), to give the inner open a
different locking class.  Jens, what do you think?

Thanks.

-- 
tejun
