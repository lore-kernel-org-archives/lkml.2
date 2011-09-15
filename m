Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab1IOPah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:30:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58754 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1IOPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:30:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Thu, 15 Sep 2011 17:30:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
In-reply-to: <20110915132301.GK28104@game.jcrosoft.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Josh Wu <josh.wu@atmel.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <4E721A17.40206@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21)
 Gecko/20110831 Thunderbird/3.1.13
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
 <20110906200512.GA15083@game.jcrosoft.org> <4E668BBF.4020600@gmail.com>
 <20110915132301.GK28104@game.jcrosoft.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 03:23 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 23:08 Tue 06 Sep     , Sylwester Nawrocki wrote:
>> On 09/06/2011 10:05 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>> I'm not entirely sure on this one, but as we had a similar situation with
>>>> clocks, we decided to extablish the clock hierarchy in the board code, and
>>>> only deal with the actual device clocks in the driver itself. I.e., we
>>>> moved all clk_set_parent() and setting up the parent clock into the board.
>>>> And I do think, this makes more sense, than doing this in the driver, not
>>>> all users of this driver will need to manage the parent clock, right?
>>>
>>> I don't like to manage the clock in the board except if it's manadatory otherwise
>>> we manage this at soc level

You often just can't decide about clocks hierarchy at SoC level as it
can depend on the board layout and which devices are used on it.

>>>
>>> the driver does not have to manage the clock hierachy or detail implementation
>>> but manage the clock enable/disable and speed depending on it's need

I think everyone agrees on that.

>>
>> We had a similar problem in the past and we ended up having the boot loader
>> setting up the parent clock for the device clock. The driver only controls clock
>> gating and sets its clock frequency based on an internal IP version information,
>> derived from the SoC revision.
> sorry NACK

:) When we tried to upstream the code setting up parent clocks in board files
some people disagreed on that too..

> 
> I do not want to rely on bootloader

Yeah, I don't believe this is best possible solution either..

> when we will have the DT we will pass it via it right now we need find an

I hope this can be be properly resolved with the DT. I thought there is not
much work
going on yet wrt supporting clocks hierarchy in DT though.


> other generic way
> 
> Best Regards,
> J.

-- 
Regards,
Sylwester
