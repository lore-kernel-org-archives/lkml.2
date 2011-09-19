Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab1ISXLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:11:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:1540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab1ISXLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:11:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50072791"
Message-ID: <4E77CC0E.2090206@linux.intel.com>
Date: Mon, 19 Sep 2011 16:11:10 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>	 <1316471007.2455.24.camel@edumazet-laptop>	 <20110919223649.GO7761@one.firstfloor.org> <1316472096.2455.27.camel@edumazet-laptop>
In-Reply-To: <1316472096.2455.27.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'll provide not a hack but a clean patch for this.

Great thanks.
> I read once idr code, and its not messy at all.
You're not serious right? Especially the locking scheme is just
a extreme mess:

sometimes takes a lock, sometimes requires locking from the caller
even though the internal lock should be fine, sometimes uses unlocked 
bitmap
operations outside a lock, all mixed with a partial RCU implementation,
no assumption is documented of course.  etc.etc. It's a great poster child
for messy kernel code.

I read the code and I would be afraid touching it.

-Andi

