Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2IXUkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:40:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab2IXUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:39:59 -0400
Date: Mon, 24 Sep 2012 13:39:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and
 start all flusher at the same time
Message-ID: <20120924203954.GD29689@google.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Mon, Sep 24, 2012 at 06:07:02PM +0800, Lai Jiangshan wrote:
> The core patch is patch6, it makes all flusher can start and the same time
> and allow us do more cleanup.
> 
> Only patch1 and patch6 change the behavior of the code.
> All other patches do not change any behavior.

It would have been nice if you described what this patchset tries to
achieve how in the head message.

I don't see anything wrong with the patchset but flush_workqueue() is
quite hairy before this patchset and I'm not sure the situation
improves a lot afterwards.  The current code is known / verified to
work for quite some time and I'd *much* prefer to keep it stable
unless it can be vastly simpler.

I do like the removal of explicit cascading and would have gone that
direction if this code is just being implemented but I'm quite
skeptical whether changing over to that now is justifiable.  Flush
bugs tend to be nasty and often difficult to track down.

I'll think more about it.  How confident are you about the change?
How did you test them?  For changes like this, it usually helps a lot
to describe how things were tested as part of head and/or commit
messages.

Thanks.

-- 
tejun
