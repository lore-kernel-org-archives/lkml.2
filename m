Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0KORy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:54:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36236 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab0KORy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:54:28 -0500
Message-ID: <4CE173B3.9000603@zytor.com>
Date: Mon, 15 Nov 2010 09:53:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 0/4]x86: allocate up to 32 tlb invalidate vectors
References: <1288766655.23014.113.camel@sli10-conroe> <1289829765.14740.2.camel@sli10-conroe>
In-Reply-To: <1289829765.14740.2.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 06:02 AM, Shaohua Li wrote:
> On Wed, 2010-11-03 at 14:44 +0800, Shaohua Li wrote:
>> Hi,
>> In workload with heavy page reclaim, flush_tlb_page() is frequently
>> used. We currently have 8 vectors for tlb flush, which is fine for small
>> machines. But for big machines with a lot of CPUs, the 8 vectors are
>> shared by all CPUs and we need lock to protect them. This will cause a
>> lot of lock contentions. please see the patch 3 for detailed number of
>> the lock contention.
>> Andi Kleen suggests we can use 32 vectors for tlb flush, which should be
>> fine for even 8 socket machines. Test shows this reduces lock contention
>> dramatically (see patch 3 for number).
>> One might argue if this will waste too many vectors and leave less
>> vectors for devices. This could be a problem. But even we use 32
>> vectors, we still leave 78 vectors for devices. And we now have per-cpu
>> vector, vector isn't scarce any more, but I'm open if anybody has
>> objections.
>>
> Hi Ingo & hpa, any comments about this series?
> 

Hi Shaohua,

It looks good... I need to do a more thorough review and put it in; I
just have been consumed a bit too much by a certain internal project.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

