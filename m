Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1J0RLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 13:11:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1J0RLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 13:11:23 -0400
Date: Thu, 27 Oct 2011 10:11:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 10/13] block, cfq: unlink cfq_io_context's
 immediately
Message-ID: <20111027171117.GD29899@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026213107.GI24261@google.com>
 <20111027143119.GD7491@redhat.com>
 <20111027161701.GB29899@google.com>
 <20111027170524.GH7491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027170524.GH7491@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:05:24PM -0400, Vivek Goyal wrote:
> I can't seem to find the dummy definition in include/linux/lockdep.h for
> !CONFIG_LOCKDEP.
> 
> I see only following under CONFIG_LOCKDEP.
> 
> #define lockdep_is_held(lock)   lock_is_held(&(lock)->dep_map)
> 
> and nothing under #else clause.

Hmmm... commit f607c6685774811b8112e124f10a053d77015485 added
lockdep_assert_held() and the dummy one as added together.  Of course
lockdep_is_held() isn't defined if !CONFIG_LOCKDEP - the truth value
cannot be determined without lockdep and thus dummy one cannot be
defined, but dummy lockdep_assert_held() can be defined and is, and
that's what what should be used.

Thanks.

-- 
tejun
