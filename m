Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1FXNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:41:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:40645 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1FXNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:41:16 -0400
Message-ID: <4E0493E0.9080701@windriver.com>
Date: Fri, 24 Jun 2011 09:40:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Libor Pechacek <lpechacek@suse.cz>
CC: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 006/247] USB: serial: handle Data Carrier Detect
 changes
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com> <1308849690-14530-7-git-send-email-paul.gortmaker@windriver.com> <20110624121337.GF20922@fm.suse.cz>
In-Reply-To: <20110624121337.GF20922@fm.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-24 08:13 AM, Libor Pechacek wrote:
> Hi Paul,
> 
>> @@ -726,6 +726,10 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
>>  		/* overrun is special, not associated with a char */
>>  		if (status & UART_OVERRUN_ERROR)
>>  			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
>> +		if (status & UART_DCD)
>> +			usb_serial_handle_dcd_change(port, tty,
>> +				   priv->line_status & MSR_STATUS_LINE_DCD);
>> +
>>  		tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
>>  							urb->actual_length);
>>  		tty_flip_buffer_push(tty);
> 
> The above code is mistakenly placed inside the "if (tty && urb->actual_length)"
> block.  Should be right after it.

Thanks -- that is one of those cases where what seems like the
"obvious choice" just so happens to also be the wrong one.  :(

In any case, I appreciate the review, it is now fixed.

Paul.

> 
> For kernels v2.6.31 - v2.6.34 use the following patch
> http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=commitdiff;h=6fe7015007299e14f5ea212a503bcba5958c7086
> 
> For kernels v2.6.35 - v2.6.37 use
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commitdiff;h=2631217445b84e5d31341eaaf6e7951bf8907f52
> 
> Libor
