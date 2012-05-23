Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2EWP0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:26:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44341 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2EWP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:26:33 -0400
Message-ID: <4FBD01A6.4080807@wwwdotorg.org>
Date: Wed, 23 May 2012 09:26:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange> <4FBCF9F0.1010901@wwwdotorg.org> <Pine.LNX.4.64.1205231659310.21980@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1205231659310.21980@axis700.grange>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:03 AM, Guennadi Liakhovetski wrote:
> On Wed, 23 May 2012, Stephen Warren wrote:
> 
>> On 05/22/2012 04:23 PM, Guennadi Liakhovetski wrote:
>>> This patch adds a new function to allow clients to verify, whether a
>>> certain group is selected in the currently active setting or not.
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> ---
>>>
>>> Maybe there is already a way to do this without adding a new function, I 
>>> haven't found one, hence this patch.
>>
>> This function doesn't currently exist because it breaks the pinctrl
>> conceptual model, which is that devices ask pinctrl for certain settings
>> whenever they need them, rather than information flowing the other way.
> 
> Well, yes, we could tra to ask for each thinkable configuration and see 
> which one(s) succeed, but that doesn't seem very optimal either, even if 
> we only have 3 possibilities for now.
> 
>> What's the use case for this new functionality?
> 
> It's MMC. MMC interfaces can use 1, 4, or 8 data lines, depending on the 
> board configuration. The board knows, that it has, say, only 4 data lines 
> routed to the interface, so, it specifies the respective pinctrl 
> configuration as default. Now in the driver we have to know how many 
> data-lines are connected.

If using device tree, the bus-width property should be used. If not
using device tree, presumably you'd add an equivalent field to the
platform data.

An alternative (only when not using DT, since there's already a property
for DT) is that the driver doesn't select pinctrl state "default", but
instead first looks for e.g. "8bit" and if found uses it, then falls
back to "4bit", then falls back to "1bit". Whichever state name is
defined indicates which bus width is available.
