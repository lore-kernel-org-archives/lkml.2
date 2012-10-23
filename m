Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2JWNP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:15:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:42203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2JWNPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:15:55 -0400
Message-ID: <1350998110.13456.26.camel@twins>
Subject: Re: [PATCH 16/34] perf, x86: Support weight samples for PEBS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 15:15:10 +0200
In-Reply-To: <1350602382-12771-17-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-17-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When a weighted sample is requested, first try to report the TSX abort cost
> on Haswell. If that is not available report the memory latency. This
> allows profiling both by abort cost and by memory latencies.
> 
> Memory latencies requires enabling a different PEBS mode (LL).
> When both address and weight is requested address wins.
> 
> The LL mode only works for memory related PEBS events, so add a
> separate event constraint table for those.
> 
> I only did this for Haswell for now, but it could be added
> for several other Intel CPUs too by just adding the right
> table for them.

This looks like it will interfere with Stephane's LL patches -- which
should be out any day now ;-)

Stephane, any comments on how we should deal with all that?
