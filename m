Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1CFCEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 21:04:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52448 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1CFCEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 21:04:07 -0500
Message-ID: <4D72E142.3000305@kernel.org>
Date: Sat, 05 Mar 2011 17:20:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC] memblock; Properly handle overlaps
References: <1299297946.8833.931.camel@pasglop>	 <4D71CE24.1090302@kernel.org> <1299311788.8833.937.camel@pasglop>	 <4D728B8C.2080803@kernel.org> <1299361063.8833.953.camel@pasglop>	 <4D72B2D0.3080700@kernel.org> <1299363583.8833.964.camel@pasglop>	 <4D72C552.4050406@kernel.org> <1299372594.8833.966.camel@pasglop>
In-Reply-To: <1299372594.8833.966.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4D72EB7F.0103,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 04:49 PM, Benjamin Herrenschmidt wrote:
> On Sat, 2011-03-05 at 15:20 -0800, Yinghai Lu wrote:
>>
>> maybe we can omit rgn->size == 0 checking here.
>> with that case, dummy array will go though to some extra checking.
>>
>> if (rgn->base <= base && rend >= end)
>> if (base < rgn->base && end >= rgn->base) {
>> if (base <= rend && end >= rend) {
>>
>> but we can spare more checking regarding
>>         rgn->size == 0
> 
> Well, the array can be collasped to dummy by the removal of the last
> block when doing a top overlap, then on the next loop around, we can
> potentially hit the if (base <= rend && end >= rend) test, and loop
> again no ?
> 
> I'd rather keep the test in .. won't hurt.

ok.
