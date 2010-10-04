Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0JDJCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:02:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0JDJCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:02:14 -0400
Message-ID: <4CA997DF.5030008@kernel.org>
Date: Mon, 04 Oct 2010 11:01:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org> <AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
In-Reply-To: <AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 09:01:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/25/2010 03:08 PM, Torsten Kaiser wrote:
> [adding Tejun Heo, because I'm partly blaming his workqueues]

:-) Sorry about the delay.  I was away the last week.

> After that I enabled lockdep and retried the same update: This time no
> hang, only the same lockdep report that Yang Ruirui had.
> 
> So I'm currently at a loss how I should continue from here. The XFS
> false positive drowns any other lockdep problems, but XFS had some
> hang problems with the new workqueues. (Personally I had no other hang
> with earlier 2.6.36-rcs)

If workqueue lockdep annotations are triggering spuriously, just nuke
all lockdep annotations in workqueue.c.  Currently the annotations are
the same as before and trigger even when an actual deadlock won't
happen anymore around flushes (but then again all the current users
should be operating under the same constraints as before).  I'm
looking into how to improve the lockdep annotations but in the end it
might be best to leave it as it is.  I'll try to analyze the warnings.

Thanks.

-- 
tejun
