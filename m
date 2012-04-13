Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2DMR2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:28:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2DMR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:28:47 -0400
Date: Fri, 13 Apr 2012 10:28:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 5/8] blkcg: make sure blkg_lookup() returns %NULL if @q
 is bypassing
Message-ID: <20120413172841.GC12233@google.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-6-git-send-email-tj@kernel.org>
 <20120413160053.GE26383@redhat.com>
 <20120413170334.GB12233@google.com>
 <20120413172336.GF26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413172336.GF26383@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:23:36PM -0400, Vivek Goyal wrote:
> I think now synchronize_rcu() has become part of cfq_init_queue()
> effectively and that will slow down boot. In the past I had to remove
> it.

Eh... crap.  You're right.  Forgot about that.  Maybe we need to
special case initial queue setup.  I'll look into it.

Thanks.

-- 
tejun
