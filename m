Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1IGCvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:51:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44152 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1IGCvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:51:02 -0400
Message-ID: <4E66DC0E.4070006@infradead.org>
Date: Tue, 06 Sep 2011 23:50:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201109051449.50744.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404EC6BEE0C@dbde02.ent.ti.com> <201109061647.31861.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109061647.31861.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-09-2011 11:47, Laurent Pinchart escreveu:
> Hi Vaibhav,
> 
> On Tuesday 06 September 2011 16:12:35 Hiremath, Vaibhav wrote:
>> On Monday, September 05, 2011 6:20 PM Laurent Pinchart wrote:
>>> On Sunday 04 September 2011 15:32:28 Mauro Carvalho Chehab wrote:
>>
>> <snip>
>>
>>> I don't mind splitting the config option. An alternative would be to
>>> compile media_entity_init() and media_entity_cleanup() based on
>>> CONFIG_MEDIA_SUPPORT instead of CONFIG_MEDIA_CONTROLLER, but that looks a
>>> bit hackish to me.
>>>
>>>> Also, I don't like the idea of increasing drivers complexity for the
>>>> existing drivers that work properly without MC. All those core
>>>> conversions that were done in the last two years caused already too much
>>>> instability to them.
>>>>
>>>> We should really avoid touching on them again for something that won't
>>>> be adding any new feature nor fixing any known bug.
>>>
>>> We don't have to convert them all in one go right now, we can implement
>>> pad-level operations support selectively when a subdev driver becomes used
>>> by an MC-enabled host/bridge driver.
>>
>> I completely agree that we should not be duplicating the code just for sake
>> of it.
>>
>> Isn't the wrapper approach seems feasible here?
> 
> As explained in a previous e-mail, a wrapper sounds like a good approach to 
> me, to emulate video::* operations based on pad::* operations. We want to move 
> to pad::* operations, so we should not perform emulation the other way around.

We have 300+ drivers under /drivers/media. Just a few of them need MC API.

Good sense says that we shouldn't touch on 300+ just because of half dozen drivers.

So, if a wrapper is needed, it should be done for the other side.

Mauro.
