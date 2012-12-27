Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2L0UVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 15:21:35 -0500
Received: from mail.digium.com ([216.207.245.2]:50227 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2L0UVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 15:21:32 -0500
Date: Thu, 27 Dec 2012 14:09:33 -0600
From: Shaun Ruffell <sruffell@digium.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Minimum toolchain requirements?
Message-ID: <20121227200933.GC14257@digium.com>
References: <1355523910.18402.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355523910.18402.9@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Fri, Dec 14, 2012 at 04:25:10PM -0600, Rob Landley wrote:
> Although the README and Documentation/Changes both say the kernel
> builds with gcc 3.2, this is no loner the case. In reality the new
> 3.7 kernel no longer builds under unpatched gcc 4.2.1 (the last
> GPLv2 release).
> 
> Building for i686 breaks with
> "arch/x86/kernel/cpu/perf_event_p6.c:22: error:
> p6_hw_cache_event_ids causes a section type conflict" (trivial
> workaround: patch kernel so CONFIG_BROKEN_RODATA defaults to y).

I came across your email while searching for a solution to the above
build error.

In addition to setting CONFIG_BROKEN_RODATA=y, Jan Beulich sent a
patch [1] to LKML that also fixes this build problem for me.

[1] https://lkml.org/lkml/2012/11/23/308

It doesn't appear to have hit Linus' tree yet though, but with luck
someone will pick it up before 3.8 final.

Cheers,
Shaun
