Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2JIXVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:21:25 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:44045 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2JIXVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:21:22 -0400
Message-ID: <5074B155.4090703@firmworks.com>
Date: Tue, 09 Oct 2012 13:20:53 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Jon Loeliger <jdl@jdl.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org> <5069C042.40209@gmail.com> <5069C11C.6040505@wwwdotorg.org> <5069D946.1060502@gmail.com> <5069E1F0.5070902@wwwdotorg.org> <E1TIktZ-0000U4-Qh@jdl.com> <50749441.8030307@wwwdotorg.org>
In-Reply-To: <50749441.8030307@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q99NKsuh014857 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/2012 11:16 AM, Stephen Warren wrote:
> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
>>>
>>> What more do you think needs discussion re: dtc+cpp?
>>
>> How not to abuse the ever-loving shit out of it? :-)
> 
> Perhaps we can just handle this through the regular patch review
> process; I think it may be difficult to define and agree upon exactly
> what "abuse" means ahead of time, but it's probably going to be easy
> enough to recognize it when one sees it?


One of the ways it could get out of hand would be via "include
dependency hell".  People will be tempted to reuse existing .h files
containing pin definitions, which, if history is a guide, will end up
depending on all sorts of other .h files.

Another problem I often face with symbolic names is the difficulty of
figuring out what the numerical values really are (for debugging),
especially when .h files are in different subtrees from the files that
use the definitions, and when they use multiple macro levels and fancy
features like concatenation.  Sometimes I think it's clearer just to
write the number and use a comment to say what it is.


> 
> I imagine the most common usage will simply be a bunch of:
> 
> #define TEGRA_GPIO_PB0 32
> #define TEGRA_GPIO_INT_LEVEL_LOW 8
> 
> / {
>     xxx {
>         interrupts = <TEGRA_GPIO_PB0 TEGRA_GPIO_INT_LEVEL_LOW>;
> 
> and similarly, simple math:
> 
>     something = <((FOO << XXX_SHIFT) | (BAR << YYY_SHIFT))>;
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
