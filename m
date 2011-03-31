Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1CaVJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:09:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34291 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1CaVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=ULdkstQAZBn228xsw0haCh1NJOMPsGDs81Dhtk9fncRQgkgPnXNjrNhn707msqwpl2
         dTTS7oEdPlDifxo9kA4tjebeJfQ9BbnQ1HCcpsNfnoJx+XqfkQFx7dpBNW8y3Ztu5d0K
         mmVb842fChHFT9ZKG9gps/cHiRV3zW+LB77j4=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
        "Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz>
Date: Thu, 31 Mar 2011 23:09:42 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1301587083.31087.1032.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 17:58:03 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
wrote:

> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
>>
>> +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned  
>> long end,
>> +                                      gfp_t flag)
>> +{
>> +       unsigned long pfn = start, count;
>> +       struct page *page;
>> +       struct zone *zone;
>> +       int order;
>> +
>> +       VM_BUG_ON(!pfn_valid(start));
>
> This seems kinda mean.  Could we return an error?  I understand that
> this is largely going to be an early-boot thing, but surely trying to
> punt on crappy input beats a full-on BUG().

Actually, I would have to check but I think that the usage of this function
(in this patchset) is that the caller expects the function to succeed.  It  
is
quite a low-level function so before running it a lot of preparation is  
needed
and the caller must make sure that several conditions are met.  I don't  
really
see advantage of returning a value rather then BUG()ing.

Also, CMA does not call this function at boot time.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
