Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2JWN52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:57:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59913 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab2JWN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:57:27 -0400
Date: Tue, 23 Oct 2012 15:57:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
Message-ID: <20121023135726.GG16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-6-git-send-email-andi@firstfloor.org> <1350995474.13456.12.camel@twins> <20121023133000.GX16230@one.firstfloor.org> <1351000250.13456.34.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351000250.13456.34.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:50:50PM +0200, Peter Zijlstra wrote:
> PERF_SAMPLE_RAW has a u32 size header and starts the data after that.
> This means you PERF_SAMPLE_RAW output ends up on a u32 aligned end
> address -- assuming the data is a u64 multiple, this is not good.
> 
> > It appears to work at least.
> 
> It would on x86, I'm fairly sure it'll break on things like SPARC. We
> used to have checks in the userspace code to warn for this on x86 as
> well. Not sure if that's still there.

Ok this is x86 specific code.

> 
> Hmm, so in kernel/events/core.c:perf_prepare_sample() there's a
> WARN_ON_ONCE() in the PERF_SAMPLE_RAW branch that should trigger with
> this.

Haven't seen this this warning so far.

If I added padding the perf userland would need to learn about it too,
I suspect it would need all the ugly macros like NETLINK. I always hated
those.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
