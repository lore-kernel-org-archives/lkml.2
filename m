Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0DLIvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:51:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0DLIu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:50:59 -0400
To: Taras Glek <tglek@mozilla.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
From: Andi Kleen <andi@firstfloor.org>
References: <4BBA6776.5060804@mozilla.com>
Date: Mon, 12 Apr 2010 10:50:57 +0200
In-Reply-To: <4BBA6776.5060804@mozilla.com> (Taras Glek's message of "Mon, 05 Apr 2010 15:43:02 -0700")
Message-ID: <87wrwd9hqm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taras Glek <tglek@mozilla.com> writes:

> Hello,
> I am working on improving Mozilla startup times. It turns out that
> page faults(caused by lack of cooperation between user/kernelspace)
> are the main cause of slow startup. I need some insights from someone
> who understands linux vm behavior.

I have an older patch to create dynamic bitmaps based on the last 
run and only prefetch those pages. 

It wasn't entirely a win for everything and didn't work for shared
libraries, but with some additional tuning the approach still has
potential I think, by combining memory saving with prefetching.

ftp://firstfloor.org/pub/ak/pbitmap/INTRO
http://halobates.de/dp2.pdf

For your use case the algorithm would likely need some glibc support.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
