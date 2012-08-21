Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2HUBPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:15:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44859 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2HUBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <50320FC4.2020100@ti.com>
References: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
	<1342466485-1050-3-git-send-email-omar.luna@linaro.org>
	<alpine.DEB.2.00.1208020150240.4177@utopia.booyaka.com>
	<CALLhW=6-b+kjfG-u3+uXiD64UwoNEdufjJKu0Mx-sGWp6n9csg@mail.gmail.com>
	<501B609F.9030403@ti.com>
	<CALLhW=7yJTq_cfB=KGY5VT8fNO1u_hrY118ysihFuQA+gVFRuQ@mail.gmail.com>
	<50320FC4.2020100@ti.com>
Date: Mon, 20 Aug 2012 20:15:16 -0500
Message-ID: <CALLhW=6DNiH4pimWVB3o3uoCp2sC6gqub4_DqE+MB1Chjri8sw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: OMAP: hwmod: revise deassert sequence
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 20 August 2012 05:21, Benoit Cousson <b-cousson@ti.com> wrote:
> Hi Omar,
>
> On 08/03/2012 05:52 PM, Omar Ramirez Luna wrote:
>> On 3 August 2012 00:24, Vaibhav Hiremath <hvaibhav@ti.com> wrote:
>>> On 8/3/2012 3:50 AM, Omar Ramirez Luna wrote:
>>>> So in _enable:
>>>>
>>>>         _enable_clocks(oh);
>>>>         if (soc_ops.enable_module)
>>>>                 soc_ops.enable_module(oh);
>>>>
>>>> The enable_module part seems redundant to me, since the module should
>>>> be already enabled by the first call to _enable_clocks.
>>>
>>> Yes they do same thing, I believe the plan is to get rid of all clock
>>> leaf-nodes in the near future, and let hwmod handle module
>>> enable/disable part.
>>
>> If this is the case then an enable_module call is needed in my patch
>> for when these changes are made. The original works fine but only
>> because currently clock framework does what enable_module is doing.
>
> Yes, that's the case, but I plan to remove most of the leaf clocks ASAP,
> so we cannot rely on that.
>
>> Please let me know if you want me to resend with this change.
>
> Yes, could you please repost with that change?

Not a problem.

> It will be good as well that you remove the leaf clock and use the
> parent clock of current leaf as the main_clock. In that case it will
> ensure that this is the hwmod fmwk that does enable the modulemode and
> not the clock fmwk.

Ok, let me try that.

Thanks for the comments,

Omar
