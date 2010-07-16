Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631Ab0GPFqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 01:46:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37641 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0GPFq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 01:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pKHeFxkfV/u8couREZMWujHsSVB2HpIea9XvFG+gZXJUgBrcsF16Ry1i5oTSV0EGQ2
         kuQG39u+5muAxHlBu9Bch2KzLL96dOhbQ80c/Nq3fQRmsDCdVH1Viyj/VQUVXHZ5GtHb
         hc78K3H8FhSEcu/qxUB4UxNlCMpVNcCCsk5BA=
MIME-Version: 1.0
In-Reply-To: <AANLkTil-sv82zjR7yJr_3nZ0QBO_8Jwj_FO0iFubwe2s@mail.gmail.com>
References: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
	<AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
	<1279058027.936.236.camel@calx>
	<AANLkTil-sv82zjR7yJr_3nZ0QBO_8Jwj_FO0iFubwe2s@mail.gmail.com>
Date: Fri, 16 Jul 2010 13:46:28 +0800
Message-ID: <AANLkTikbGTlAPAj6lbuR5nIWyBAqnfBpy3IE_LywrPID@mail.gmail.com>
Subject: Re: [PATCH] slob_free:free objects to their own list
From: Bob Liu <lliubbo@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, hannes@cmpxchg.org,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 5:07 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Wed, Jul 14, 2010 at 12:53 AM, Matt Mackall <mpm@selenic.com> wrote:
>> On Tue, 2010-07-13 at 20:52 +0300, Pekka Enberg wrote:
>>> Hi Bob,
>>>
>>> [ Please CC me on SLOB patches. You can use the 'scripts/get_maintainer.pl'
>>>   script to figure out automatically who to CC on your patches. ]
>>>
>>> On Sat, Jul 10, 2010 at 1:05 PM, Bob Liu <lliubbo@gmail.com> wrote:
>>> > slob has alloced smaller objects from their own list in reduce
>>> > overall external fragmentation and increase repeatability,
>>> > free to their own list also.
>>> >
>>> > Signed-off-by: Bob Liu <lliubbo@gmail.com>
>>>
>>> The patch looks sane to me. Matt, does it look OK to you as well?
>>
>> Yep, this should be a marginal improvement.
>>
>> Acked-by: Matt Mackall <mpm@selenic.com>
>
> Great! Bob, if you could provide the /proc/meminfo numbers for the
> patch description, I'd be more than happy to merge this.
>
Hi, Pekka

Sorry for the wrong cc and later reply.
This is  /proc/meminfo result in my test machine:
without this patch:
===
MemTotal:        1030720 kB
MemFree:          750012 kB
Buffers:           15496 kB
Cached:           160396 kB
SwapCached:            0 kB
Active:           105024 kB
Inactive:         145604 kB
Active(anon):      74816 kB
Inactive(anon):     2180 kB
Active(file):      30208 kB
Inactive(file):   143424 kB
Unevictable:          16 kB
....

with this patch:
===
MemTotal:        1030720 kB
MemFree:          751908 kB
Buffers:           15492 kB
Cached:           160280 kB
SwapCached:            0 kB
Active:           102720 kB
Inactive:         146140 kB
Active(anon):      73168 kB
Inactive(anon):     2180 kB
Active(file):      29552 kB
Inactive(file):   143960 kB
Unevictable:          16 kB
...

The result show only very small improverment!
And when i tested it on a embeded system with 64MB, I found this path
is never called while kernel booting.

Thanks for the kindly review.

-- 
Regards,
--Bob
