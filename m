Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1GUHih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:38:37 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42418 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1GUHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:38:33 -0400
Date: Thu, 21 Jul 2011 09:38:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: purpose of WARN_ON in kernel/workqueue.c:worker_enter_idle()
Message-ID: <20110721073828.GY3455@htj.dyndns.org>
References: <20110718161518.GA8128@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718161518.GA8128@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Olaf.

On Mon, Jul 18, 2011 at 06:15:18PM +0200, Olaf Hering wrote:
> whats the purpose of "WARNING: at kernel/workqueue.c:1217 worker_enter_idle()"?
> I put some debug in the function, cpu is always 1, nr_workers is either
> 2 or 3, current_work is NULL.
> Is there some real bug lurking thats worth to track down?

Oh yeah, that means workqueue worker accounting went out of sync which
may lead to workqueue hang which usually means dead system.  Can you
please print out what goes out of sync?  ie. print gcwq->nr_workers,
nr_idle and get_gcwq_nr_running(gcwq->cpu)?

Also, it would be helpful to enable and record workqueue events (grep
workqueue /sys/kernel/debug/tracing/available_events).  It should
allow us what led to the condition.

Thanks.

-- 
tejun
