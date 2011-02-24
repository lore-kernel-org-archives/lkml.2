Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1BXTzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:55:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60272 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1BXTzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:55:47 -0500
Date: Thu, 24 Feb 2011 19:55:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
Message-ID: <20110224195523.GA3640@n2100.arm.linux.org.uk>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org> <4D66B236.4030003@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D66B236.4030003@ru.mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:32:06PM +0300, Sergei Shtylyov wrote:
>    Won't generic cache_line_size() macro do instead? It's defined as  
> L1_CACHE_BYTES.

L1_CACHE_BYTES needs to be a compile time constant.  As such it ends up
being defined to the largest cache line size for the range of CPUs built
into the kernel.  This allows us to appropriately align data structures
to cache line boundaries which are boundaries for any of the CPUs which
are to be supported.

However, if you need to know exactly what cache line size you have for
doing things like cache maintainence then you can not use L1_CACHE_BYTES
or anything related to that.

One of the issues which complicates decoding the cache line size is that
on some CPUs, there's no way to read it.  On later CPUs, there's the
cache type register, of which there's several different formats which
makes decoding it rather painful and complicated.  Then there's the
related issue as to which cache line size you want - L1 Dcache, L1
Icache, or L2 cache, or some other level of cache?

It's all rather messy.
