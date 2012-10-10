Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2JJSxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:53:04 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:49027 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2JJSxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:53:01 -0400
Message-ID: <5075C3F8.4080600@firmworks.com>
Date: Wed, 10 Oct 2012 08:52:40 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <robherring2@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org> <5069D946.1060502@gmail.com> <5069E1F0.5070902@wwwdotorg.org> <E1TIktZ-0000U4-Qh@jdl.com> <50749441.8030307@wwwdotorg.org> <5075ABB8.103@gmail.com> <5075C10C.1030205@wwwdotorg.org>
In-Reply-To: <5075C10C.1030205@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q9AIqdQP028673 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 8:40 AM, Stephen Warren wrote:
> On 10/10/2012 11:09 AM, Rob Herring wrote:
>> On 10/09/2012 04:16 PM, Stephen Warren wrote:
>>> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
>>>>>
>>>>> What more do you think needs discussion re: dtc+cpp?
>>>>
>>>> How not to abuse the ever-loving shit out of it? :-)
>>>
>>> Perhaps we can just handle this through the regular patch review
>>> process; I think it may be difficult to define and agree upon exactly
>>> what "abuse" means ahead of time, but it's probably going to be easy
>>> enough to recognize it when one sees it?
>>
>> Rather than repeating things over and over in reviews, we should
>> document at least rules we can easily agree on and then add to it when
>> people get "creative." Also, I can't keep up with every single binding
>> review as is, and this could just add another level of complexity to the
>> review. A few off the top of my head and from the thread discussion:
>>
>> - Headers must be self contained with no outside (i.e. libc, kernel,
>> etc.) header dependencies.
>> - No kernel kconfig option usage
>> - No gcc built-in define usage
>> - No unused items (i.e. externs, structs, etc.)
> 
>> - No macro concatenation
> 
> That seems to be potentially a very useful feature; I have no idea why
> we would ban that; it isn't banned in C code in the kernel is it?

It's used in the kernel.  It is useful, but it has an unexpected side
effect that can be extremely annoying - it can make it extremely
difficult to find a definition with grep.  All the grep hits will be for
the fully-expanded uses of a symbol, while the definition is "hidden" by
virtue of being synthesized by concatenation.

Maybe it's not a big deal in a small project, but in a code base the
size of the Linux kernel, where you don't know a priori where something
is defined, it can make you want to tear your hair out.

> 
>> - No macros for strings or property names
> 
> Property names I can understand. Property values - I can perhaps see a
> use-case for...
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
