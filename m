Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1BCTGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:06:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1BCTGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:06:50 -0500
Date: Thu, 3 Feb 2011 20:06:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jind??ich Makovi??ka <makovick@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Message-ID: <20110203190612.GL5843@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
 <20110201154947.GX16981@random.random>
 <20110203132407.GF11958@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110203132407.GF11958@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 01:24:08PM +0000, Mel Gorman wrote:
> This is very likely. Compaction calls into migration which will wait on
> dirty pages after a time. With a large number of dirty pages backed by a
> slow drive such as a USB stick, it could be getting stalled there for a
> long period of time. 
> 
> Whether migration sleeps or not can be controlled by the sync parameter
> passed into try_to_compact_memory which could be always forced to false
> if GFP_NO_KSWAPD?

I would expect that to hide any regression we could have because of
more dirty cache in the system, yes.

However Jindřich reported not being able to reproduce anything anymore
in -rc3, so I'm unsure if we should make that change anymore. I asked
to try again cause it should too easy that got fixed magically (but I
didn't check closely if there are usb/stroage changes in rc2->rc3 that
may explain this, so it's not impossible but sounds very unlikely that
it got fixed). More likely this isn't reproducible reliably, or maybe
it also happens without compaction and without THP ("cp /dev/zero
/mnt/usbdrive" isn't going to make the system behave nice regardless
of compaction being synchronous, asynchronous, or disabled) and maybe
he tried the copy with more or less free memory.

I'm doing some other performance check for another workload in the
pre-async compaction status, and I'll let you know when I get results.
