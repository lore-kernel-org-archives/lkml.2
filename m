Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab2JJS42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:56:28 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:56044 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab2JJS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:56:27 -0400
Message-ID: <5075C4CB.8020409@firmworks.com>
Date: Wed, 10 Oct 2012 08:56:11 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <robherring2@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org> <5069D946.1060502@gmail.com> <5069E1F0.5070902@wwwdotorg.org> <E1TIktZ-0000U4-Qh@jdl.com> <50749441.8030307@wwwdotorg.org> <5075ABB8.103@gmail.com> <5075BD21.2070106@firmworks.com> <5075C254.4040304@wwwdotorg.org>
In-Reply-To: <5075C254.4040304@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q9AIuAAR031014 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 8:45 AM, Stephen Warren wrote:
> On 10/10/2012 12:23 PM, Mitch Bradley wrote:
>> On 10/10/2012 7:09 AM, Rob Herring wrote:
>>> On 10/09/2012 04:16 PM, Stephen Warren wrote:
>>>> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
>>>>>>
>>>>>> What more do you think needs discussion re: dtc+cpp?
>>>>>
>>>>> How not to abuse the ever-loving shit out of it? :-)
>>>>
>>>> Perhaps we can just handle this through the regular patch review
>>>> process; I think it may be difficult to define and agree upon exactly
>>>> what "abuse" means ahead of time, but it's probably going to be easy
>>>> enough to recognize it when one sees it?
>>>
>>> Rather than repeating things over and over in reviews, we should
>>> document at least rules we can easily agree on and then add to it when
>>> people get "creative." Also, I can't keep up with every single binding
>>> review as is, and this could just add another level of complexity to the
>>> review. A few off the top of my head and from the thread discussion:
>>>
>>> - Headers must be self contained with no outside (i.e. libc, kernel,
>>> etc.) header dependencies.
>>> - No kernel kconfig option usage
>>> - No gcc built-in define usage
>>> - No unused items (i.e. externs, structs, etc.)
>>> - No macro concatenation
>>> - No macros for strings or property names
>>
>> Instead of making a bunch of rules about how you can only use a small
>> subset of cpp, why not just add a "define name value" command to DTC?
> 
> I implemented a patch to do exactly that, and it was rejected because it
> only solved part of the problem (named constants) and not the reset (a
> completely generic macro language/... within dtc). The argument was that
> defining just the named constant syntax on its own without knowing what
> the unspecified future macro language will look like might result in the
> named constant syntax not fitting into it.
> 
> That all said, I now think that using cpp is actually a much better
> solution that adding yet more dtc-specific syntax. The *huge* benefit
> here is that it allows you to share .h files between *.dts and C code,
> so you don't have to write out the same set of #defines once in dtc
> syntax and once in cpp syntax.

... and it imposes an equally *huge* restriction that you have to
restrict the .h file to avoid avoid C constructs.  That can be done, but
I've personally experienced a lot of headaches when trying to share .h
files between different languages.

> 
