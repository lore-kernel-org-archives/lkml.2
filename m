Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2BPP6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:58:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37520 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2BPP6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:58:13 -0500
Message-ID: <1329407875.2293.239.camel@twins>
Subject: Re: [RFC PATCH 05/14] sched: account for blocked load waking back up
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 16:57:55 +0100
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
> +               if (se->avg.decay_count) {
> +                       /*
> +                        * In a wake-up migration we have to approximate the
> +                        * time sleeping.
> +                        */
> +                       se->avg.last_runnable_update -= (-se->avg.decay_count)
> +                                                       << 20;
> +                       update_entity_load_avg(se, 0);
> +               } 

That comment wants more why and how. I think I remember pjt telling me
about this last week, but those are already vague memories, I'll be sure
to be completely clueless in another week.
