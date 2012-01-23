Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2AWPjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:39:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40279 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AWPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:39:18 -0500
Date: Mon, 23 Jan 2012 07:39:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123153913.GB12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123152055.GD25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 23, 2012 at 10:20:55AM -0500, Vivek Goyal wrote:
> What happens to per device rules (per device weight and per device
> throttling rules)? IIUC, in new scheme of things, upon elevator switch
> these rules will be gone.
> 
> I can understand per device weight rules disappearing but what about 
> throttling rules. They are independent of IO scheduler and change of
> io scheduler should not cause per device throttling rules to get lost.
> 
> This just gets worse if elevator switch fails and we fall back to old
> elevator. But now we have lost of the rules as rules were part of
> blkg.conf and old groups are gone.

As any other choices, it's about trade off and there multiple aspects
to consider.  Both elevator and policy changes are extremely low
frequency and inherently disruptive operations and having persistency
across them doesn't justify adding the amount of complexity and design
convolutions we have now, especially not when rule persistency across
those switches can be implemented with mostly trivial switching script
from userland.

Thanks.

-- 
tejun
