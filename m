Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab2IETtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:49:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56715 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab2IETtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:49:12 -0400
Date: Wed, 5 Sep 2012 12:49:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11 V5] workqueue: Add @bind arguement back without
 change any thing
Message-ID: <20120905194908.GC13737@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 05, 2012 at 06:37:42PM +0800, Lai Jiangshan wrote:
> Ensure the gcwq->flags is only accessed with gcwq->lock held.
> And make the code more easier to understand.
>
> In all current callsite of create_worker(), DISASSOCIATED can't
> be flipped while create_worker().
> So the whole behavior is unchanged with this patch.

This doesn't change anything.  You're just moving the test to the
caller with comments there explaining how it won't change even if
gcwq->lock is released.  It seems more confusing to me.  The flag is
still protected by manager_mutex.  How is this an improvement?

Thanks.

-- 
tejun
