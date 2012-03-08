Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab2CHAGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:06:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41838 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993Ab2CHAGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:06:38 -0500
Date: Wed, 7 Mar 2012 16:06:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120308000633.GH30676@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
 <20120305210836.GD1263@google.com>
 <20120306150709.GA32148@redhat.com>
 <20120306162455.GB32148@redhat.com>
 <20120306183942.GC32148@redhat.com>
 <20120306190211.GD32148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306190211.GD32148@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 06, 2012 at 02:02:11PM -0500, Vivek Goyal wrote:
> Ok, found it. Basically we have not initialized the q->queue_head during
> queue creation. Hence we end up thinking that q->queue_head is not empty.
> 
> So following fixed the issue for me. I still don't understand the special
> cased code (q->queue_head is not empty but don't kick queue).

It was mainly to avoid adding a new requirement as we didn't use to
require queue_head to be empty on exit.  I didn't realize we weren't
initializing queue_head from alloc.  Jens folded your fix into the
original patch, so we might not need the special case anymore.

I'll post fix for the RCU deref warning shortly.

Thanks.

-- 
tejun
