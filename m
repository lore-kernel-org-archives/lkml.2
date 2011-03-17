Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1CQJNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:13:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:37624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1CQJNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:13:00 -0400
Subject: Re: [PATCH 2/2 v2] watchdog:  Always return NOTIFY_OK during cpu
 up/down events
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, jwjstone@fastmail.fm, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299533860-1642-2-git-send-email-dzickus@redhat.com>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
	 <1299533860-1642-2-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Mar 2011 10:12:49 +0100
Message-ID: <1300353169.2203.2767.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 16:37 -0500, Don Zickus wrote:
> 
> This patch addresses a couple of problems.  One was the case when the
> hardlockup failed to start, it also failed to start the softlockup.
> There were valid cases when the hardlockup shouldn't start and that
> shouldn't block the softlockup (no lapic, bios controls perf
> counters).
> 
> The second problem was when the hardlockup failed to start on boxes
> (from a no lapic or bios controlled perf counter case), it reported
> failure to the cpu notifier chain.  This blocked the notifier from
> continuing to start other more critical pieces of cpu bring-up (in
> our case based on a 2.6.32 fork, it was the mce).  As a result,
> during soft cpu online/offline testing, the system would panic
> when a cpu was offlined because the cpu notifier would succeed in
> processing a watchdog disable cpu event and would panic in the mce
> case as a result of un-initialized variables from a never executed
> cpu up event.
> 
> I realized the hardlockup/softlockup cases are really just debugging
> aids and should never impede the progress of a cpu up/down event.
> Therefore I modified the code to always return NOTIFY_OK and instead
> rely on printks to inform the user of problems.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
