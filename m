Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0GEIyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0GEIyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:54:16 -0400
Message-ID: <4C319D61.5090002@redhat.com>
Date: Mon, 05 Jul 2010 16:52:49 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ali Gholami Rudi <ali@rudi.ir>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
References: <20100507075128@tarekhel>
In-Reply-To: <20100507075128@tarekhel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 03:51 PM, Ali Gholami Rudi wrote:
> Hi,
>
> In -rc4 kernel these messages appear in my dmesg (complete dmesg
> at the end of this mail):
>
> 	[    0.400777] swapper:1 freeing invalid memtype e0000000-e0040000
> 	...
> 	[    0.453489] swapper:1 freeing invalid memtype e0000000-e0010000
> 	[    0.453585] swapper:1 freeing invalid memtype e0041000-e0045000
> 	[    0.453673] swapper:1 freeing invalid memtype e0045000-e0049000
> 	...
> 	[   12.662571] fbpad:980 conflicting memory types e0049000-e0549000 uncached-minus<->write-combining
> 	[   12.662579] reserve_memtype failed 0xe0049000-0xe0549000, track uncached-minus, req uncached-minus
> 	[   13.303389] fbpad:980 map pfn expected mapping type uncached-minus for e0049000-e0549000, got write-combining
>
> The last 3 lines appear when mmap()ing nouveau framebuffer.
>
> I reverted this commit and everything seems ok once more:
>
> 	commit 6a4f3b523779b67e7d560ed42652f8a59f2f9782
> 	Author: Venkatesh Pallipadi<venki@google.com>
> 	Date:   Thu Jun 10 17:45:01 2010 -0700
> 	
> 	    x86, pat: Proper init of memtype subtree_max_end
>
> Thanks,
> Ali

Could you please try following commit in -tip tree?

commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Sat May 29 15:31:43 2010 +0200

     rbtree: Undo augmented trees performance damage

Thanks
Xiaotian
