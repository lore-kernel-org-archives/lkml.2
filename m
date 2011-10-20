Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1JTVaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:30:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60046 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1JTVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:30:03 -0400
Date: Thu, 20 Oct 2011 14:29:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing
 blkcg->policy_list
Message-ID: <20111020212958.GA25124@google.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
 <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
 <20111020211140.GY25124@google.com>
 <20111020212021.GA2841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020212021.GA2841@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 05:20:21PM -0400, Vivek Goyal wrote:
> The only problem with this approach is that it will cleanup per device
> weight rules also at elevator_exit() time which is not same as device
> removal and one might device to bring CFQ back on device and we will
> need the rules again.

I actually think removoing those rules on elevator detach would be the
right thing to do.  We don't try to keep cfq setting across elevator
switch.  When we're switching from cfq, we're detaching iocg policy
too.  The settings going away is perfectly fine.  I actually think
it's a pretty bad idea to implement ad-hoc setting persistence in
kernel.  Just making sure that userland is notified is far better
approach.  Userland has all the facilities to deal with this type of
situations.

When switching from cfq to deadline, we lose the whole proportional io
control.  It's way more confusing to have lingering settings which
don't do anything.

Thanks.

-- 
tejun
