Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2D3QZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:25:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45673 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab2D3QZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:25:11 -0400
Message-ID: <4F9EBCC3.9040509@linux.vnet.ibm.com>
Date: Mon, 30 Apr 2012 11:24:35 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: undisclosed-recipients:";
	Dan Magenheimer" <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;Dan Magenheimer <dan.magenheimer@oracle.com>
						^-missing end of address
Subject: Re: [PATCH 6/6] zsmalloc: make zsmalloc portable
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-7-git-send-email-minchan@kernel.org> <4F980AFE.60901@vflare.org> <fcde09be-ae34-4f09-a324-825fb2d4fac2@default> <4F98ACF3.7060908@kernel.org> <4F98D814.9060808@kernel.org>
In-Reply-To: <4F98D814.9060808@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043016-5806-0000-0000-000014BD7417
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 12:07 AM, Minchan Kim wrote:

> 
> Quick patch - totally untested.
> 
> We can implement new TLB flush function 
> "local_flush_tlb_kernel_range" If architecture is very smart, it 
> could flush only tlb entries related to vaddr. If architecture is 
> smart, it could flush only tlb entries related to a CPU. If 
> architecture is _NOT_ smart, it could flush all entries of all CPUs.
> 
> Now there are few architectures have "local_flush_tlb_kernel_range". 
> MIPS, sh, unicore32, arm, score and x86 by this patch. So I think 
> it's good candidate other arch should implement. Until that, we can 
> add stub for other architectures which calls only [global/local] TLB
>  flush. We can expect maintainer could respond then they can 
> implement best efficient method. If the maintainer doesn't have any 
> interest, zsmalloc could be very slow in that arch and users will 
> blame that architecture.
> 
> Any thoughts?


I had this same idea a while back.

It is encouraging to know that someone else independently thought of
this solution too :)  Makes me think it is a good solution.

Let me build and test on x86, make sure there are no unforseen consequences.

Thanks again for your work here!

Seth

