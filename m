Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0IHMdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:33:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17674 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0IHMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:33:09 -0400
Subject: Re: [PATCH] Remove implicit list prefetches for most cases
From: Paul Moore <paul.moore@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, arjan@infradead.org,
        davem@davemloft.net
In-Reply-To: <1283936344-19124-1-git-send-email-andi@firstfloor.org>
References: <1283936344-19124-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Organization: Hewlett-Packard
Date: Wed, 08 Sep 2010 08:32:59 -0400
Message-ID: <1283949179.4480.3.camel@flek>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 10:59 +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> We've had explicit list prefetches in list_for_each and friends
> for quite some time. According to Arjan they were originally
> added for K7 where they were a slight win.
> 
> It's doubtful they help very much today, especially on newer CPUs with
> aggressive prefetching. Most list_for_eachs bodies are quite short and
> the prefetch does not help if it doesn't happen sufficiently in advance
> or when the data is not really cache cold.
> 
> The feedback from CPU designers is that they don't like us using explicit
> prefetches unless there is a very good reason (and list_for_each* alone
> clearly isn't one)
> 
> Also the prefetches cause the list walks to generate bad code,
> increase the number of registers needed.

If prefetch() is generally considered a "Bad Thing", I'm OK with just
removing them from NetLabel; no need to rename and conditionalize.  I
put them in the netlbl_af[4,6]list_*() routines because those routines
were modeled after the normal list routines which had prefetches and I
just assumed someone much smarter had found them to be a win.

-- 
paul moore
linux @ hp


