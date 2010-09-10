Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0IJN0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0IJN0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:26:08 -0400
Date: Fri, 10 Sep 2010 09:25:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf_events: fix BTS interrupt handling to avoid being
 dazed by NMI (v2)
Message-ID: <20100910132528.GA4879@redhat.com>
References: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c8a1686.aae9d80a.5aa4.5e35@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:28:01PM +0200, Stephane Eranian wrote:
> Fix a bug introduced with commit de725de and the change in the meaning of the
> return value of intel_pmu_handle_irq(). With the current code, when you are
> using the BTS, you get 'dazed by NMI' each time the BTS buffer fills up.
> 
> BTS does interrupt on the PMU vector, thus NMI. You need to take this
> into account in the return value of the function.
> 
> This version fixes initial patch which was missing changes to
> perf_event_intel_ds.c.

Great work!

So does this mean my other patch that ack'd the intel pmu earlier than
before is unnecessary now?  Or was this patch solving a different problem?

Cheers,
Don
