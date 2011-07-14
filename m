Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1GNQtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:49:25 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:23942 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1GNQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:49:24 -0400
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ
 affinity notifiers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110617094547.GF2611@htj.dyndns.org>
References: <20110615142917.GY8141@htj.dyndns.org>
	 <1308266886.2925.27.camel@bwh-desktop>
	 <20110617094547.GF2611@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 14 Jul 2011 17:49:20 +0100
Message-ID: <1310662160.3098.1.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2011 16:49:24.0314 (UTC) FILETIME=[FC7D2BA0:01CC4245]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18260.000
X-TM-AS-Result: No--29.062300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 11:45 +0200, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jun 17, 2011 at 12:28:06AM +0100, Ben Hutchings wrote:
> > This facility is enabled on all configurations with NET && SMP &&
> > GENERIC_HARDIRQS, but at the moment is only useful for some net drivers
> > (currently only one).  So I don't think it should be creating a task at
> > boot time.  Does alloc_workqueue() still create any tasks immediately?
> 
> Nope, no need to worry about it.  The only added overhead is the
> memory occupied by workqueue itself (which includes small percpu area
> but one systemwide one isn't gonna hurt anyone and we've been
> decreasing the number of workqueues significantly).  It just serves as
> a flush domain.

Sorry I didn't reply to this earlier.

Given what you've said, I see no problem with this change.  So you can
add:

Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

