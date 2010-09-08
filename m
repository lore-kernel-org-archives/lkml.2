Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0IHNdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:33:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0IHNc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:32:59 -0400
Message-ID: <4C87907A.2040500@cn.fujitsu.com>
Date: Wed, 08 Sep 2010 21:32:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and   
   functions
References: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>	<4C878823.60709@cn.fujitsu.com> <20100908150519.2f9fe283@basil.nowhere.org>
In-Reply-To: <20100908150519.2f9fe283@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 15:05:19 +0200, Andi Kleen wrote:
> On Wed, 08 Sep 2010 20:57:07 +0800
> Miao Xie<miaox@cn.fujitsu.com>  wrote:
>
>> On Wed, 8 Sep 2010 14:19:25 +0200 (cest), Andi Kleen wrote:
>>>
>>>> According to the data, the length of the most copies is>=128.
>>>
>>> Thanks for the data. Large is easier to optimize than small, that's
>>> good.
>>>
>>> Could you also measure how many memsets need the backwards copy?
                                     ^^^^^^^ :-)
>>> (should be easy to add)
>>
>> I think memset doesn't need the backwards copy.
>
> I meant for memmove of course. Obviously memset doesn't need a backwards
> copy. That was just the only thing the script didn't measure because
> the original version didn't have memmove support.

memmove
total 5224252
[snip]

forward copy
value |-------------------------------------------------- count
     0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  980253


backward copy
value |-------------------------------------------------- count
     0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  4243999

the backward copy is much more than the forward copy.

Thanks
Miao


