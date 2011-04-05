Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1DEN2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:54512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1DEN2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:23 -0400
Subject: Re: [patch 08/15] sched: migrate throttled tasks on HOTPLUG
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110323030449.434436052@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.434436052@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:12 +0200
Message-ID: <1302010092.2225.1317.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> Throttled tasks are invisisble to cpu-offline since they are not eligible for
> selection by pick_next_task().  The regular 'escape' path for a thread that is
> blocked at offline is via ttwu->select_task_rq, however this will not handle a
> throttled group since there are no individual thread wakeups on an unthrottle.
> 
> Resolve this by unthrottling offline cpus so that threads can be migrated.

Fair enough, the flip side is that they all can again increase their
debt by a whole tick, right?
