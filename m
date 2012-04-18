Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2DRVnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:43:02 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36068 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2DRVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:43:00 -0400
Date: Wed, 18 Apr 2012 14:42:55 -0700
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120418214255.GA4772@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
 <20120413204710.GF12233@google.com>
 <20120413205501.GL26383@redhat.com>
 <20120413210548.GG12233@google.com>
 <20120413211640.GH12233@google.com>
 <1334664298.3766.62.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334664298.3766.62.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:04:58PM +0400, James Bottomley wrote:
> > So, the current code is technically correct although subtle like hell.
> > We can RCU defer blk_put_queue() from blk_cleanup_queue() using
> > call_rcu() to make clear that RCU grace period is necessary there.
> > Any better ideas?
> 
> Not really ... except that perhaps we might redo LUN scanning to use
> just a single queue, so repurpose the LUN underneath, but not destroy
> the old queue and setup the new one?  It's a bit counter intuitive, but
> it shouldn't be impossible.

I think we're fine as-is with comment explaining that there can't be
any active dereferencing going on by the time release is reached.

Thanks.

-- 
tejun
