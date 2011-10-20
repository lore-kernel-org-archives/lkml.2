Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1JTVLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:11:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1JTVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:11:45 -0400
Date: Thu, 20 Oct 2011 14:11:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing
 blkcg->policy_list
Message-ID: <20111020211140.GY25124@google.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
 <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 05:08:26PM -0400, Vivek Goyal wrote:
> blkcg->policy_list is protected by blkcg->lock. Its not rcu protected
> list. So even for readers, they need to take blkcg->lock. There are
> few functions which were reading the list without taking lock. Fix it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

 Acked-by: Tejun Heo <tj@kernel.org>

And yeap, some of rcu usages in cfq/iocg seem either incorrect or
unnecessary.  Trying to clean up that now too.

Thank you.

-- 
tejun
