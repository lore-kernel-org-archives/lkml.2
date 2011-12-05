Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1LEWPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:15:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab1LEWPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:15:10 -0500
Message-ID: <1323123260.32012.44.camel@twins>
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 23:14:20 +0100
In-Reply-To: <1318595833-29984-2-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> +#define PERF_SAMPLE_BRANCH_PLM_ALL \
> +       (PERF_SAMPLE_BRANCH_USER|\
> +        PERF_SAMPLE_BRANCH_KERNEL) 

This PLM thing keeps popping up all over, I'm sure it stands for
something, but for now it just hurts my eyes.


> +               /* at least one branch bit must be set */
> +               if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
> +                       return -EINVAL;
> 
Why? we can create counters with exclude_user && exclude_kernel as well,
I mean, they're useless, but its perfectly valid.
