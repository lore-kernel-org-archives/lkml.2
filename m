Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2HSHA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:00:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47840 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2HSHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120819064429.GA3252@kroah.com>
References: <1345400832-23572-1-git-send-email-shijie8@gmail.com>
	<20120819064429.GA3252@kroah.com>
Date: Sun, 19 Aug 2012 03:00:56 -0400
Message-ID: <CAMiH66ER7ZRBhdK1QS-vjihwEGmEA4Tdep_eLQHZjpeXU1am7g@mail.gmail.com>
Subject: Re: [PATCH] serial: add a new helper function
From: Huang Shijie <shijie8@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 2:44 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Aug 19, 2012 at 02:27:12PM -0400, Huang Shijie wrote:
>> --- a/include/linux/tty.h
>> +++ b/include/linux/tty.h
>> @@ -43,6 +43,7 @@
>>  #include <linux/tty_driver.h>
>>  #include <linux/tty_ldisc.h>
>>  #include <linux/mutex.h>
>> +#include <linux/serial.h>
>>
>>
>>
>> @@ -513,6 +514,12 @@ static inline struct tty_port *tty_port_get(struct tty_port *port)
>>       return port;
>>  }
>>
>> +/* If the cts flow control is enabled, return true. */
>> +static inline bool tty_port_cts_enabled(struct tty_port *port)
>> +{
>> +     return port->flags & ASYNC_CTS_FLOW;
>> +}
>> +
>
> The fact that you have to add serial.h to this file kind of implies that
> this function shouldn't be here, right?
>
> How about serial.h instead?  Not all tty drivers are serial drivers :)
OK.

thanks for so quick review.


Huang Shijie

>
> greg k-h
