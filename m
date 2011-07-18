Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1GRBVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 21:21:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46680 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1GRBVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 21:21:07 -0400
Date: Sun, 17 Jul 2011 21:21:05 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2 2/2] ext4: Ignore a stripe width of 1
Message-ID: <20110718012105.GI2717@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dan Ehrenberg <dehrenberg@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
References: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
 <1310766115-4164-2-git-send-email-dehrenberg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310766115-4164-2-git-send-email-dehrenberg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 02:41:55PM -0700, Dan Ehrenberg wrote:
> If the stripe width was set to 1, then this patch will ignore
> that stripe width and ext4 will act as if the stripe width
> were 0 with respect to optimizing allocations.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>

Applied to the ext4 tree.  I did make one formatting change.  Please
don't have blank lines between the if and else clauses, like this:

	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
		ret = sbi->s_stripe;

	else if (stripe_width <= sbi->s_blocks_per_group)
		ret = stripe_width;

	else if (stride <= sbi->s_blocks_per_group)
		ret = stride;

it wastes vertical whitespace and makes the control flow harder to
follow.  Eliminate the blank lines, and it's easier to read, I think.

	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
		ret = sbi->s_stripe;
	else if (stripe_width <= sbi->s_blocks_per_group)
		ret = stripe_width;
	else if (stride <= sbi->s_blocks_per_group)
		ret = stride;

						- Ted
