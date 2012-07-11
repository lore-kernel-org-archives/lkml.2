Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2GKOBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:01:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48983 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2GKOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:01:43 -0400
Message-ID: <4FFD86FE.1090307@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 09:00:30 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zsmalloc improvements
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <4FFD2524.2050300@kernel.org>
In-Reply-To: <4FFD2524.2050300@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071114-7408-0000-0000-000006AB546D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:03 AM, Minchan Kim wrote:
> On 07/03/2012 06:15 AM, Seth Jennings wrote:
>> zsmapbench measures the copy-based mapping at ~560 cycles for a
>> map/unmap operation on spanned object for both KVM guest and bare-metal,
>> while the page table mapping was ~1500 cycles on a VM and ~760 cycles
>> bare-metal.  The cycles for the copy method will vary with
>> allocation size, however, it is still faster even for the largest
>> allocation that zsmalloc supports.
>>
>> The result is convenient though, as mempcy is very portable :)
> 
> Today, I tested zsmapbench in my embedded board(ARM).
> tlb-flush is 30% faster than copy-based so it's always not win.
> I think it depends on CPU speed/cache size.
> 
> zram is already very popular on embedded systems so I want to use
> it continuously without 30% big demage so I want to keep our old approach
> which supporting local tlb flush. 
> 
> Of course, in case of KVM guest, copy-based would be always bin win.
> So shouldn't we support both approach? It could make code very ugly
> but I think it has enough value.
> 
> Any thought?

Thanks for testing on ARM.

I can add the pgtable assisted method back in, no problem.
The question is by which criteria are we going to choose
which method to use? By arch (i.e. ARM -> pgtable assist,
x86 -> copy, other archs -> ?)?

Also, what changes did you make to zsmapbench to measure
elapsed time/cycles on ARM?  Afaik, rdtscll() is not
supported on ARM.

Thanks,
Seth

