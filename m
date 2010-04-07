Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0DGOFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:05:40 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:46290 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757940Ab0DGOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:05:38 -0400
Date: Thu, 8 Apr 2010 00:05:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Berthels <john@humyo.com>
Cc: linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>,
       Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks,
 heavy write load, 8k stack, x86-64
Message-ID: <20100407140523.GJ11036@dastard>
References: <4BBC6719.7080304@humyo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBC6719.7080304@humyo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 12:06:01PM +0100, John Berthels wrote:
> Hi folks,
> 
> [I'm afraid that I'm not subscribed to the list, please cc: me on
> any reply].
> 
> Problem: kernel.org 2.6.33.2 x86_64 kernel locks up under
> write-heavy I/O load. It is "fixed" by changing THREAD_ORDER to 2.
> 
> Is this an OK long-term solution/should this be needed? As far as I
> can see from searching, there is an expectation that xfs would
> generally work with 8k stacks (THREAD_ORDER 1). We don't have xfs
> stacked over LVM or anything else.

I'm not seeing stacks deeper than about 5.6k on XFS under heavy write
loads. That's nowhere near blowing an 8k stack, so there must be
something special about what you are doing. Can you post the stack
traces that are being generated for the deepest stack generated -
/sys/kernel/debug/tracing/stack_trace should contain it.

> Background: We have a cluster of systems with roughly the following
> specs (2GB RAM, 24 (twenty-four) 1TB+ disks, Intel Core2 Duo @
> 2.2GHz).
> 
> Following a the addition of three new servers to the cluster, we
> started seeing a high incidence of intermittent lockups (up to
> several times per day for some servers) across both the old and new
> servers. Prior to that, we saw this problem only rarely (perhaps
> once per 3 months).

What is generating the write load?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
