Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1LIQ5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:57:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52339 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1LIQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:57:09 -0500
Date: Fri, 9 Dec 2011 08:57:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue_set_max_active(wq, 0)?
Message-ID: <20111209165702.GD12108@google.com>
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Johannes. :)

On Fri, Dec 09, 2011 at 10:54:42AM +0100, Johannes Berg wrote:
> And then I found workqueue_set_max_active() but passing 0 isn't allowed.
> 
> Before I dive in more deeply I figured I'd ask if you think what a good
> way of doing this would be (and whether I'm completely insane) :-)

Hmmm... yeah, actually, that's what wq uses internally to implement
freezable workqueues.  It sets max_active to 0 temporarily and waits
for all in-flight works to finish.  On thaw, the original value is
restored.

Updating workqueue_set_max_active() to return the old value would be a
nice API update which goes together, I think.

Thanks.

-- 
tejun
