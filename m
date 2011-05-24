Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1EXJGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:06:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57147 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab1EXJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:06:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB74F7.9020109@jp.fujitsu.com>
Date: Tue, 24 May 2011 18:05:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: mgorman@suse.de
CC: minchan.kim@gmail.com, abarry@cray.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DCDA347.9080207@cray.com> <BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com> <4DD2991B.5040707@cray.com> <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com> <20110520164924.GB2386@barrios-desktop> <4DDB3A1E.6090206@jp.fujitsu.com> <20110524083008.GA5279@suse.de> <4DDB6DF6.2050700@jp.fujitsu.com> <20110524084915.GC5279@suse.de>
In-Reply-To: <20110524084915.GC5279@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Why?
>>
>> Otherwise, we don't have good PCP dropping trigger. Big machine might have
>> big pcp cache.
>>
> 
> Big machines also have a large cost for sending IPIs.

Yes. But it's only matter if IPIs are frequently happen.
But, drain_all_pages() is NOT only IPI source. some vmscan function (e.g.
try_to_umap) makes a lot of IPIs.

Then, it's _relatively_ not costly. I have a question. Do you compare which
operation and drain_all_pages()? IOW, your "costly" mean which scenario suspect?




