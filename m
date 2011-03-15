Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab1COSqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:46:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1COSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:46:39 -0400
Date: Tue, 15 Mar 2011 18:46:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Saeed Bishara <saeed.bishara@gmail.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Avoid indefinite wait in smp_call_function_many() if
	cpumask is modified
Message-ID: <20110315184629.GB3620@n2100.arm.linux.org.uk>
References: <20110315181941.26948.65323.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315181941.26948.65323.stgit@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 06:20:56PM +0000, Catalin Marinas wrote:
> On ARM processors (and not only) with software broadcasting of the TLB
> maintenance operations, smp_call_function_many() is given a
> mm_cpumask(mm) as argument. This cpumask may be modified (bits cleared)
> during the smp_call_function_many() execution as a result of other
> events like ASID roll-over.

We shouldn't be modifying a mask which has been passed into one of these
functions.  Having masks change beneath a function which is actively
using it and can wait is an obvious recipe for problems and races.
