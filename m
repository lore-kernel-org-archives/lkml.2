Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0FNOh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:37:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52702 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0FNOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:37:26 -0400
Date: Mon, 14 Jun 2010 16:37:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100614143720.GI17092@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111052.3DDC5B1A2B@basil.firstfloor.org> <20100614042700.GC6590@dastard> <20100614074309.GA17092@basil.fritz.box> <20100614133755.GE6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614133755.GE6590@dastard>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > function head comment during development.  Anyway, if we do get an
> > > error here, we cannot handle it anyway - it's too late to do
> > > anything short of a complete shutdown as we've already written the
> > > transaction to the log.
> > 
> > Well I guess it should be unconditional BUG_ON then.
> 
> Don't be silly. A filesystem shutdown is all that is necessary,

Without BUG_ON it will not end up in kerneloops.org and you will
never know about it.  That's standard Linux kernel development
practice.

Maybe XFS should catch up on that.

Ok in principle you could make the shutdown a WARN()

Anyways I'm out of this.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
