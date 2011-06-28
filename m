Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab1F1VE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:04:26 -0400
Received: from mail.candelatech.com ([208.74.158.172]:34021 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1F1VEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:04:20 -0400
Message-ID: <4E0A41CB.1020908@candelatech.com>
Date: Tue, 28 Jun 2011 14:04:11 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: David Daney <ddaney.cavm@gmail.com>, Christoph Lameter <cl@linux.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1106281431370.27518@router.home> <4E0A2E26.5000001@gmail.com> <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 01:58 PM, David Rientjes wrote:
> On Tue, 28 Jun 2011, David Daney wrote:
>
>> On 06/28/2011 12:32 PM, Christoph Lameter wrote:
>>> On Sun, 26 Jun 2011, Marcin Slusarz wrote:
>>>
>>>> slub checks for poison one byte by one, which is highly inefficient
>>>> and shows up frequently as a highest cpu-eater in perf top.
>>>
>>> Ummm.. Performance improvements for debugging modes? If you need
>>> performance then switch off debuggin.
>>
>> There is no reason to make things gratuitously slow.  I don't know about the
>> merits of this particular patch, but I must disagree with the general
>> sentiment.
>>
>> We have high performance tracing, why not improve this as well.
>>
>> Just last week I was trying to find the cause of memory corruption that only
>> occurred at very high network packet rates.  Memory allocation speed was
>> definitely getting in the way of debugging.  For me, faster SLUB debugging
>> would be welcome.
>>
>
> SLUB debugging is useful only to diagnose issues or test new code, nobody
> is going to be enabling it in production environment.  We don't need 30
> new lines of code that make one thing slightly faster, in fact we'd prefer
> to have as simple and minimal code as possible for debugging features
> unless you're adding more debugging coverage.

If your problem happens under load, then the overhead of slub could significantly
change the behaviour of the system.  Anything that makes it more efficient without
unduly complicating code should be a win.  That posted patch wasn't all that
complicated, and even if it has bugs, it could be fixed easily enough.

Thanks,
Ben

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

