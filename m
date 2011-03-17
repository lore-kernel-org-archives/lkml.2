Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1CQMRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:17:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:34720 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab1CQMRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:17:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 2/2 v2] watchdog:  Always return NOTIFY_OK during cpu
 up/down events
Date: Thu, 17 Mar 2011 12:16:55 +0000 (UTC)
Message-ID: <ilsu3n$vm1$3@dough.gmane.org>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
	<1299533860-1642-2-git-send-email-dzickus@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.227.147.194
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 16:37:40 -0500, Don Zickus wrote:

> This patch addresses a couple of problems.  One was the case when the
> hardlockup failed to start, it also failed to start the softlockup.
> There were valid cases when the hardlockup shouldn't start and that
> shouldn't block the softlockup (no lapic, bios controls perf counters).
> 
> The second problem was when the hardlockup failed to start on boxes
> (from a no lapic or bios controlled perf counter case), it reported
> failure to the cpu notifier chain.  This blocked the notifier from
> continuing to start other more critical pieces of cpu bring-up (in our
> case based on a 2.6.32 fork, it was the mce).  As a result, during soft
> cpu online/offline testing, the system would panic when a cpu was
> offlined because the cpu notifier would succeed in processing a watchdog
> disable cpu event and would panic in the mce case as a result of
> un-initialized variables from a never executed cpu up event.

What I saw is microcode, its /sys entries failed to come up and this
triggers a warning when these entries are removed when the CPU became 
offline again.

> 
> I realized the hardlockup/softlockup cases are really just debugging
> aids and should never impede the progress of a cpu up/down event.
> Therefore I modified the code to always return NOTIFY_OK and instead
> rely on printks to inform the user of problems.
> 

Yeah, it should also fix the problem I saw.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

