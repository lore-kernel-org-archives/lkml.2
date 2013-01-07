Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3AGWbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:31:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54618 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3AGWbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:31:36 -0500
Message-ID: <50EB4CB9.9010104@zytor.com>
Date: Mon, 07 Jan 2013 14:31:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Shaohua Li <shli@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
References: <20130107081213.GA21779@kernel.org> <50EAE66B.1020804@redhat.com>
In-Reply-To: <50EAE66B.1020804@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 07:14 AM, Rik van Riel wrote:
> On 01/07/2013 03:12 AM, Shaohua Li wrote:
>>
>> We use access bit to age a page at page reclaim. When clearing pte
>> access bit,
>> we could skip tlb flush for the virtual address. The side effect is if
>> the pte
>> is in tlb and pte access bit is unset, when cpu access the page again,
>> cpu will
>> not set pte's access bit. So next time page reclaim can reclaim hot pages
>> wrongly, but this doesn't corrupt anything. And according to intel
>> manual, tlb
>> has less than 1k entries, which coverers < 4M memory. In today's system,
>> several giga byte memory is normal. After page reclaim clears pte
>> access bit
>> and before cpu access the page again, it's quite unlikely this page's
>> pte is
>> still in TLB. Skiping the tlb flush for this case sounds ok to me.
> 
> Agreed. In current systems, it can take a minute to write
> all of memory to disk, while context switch (natural TLB
> flush) times are in the dozens-of-millisecond timeframes.
> 

I'm confused.  We used to do this since time immemorial, so if we aren't
doing that now, that meant something changed somewhere along the line.
It would be good to figure out if that was an intentional change or
accidental.

	-hpa


