Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2FGWU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:20:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35645 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab2FGWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:20:27 -0400
Message-ID: <4FD12926.8050200@wwwdotorg.org>
Date: Thu, 07 Jun 2012 16:20:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: boot problem with next-20120607
References: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au> <20120607150549.63f3ab81.akpm@linux-foundation.org>
In-Reply-To: <20120607150549.63f3ab81.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 04:05 PM, Andrew Morton wrote:
> On Thu, 7 Jun 2012 13:53:20 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Andrew,
>>
>> My boot of next-20120607 in PowerPC produces lots of these warnings:
>>
>> BUG: Bad rss-counter state mm:c000000278508000 idx:0 val:-27
>> BUG: Bad rss-counter state mm:c000000278284000 idx:0 val:-27
>> BUG: Bad rss-counter state mm:c000000279e13000 idx:0 val:-27
>> BUG: Bad rss-counter state mm:c000000278285400 idx:0 val:-27
>>
>> And so on (with different mm, idx and val numbers).  Searching showed me
>> commit "mm: correctly synchronize rss-counters at exit/exec" which seems
>> to be there to fix this exact problem?
> 
> Well that's a worry.  Are you really sure
> mm-correctly-synchronize-rss-counters-at-exit-exec.patch was applied at
> the time?
> 
> There's been an extended amount of inconclusive waffling on that patch,
> but I thought it concerned the best way to fix it, rather than
> *whether* it fixes it.

I see those same errors on my ARM system. I found that reverting that
patch (105d42c mm: correctly synchronize rss-counters at exit/exec) made
them go away, although I didn't investigate whether that just removed
some debug print or actually solved a problem.
