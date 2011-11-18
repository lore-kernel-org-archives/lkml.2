Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1KRXbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:31:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab1KRXbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:31:31 -0500
MIME-Version: 1.0
In-Reply-To: <op.v45u6zyy3l0zgt@mpn-glaptop>
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <CA+K6fF6SH6BNoKgwArcqvyav4b=C5SGvymo5LS3akfD_yE_beg@mail.gmail.com> <op.v45u6zyy3l0zgt@mpn-glaptop>
From: sandeep patil <psandeep.s@gmail.com>
Date: Fri, 18 Nov 2011 15:30:49 -0800
Message-ID: <CA+K6fF6iDivqmN9kfY34tWNg+g_rYBBmyS_Mxb6gvLuSgA2JyQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv17 0/11] Contiguous Memory Allocator
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/18 Michal Nazarewicz <mina86@mina86.com>:
> On Fri, 18 Nov 2011 22:20:48 +0100, sandeep patil <psandeep.s@gmail.com>
> wrote:
>>
>> I am running a simple test to allocate contiguous regions and write a log
>> on
>> in a file on sdcard simultaneously. I can reproduce this migration failure
>> 100%
>> times with it.
>> when I tracked the pages that failed to migrate, I found them on the
>> buffer head lru
>> list with a reference held on the buffer_head in the page, which
>> causes drop_buffers()
>> to fail.
>>
>> So, i guess my question is, until all the migration failures are
>> tracked down and fixed,
>> is there a plan to retry the contiguous allocation from a new range in
>> the CMA region?
>
> No.  Current CMA implementation will stick to the same range of pages also
> on consequent allocations of the same size.
>

Doesn't that mean the drivers that fail to allocate from contiguous DMA region
will fail, if the migration fails?

~ sandeep
