Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2KVSaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:30:12 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45010 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab2KVSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:30:06 -0500
Message-ID: <50AD4DE2.7080002@ilyx.ru>
Date: Thu, 22 Nov 2012 01:55:46 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>
Subject: Re: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
References: <50AD43DB.4030800@ilyx.ru> <20121121213037.154306da@pyramind.ukuu.org.uk>
In-Reply-To: <20121121213037.154306da@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.11.2012 1:30, Alan Cox wrote:
>> Function reset_buffer_flags() also invoked during the
>> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
>> and throttled driver too. If we don't unthrottle driver, we can get
>> forever throttled driver, because after request, we will have
>> empty buffers and throttled driver and there is no place to unthrottle driver.
>> It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
>> and other side do ioctl(...,TCFLSH,..). Then there is no place to do writers wake up.
>
>
> So instead of revertng it why not just fix it ? Just add an argument to
> the reset_buffer_flags function to indicate if unthrottling is permitted.
>
> Alan
>

Maybe we don't need call reset_buffer_flags() then execute tty_release() 
and (tty->count != 0)? Why in this case we reset buffers?
