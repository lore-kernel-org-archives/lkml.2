Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1DEN2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1DEN2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:20 -0400
Subject: Re: [patch 11/15] sched: hierarchical task accounting for
 SCHED_OTHER
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110323030449.732563642@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.732563642@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:10 +0200
Message-ID: <1302010090.2225.1314.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> With task entities participating in throttled sub-trees it is possible for
> task activation/de-activation to not lead to root visible changes to
> rq->nr_running.  This in turn leads to incorrect idle and weight-per-task load
> balance decisions.
> 
> To allow correct accounting we move responsibility for updating rq->nr_running
> to the respective sched::classes.  In the fair-group case this update is
> hierarchical, tracking the number of active tasks rooted at each group entity.
> 
> This also allows us to fix a small buglet in pick_next_task() when group
> scheduling is enabled.
> 
> Note: technically this issue also exists with the existing sched_rt
> throttling; however due to the nearly complete provisioning of system
> resources for rt scheduling this is much less common by default.

Shouldn't this patch live at the start of the series?


