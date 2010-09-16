Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0IPIMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:12:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:32974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0IPIL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:11:59 -0400
Message-ID: <4C91D132.6090607@kernel.org>
Date: Thu, 16 Sep 2010 10:11:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM / Runtime: Use alloc_workqueue() for creating
 PM workqueue
References: <201009152156.30749.rjw@sisk.pl>
In-Reply-To: <201009152156.30749.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 08:11:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On 09/15/2010 09:56 PM, Rafael J. Wysocki wrote:
> I'm not sure about that WQ_RESCUER thing.  Can you please tell me what
> exactly it is for?

It's to guarantee forward progress for workqueues which process work
items which may be used to reclaim memory.  It reserves a rescue
worker thread to be used under memory pressure.  I finished workqueue
documentation a few days ago and sent pull request to Linus.

  http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=blob;f=Documentation/workqueue.txt;h=e4498a2872c37a0b3b156ddc7ad7135d030d224d;hb=c54fce6eff197d9c57c97afbf6c9722ce434fc8f

So, for pm_wq, there's no reason to use WQ_RESUER.
alloc_workqueue("pm", WQ_FREEZEABLE, 0) should do it.

Thanks for doing it.

-- 
tejun
