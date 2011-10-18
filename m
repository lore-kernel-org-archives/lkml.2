Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1JRSAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:00:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58015 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1JRSAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:00:39 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
 <20111018122109.GB6660@csn.ul.ie> <op.v3j5ent03l0zgt@mpn-glaptop>
 <1318960126.4465.249.camel@nimitz>
Date: Tue, 18 Oct 2011 11:00:34 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3j6y8i33l0zgt@mpn-glaptop>
In-Reply-To: <1318960126.4465.249.camel@nimitz>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011 10:48:46 -0700, Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Tue, 2011-10-18 at 10:26 -0700, Michal Nazarewicz wrote:
>> > You can do this in a more general fashion by checking the
>> > zone boundaries and resolving the pfn->page every MAX_ORDER_NR_PAGES.
>> > That will not be SPARSEMEM specific.
>>
>> I've tried doing stuff that way but it ended up with much more code.
>
> I guess instead of:
>
>>> +static inline bool zone_pfn_same_memmap(unsigned long pfn1, unsigned long pfn2)
>>> +{
>>> +    return pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2);
>>> +}
>
> You could do:
>
> static inline bool zone_pfn_same_maxorder(unsigned long pfn1, unsigned long pfn2)
> {
> 	unsigned long mask = MAX_ORDER_NR_PAGES-1;
> 	return (pfn1 & mask) == (pfn2 & mask);
> }
>
> I think that works.  Should be the same code you have now, basically.

Makes sense.  It'd require calling pfn_to_page() every MAX_ORDER_NR_PAGES even
in memory models that have linear mapping of struct page, but I guess that's
not that bad.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
