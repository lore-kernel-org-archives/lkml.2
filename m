Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2EVLLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab2EVLLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:11:14 -0400
Date: Tue, 22 May 2012 07:11:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] block/throttle: Add IO throttled information in blkcg.
Message-ID: <20120522111111.GE3045@redhat.com>
References: <1337674236-2896-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337674236-2896-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 04:10:36PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, if the IO is throttled by io-throttle, the SA has no idea of
> the situation and can't report it to the real application user about
> that he/she has to do something. So this patch adds a new interface
> named blkio.throttle.io_throttled which indicates how many IOs are
> currently throttled.

If the only purpose is to know whether IOs are being throttled, why
not just scan for the rules and see if respective device has any
throttling rules or not.

Even if you introduce this interface, you will end up scanning for
throttled ios against that particular device. And if IO is not happening
at that moment or if IO rate is not exceeding the rate limit, there
might not be any throttled ios and one might get misled.

So for your purpose a better interface sounds like scanning for throttling
rules instead of this new interface.

> 
> I am not sure whether it is OK to add this information to the generic
> blkcg since it is only io-throttle related, but I don't find a way to
> only store it into the blkcg io-throttle. And that's the reason this
> is only a RFC. Any suggestions? Thanks.

Tejun has changed the code in this area and new code will allow you to
introduce this file in blk-throttle.c. All that code is sitting in Jens's
block tree.

Thanks
Vivek
