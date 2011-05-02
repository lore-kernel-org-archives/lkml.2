Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1EBS0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:26:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:58835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1EBS0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,303,1301900400"; 
   d="scan'208";a="917035322"
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using
 cluster groups v4
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DBEB96A.8000309@openvz.org>
References: <20110502113445.751391656@openvz.org>
	 <20110502114024.222582172@openvz.org> <20110502132232.GA3873@elte.hu>
	 <4DBEB96A.8000309@openvz.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 02 May 2011 11:27:03 -0700
Message-Id: <1304360823.19493.27.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 07:02 -0700, Cyrill Gorcunov wrote:
> On 05/02/2011 05:22 PM, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> >> With this change, microbenchmark measuring the cost
> >> of flush_tlb_others(), with the flush tlb IPI being
> >> sent from a cpu in the socket-1 to all the logical
> >> cpus in socket-2 (on a Westmere-EX system that has
> >> 20 logical cpus in a socket) is 3x times better now
> >> (compared to the former 'send one-by-one' algorithm).
> > 
> > What kind of microbenchmark was this, could the actual results and measurement 
> > methods be shared as well?
> 
> Suresh, could you please post the microbenchmark?

It is a simple kernel hack to measure the TSC cost of flush_tlb_others()
with and with out this change. 3x better was specifically for the test
condition where we called flush_tlb_others() on a logical cpu in
socket-1, which sent the flush tlb IPI to all the logical cpu's in
another socket.

This is done on WSM-EX which has 20 logical cpu's on one socket. 20
logical cpu's in that socket will fall under two cluster groups. So 2
batches of grouped IPI's vs 20 serialized(atleast the sending part)
IPI's.

thanks,
suresh



