Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0KIVYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:24:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab0KIVYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:24:47 -0500
Message-ID: <4CD9BBF9.8020600@redhat.com>
Date: Tue, 09 Nov 2010 16:24:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com> <20101109142109.224267d0@corrin.poochiereds.net> <4CD9A209.6070807@redhat.com> <4CD9BB5B.2090206@acm.org>
In-Reply-To: <4CD9BB5B.2090206@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 04:21 PM, Zan Lynx wrote:
> On 11/9/10 12:33 PM, Rik van Riel wrote:
>> On 11/09/2010 02:21 PM, Jeff Layton wrote:
>>
>>> This does leave the page in sort of a funky state. The uptodate bit
>>> will still probably be set, but the dirty bit won't be. The page will
>>> be effectively "disconnected" from the backing store until someone
>>> writes to it.
>>>
>>> I suppose though that this is the best that can reasonably be done in
>>> this situation however...
>>
>> I spent a few days looking for alternatives, and indeed I found
>> nothing better...
>
> Just an off the top of my head crazy idea...
>
> Could you leave the error bit set on the page and treat it as a dirty
> bit during a future msync, clearing the error bit at that point.
>
> The general idea would be to leave the error set unless an explicit
> write was requested.

The problem with that is that the page will be unreclaimable,
and the VM could get filled with PageError pages and be unable
to make further progress (if the IO path does not come back).

-- 
All rights reversed
