Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0DEXSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:18:11 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:55653 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756368Ab0DEXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:17:52 -0400
Date: Tue, 6 Apr 2010 09:17:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Taras Glek <tglek@mozilla.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-ID: <20100405231746.GB3335@dastard>
References: <4BBA6776.5060804@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA6776.5060804@mozilla.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 03:43:02PM -0700, Taras Glek wrote:
> Hello,
> I am working on improving Mozilla startup times. It turns out that
> page faults(caused by lack of cooperation between user/kernelspace)
> are the main cause of slow startup. I need some insights from
> someone who understands linux vm behavior.
> 
> Current Situation:
> The dynamic linker mmap()s  executable and data sections of our
> executable but it doesn't call madvise().
> By default page faults trigger 131072byte reads. To make matters

Try tuning /sys/block/<dev>/queue/read_ahead_kb and see if that
makes any difference - that's the default maximum readahead for the
given block device and defaults to 128k.

There has been some recent work to increase the default readahead
size, so if changing the default improves performance then perhaps
a fix for your problem is already in the works?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
