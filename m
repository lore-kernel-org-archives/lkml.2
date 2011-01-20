Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1ATCiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:38:18 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10850 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1ATCiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:38:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70954458"
Message-ID: <4D37A016.8060902@codeaurora.org>
Date: Wed, 19 Jan 2011 18:38:14 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jamie Iles <jamie@jamieiles.com>, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org> <20110119082534.GA9569@gallagher> <4D3760DD.1010609@codeaurora.org> <20110119222407.GD6335@n2100.arm.linux.org.uk>
In-Reply-To: <20110119222407.GD6335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2011 2:24 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 19, 2011 at 02:08:29PM -0800, Stepan Moskovchenko wrote:
>>>> +		/* Mask conditions we're ignorning. */
>>>> +		sr&= port->read_status_mask;
>>>> +		if (sr&   UART_SR_RX_BREAK)
>>>> +			flag = TTY_BREAK;
>>>> +		else if (sr&   UART_SR_PAR_FRAME_ERR)
>>>> +			flag = TTY_FRAME;
>>> It doesn't look like the flag is used anywhere after it has been
>>> assigned.
>> An artifact of an old driver. Removed.
> But still required to support proper error signalling.
>

On second thought, from poking around the kernel some more, I believe 
the following should be a better approach:
         if (sr & UART_SR_RX_BREAK) {
             tty_insert_flip_char(tty, 0, TTY_BREAK);
         } else if (sr & UART_SR_PAR_FRAME_ERR) {
             tty_insert_flip_char(tty, 0, TTY_FRAME);
         }

Russell, what do you think? Shall I make the change in v2?

Thanks
Steve

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

