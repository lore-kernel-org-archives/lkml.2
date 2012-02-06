Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2BFTXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:23:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42538 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2BFTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:23:50 -0500
Subject: Re: [PATCH v5 09/18] perf: disable PERF_SAMPLE_BRANCH_* when not
 supported
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
In-Reply-To: <1328187288-24395-10-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
	 <1328187288-24395-10-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 20:23:30 +0100
Message-ID: <1328556210.2482.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 13:54 +0100, Stephane Eranian wrote:
> @@ -539,6 +539,10 @@ static int armpmu_event_init(struct perf_event *event)
>         int err = 0;
>         atomic_t *active_events = &armpmu->active_events;
>  
> +       /* does not support taken branch sampling */
> +       if (has_branch_smpl(event))
> +               return -EOPNOTSUPP;
> +
>         if (armpmu->map_event(event) == -ENOENT) 

I'll make that has_branch_stack(), ok? :-)

