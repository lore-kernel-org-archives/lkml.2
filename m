Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1DENbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:31:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1DEN2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:19 -0400
Subject: Re: [patch 10/15] sched: (fixlet) dont update shares twice on
 on_rq parent
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110323030449.628616053@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.628616053@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:11 +0200
Message-ID: <1302010091.2225.1315.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
> with additional weight.  However, we perform a double shares update on this
> entity since we continue the shares update traversal from that point, despite
> dequeue_entity() having already updated its queuing cfs_rq.
> 
> Avoid this by starting from the parent when we resume. 

I'm thinking this fixlet is orthogonal to the rest of this patch-set and
should go in now? (Usually such things live at the head of a series)
