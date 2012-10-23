Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2JWKLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:11:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2JWKLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:11:50 -0400
Message-ID: <1350987096.2768.108.camel@twins>
Subject: Re: [PATCH 1/6] perf, x86: Basic Haswell LBR call stack support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, ak@linux.intel.com
Date: Tue, 23 Oct 2012 12:11:36 +0200
In-Reply-To: <50862E02.6020002@intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
	  <1350886279-6141-2-git-send-email-zheng.z.yan@intel.com>
	 <1350902138.2768.86.camel@twins> <50862E02.6020002@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 13:41 +0800, Yan, Zheng wrote:
> On 10/22/2012 06:35 PM, Peter Zijlstra wrote:
> > On Mon, 2012-10-22 at 14:11 +0800, Yan, Zheng wrote:
> >> --- a/include/uapi/linux/perf_event.h
> >> +++ b/include/uapi/linux/perf_event.h
> >> @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
> >>         PERF_SAMPLE_BRANCH_ABORT        = 1U << 7, /* transaction aborts */
> >>         PERF_SAMPLE_BRANCH_INTX         = 1U << 8, /* in transaction (flag) */
> >>         PERF_SAMPLE_BRANCH_NOTX         = 1U << 9, /* not in transaction (flag) */
> >> +       PERF_SAMPLE_BRANCH_CALL_STACK   = 1U << 10, /* call stack */
> >>  
> >> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 10, /* non-ABI */
> >> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 11, /* non-ABI */
> >>  }; 
> > 
> > You add an ABI sample type without mentioning it in your changelog.. I
> > think I'll stop reading here.
> > 
> Ok, I will add the ABI change to the change log. Do you think we should hide this
> branch sample type from user?

Possibly not, I haven't really thought about it. But never hide an ABI
change. Explicitly mention it and preferably explain why you felt it
needed to extend the ABI.
