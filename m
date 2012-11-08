Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2KHV7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:59:51 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60048 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab2KHV7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:59:49 -0500
Date: Thu, 8 Nov 2012 06:47:08 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/random.c: variable type mismatch
Message-ID: <20121108114708.GB5859@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <509AFDA6.7070005@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509AFDA6.7070005@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 01:32:38AM +0100, Stephan Mueller wrote:
> 
> However, due to the fact that jiffies provides very few entropy, the
> event value provides (almost) none, the majority of entropy comes from
> the processor cycles. Assuming that the processor cycles increase once
> per nanosecond, after 2**32 cycles (about 4 seconds), the counter wraps.

Sure, we can make this change, but it doesn't make as much difference
as you think.  The high 32 bits gets incremented about ounce every 4
seconds, while jiffies gets incremented once every 1/HZ seconds.  But
the point is they are pretty well correlated (i.e., if you know the
jiffies values A' and A'', and I know the high 32 bits of the cycles
B', and you can determine the likely value of B'' to a very high
degree of accuracy.  Values which are correlated don't actually
entropy.

							- Ted
