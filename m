Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2BPQCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:02:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:60925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPQCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:02:30 -0500
Message-ID: <1329408142.2293.241.camel@twins>
Subject: Re: [RFC PATCH 05/14] sched: account for blocked load waking back up
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 17:02:22 +0100
In-Reply-To: <20120202013826.20844.47587.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013826.20844.47587.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:

>         u64 last_runnable_update, decay_count;

> +       /* we track migrations using entity decay_count == 0 */
> +       if (unlikely(se->avg.decay_count <= 0)) { 

!sleep dequeue isn't migrate only, also, <= 0 on an unsigned is weird.


