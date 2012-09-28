Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2I1JeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:34:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:57371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2I1JeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:34:03 -0400
Message-ID: <1348824831.3292.67.camel@twins>
Subject: Re: [PATCH 22/31] perf, core: Define generic hardware transaction
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Date: Fri, 28 Sep 2012 11:33:51 +0200
In-Reply-To: <1348806696-31170-23-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	 <1348806696-31170-23-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For tuning and debugging hardware transactional memory it is very
> important to have hardware counter support.
> 
> This patch adds a simple and hopefully generic set of hardware events
> for transactional memory and lock elision.
> 
> It is based on the TSX PMU support because I don't have any
> information on other CPU's HTM support.
> 
> There are start, commit and abort events for transactions and
> for lock elision.
> 
> The abort events are qualified by a generic abort reason that should
> be roughly applicable to a wide range of memory transaction systems:
> 
> capacity for the buffering capacity
> conflict for a dynamic conflict between CPUs
> all      for all aborts. On TSX this can be precisely sampled.
> 
> We need to split the events into general transaction events and lock
> elision events. Architecturs with HTM but no lock elision would only
> use the first set.
> 
> Implementation for Haswell in a followon patch.

I would much prefer sysfs events over yet another weird event class
here. That also solves the problem of not knowing wtf other cpus might
or might not do.
