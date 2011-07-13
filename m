Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1GMNbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:31:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1GMNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:31:43 -0400
Date: Wed, 13 Jul 2011 15:31:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
Message-ID: <20110713133139.GO2872@htj.dyndns.org>
References: <4E1D6900.6040500@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1D6900.6040500@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rusty Russell)
Hello,

On Wed, Jul 13, 2011 at 10:44:32AM +0100, Jonathan Cameron wrote:
> The other thing this highlights is that I suspect quite a few are protected by
> spin locks when a mutex would be fine. Hence that might be worth tidying up first.
> 
> Anyhow, a cleanup worth making? (obviously the exact form needs some work, but
> I think the following is enough to start a discussion!)
> 
> Subject: [PATCH] ida utility function

Rusty suggested similar addition some weeks ago, so people are really
getting annoyed by this.

  http://thread.gmane.org/gmane.linux.kernel/1148513/focus=74236

Here's an interface that I think should work,

	int ida_get(struct ida *ida, int begin, int end, gfp_t gfp);

It uses an internal spinlock, returns the allocated ID and @end <= 0
indicates no limit.

Thanks.

-- 
tejun
