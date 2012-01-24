Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2AXQeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:34:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2AXQeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:34:36 -0500
Date: Tue, 24 Jan 2012 08:34:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 14/16] blkcg: don't allow or retain configuration of
 missing devices
Message-ID: <20120124163431.GA421@google.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
 <1327360193-24679-15-git-send-email-tj@kernel.org>
 <20120124154224.GA17291@redhat.com>
 <20120124155309.GA12906@google.com>
 <20120124163224.GB17291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124163224.GB17291@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:32:24AM -0500, Vivek Goyal wrote:
> > Yeap, there is.  Nice catch.  blkg_lookup_create() should be testing
> > blk_queue_bypass() instead of blk_queue_dead() and parse_and_set
> > should probably retry after a bit.  Will update.
> 
> So now group creation fails if queue is in bypass mode. So a per device
> rule setting will fail both for cfq and throttling logic while device
> is still around. So a user is supposed to retry? How would a user know 
> that elevator switch is happening and he should retry and till when should
> he retry.

Ummm... I'm working on the second patch which makes parse_and_set do
return restart_syscall().

-- 
tejun
