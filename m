Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1GGHhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:37:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1GGHhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:37:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv11 0/8] Contiguous Memory Allocator
Date: Thu, 7 Jul 2011 09:36:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barker <jesse.barker@linaro.org>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107051407.17249.arnd@arndb.de> <20110706151112.5c619431.akpm@linux-foundation.org>
In-Reply-To: <20110706151112.5c619431.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107070936.34469.arnd@arndb.de>
X-Provags-ID: V02:K0:nx1irPue/7dvJmBClXrk9viMKTA4jbWpORa0qve5SE7
 5mH8wADGPFVksbJg6vkmXMzFG0G04FQeV+BX2PZP4z1igpsHQR
 fDSC+jYa1wIFwNeXuDLs9ZXuP/HAKPKLW6bAyoanGEvYjIMbD9
 eJFD93+yYsnOhMQE1sH34xPokSoe0uvMI2AzlQ3VAkya7kxcYx
 /V4TF1YIqYSGvuLLmIMOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 July 2011 00:11:12 Andrew Morton wrote:
> I could review it and put it in there on a preliminary basis for some
> runtime testing.  But the question in my mind is how different will the
> code be after the problems which rmk has identified have been fixed?
> 
> If "not very different" then that effort and testing will have been
> worthwhile.
> 
> If "very different" or "unworkable" then it was all for naught.
> 
> So.  Do we have a feeling for the magnitude of the changes which will
> be needed to fix these things up?

As far as I can tell, the changes that we still need are mostly in the 
ARM specific portion of the series. All architectures that have cache
coherent DMA by default (most of the other interesting ones) can just
call dma_alloc_from_contiguous() from their dma_alloc_coherent()
function without having to do extra work.

It's possible that there will be small changes to simplify to the
first six patches in order to simplify the ARM port, but I expect
them to stay basically as they are, unless someone complains about
them.

	Arnd
