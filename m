Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2HUCwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 22:52:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47282 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2HUCwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 22:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120819164658.1737bb74@pyramind.ukuu.org.uk>
References: <1345400832-23572-1-git-send-email-shijie8@gmail.com>
	<20120819064429.GA3252@kroah.com>
	<20120819164658.1737bb74@pyramind.ukuu.org.uk>
Date: Tue, 21 Aug 2012 10:52:04 +0800
Message-ID: <CAMiH66GaSg4RHNyLg_9X49c1FbjKr2_ag=oiCSfv2HRSTd4Qiw@mail.gmail.com>
Subject: Re: [PATCH] serial: add a new helper function
From: Huang Shijie <shijie8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 11:46 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sat, 18 Aug 2012 23:44:29 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Sun, Aug 19, 2012 at 02:27:12PM -0400, Huang Shijie wrote:
>> > --- a/include/linux/tty.h
>> > +++ b/include/linux/tty.h
>> > @@ -43,6 +43,7 @@
>> >  #include <linux/tty_driver.h>
>> >  #include <linux/tty_ldisc.h>
>> >  #include <linux/mutex.h>
>> > +#include <linux/serial.h>
>> >
>> >
>> >
>> > @@ -513,6 +514,12 @@ static inline struct tty_port *tty_port_get(struct tty_port *port)
>> >     return port;
>> >  }
>> >
>> > +/* If the cts flow control is enabled, return true. */
>> > +static inline bool tty_port_cts_enabled(struct tty_port *port)
>> > +{
>> > +   return port->flags & ASYNC_CTS_FLOW;
>> > +}
>> > +
>>
>> The fact that you have to add serial.h to this file kind of implies that
>> this function shouldn't be here, right?
>>
>> How about serial.h instead?  Not all tty drivers are serial drivers :)
>
> tty_port is tty generic so possibly if there is a generic helper the
> flags and helper should likewise be this way.
>
> As it stands at the moment ASYNC_CTS_FLOW is a convention a few drivers
> use. So calling it tty_port_xxx is going to misleading.

this patch makes the header files in a mess.
Please just ignore this patch if it is not good enough.

thanks
Huang Shijie

>



> Alan
