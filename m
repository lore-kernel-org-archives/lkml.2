Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1IKBhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:37:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47118 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1IKBhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:37:50 -0400
Date: Sun, 11 Sep 2011 10:37:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110911013742.GJ29319@htj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
 <20110905023315.GB9807@htj.dyndns.org>
 <20110905162012.GA4445@redhat.com>
 <20110906032846.GA18425@mtj.dyndns.org>
 <20110908180159.GA4197@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908180159.GA4197@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Thu, Sep 08, 2011 at 11:01:59AM -0700, Matt Helsley wrote:
> Looking at the code and docs I realize I didn't explicitly mention that
> kthreads could not be frozen by the cgroup freezer. However, the code did
> not allow it. When freezing tasks the cgroup freezer always did:
> 
> 	freeze_task(task, true)
> 
> which would only freeze tasks without PF_FREEZER_NOSIG due to the second
> "sig_only" parameter. I believe this means it could not be used to
> freeze kthreads.
> 
> My feeling is kthreads should not be "managed" directly by userspace.
> Especially if that includes the ability to arbitrarily stop or freeze them.
> So it seems more appropriate to explicitly disallow freezing of kthreads
> via the cgroup freezer.

Oh yeah, that's what we should do and maybe that's what the current
code intends to achieve too but currently it ends up triggering
BUG_ON().

Thanks.

-- 
tejun
