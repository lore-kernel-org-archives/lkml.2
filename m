Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2LQQGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:06:51 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55979 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2LQQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:06:48 -0500
Message-ID: <50CF4313.1010706@gmail.com>
Date: Mon, 17 Dec 2012 17:06:43 +0100
From: =?UTF-8?B?TWFyY29zIExvaXMgQmVybcO6ZGV6?= 
	<marcos.discalis@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about using new request_threaded_irq
References: <50CF361A.1030203@gmail.com> <20121217083759.0cbed418@lwn.net>
In-Reply-To: <20121217083759.0cbed418@lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I lot of thanks for you fast reply. It seem that i swap the mean of 
handler parameters, so i now see it correct. :).

Excuse for my newbie question.

handler is the primary handler, and if NULL a default primary handler is 
installed, and thread_fn is the thread handler.

I'm a bit confusing because i see a outdated page that talks about this 
new IRQ API, but now i see that it's very outdated:

http://lwn.net/Articles/302043/

Regards.


El 17/12/2012 16:37, Jonathan Corbet escribió:
> On Mon, 17 Dec 2012 16:11:22 +0100
> Marcos Lois Bermúdez <marcos.discalis@gmail.com> wrote:
>
>> For my understand if i call for example:
>>
>> request_threaded_irq(irqmum, NULL, irq_handle, IRQF_TRIGGER_FALLING,
>> DEVICE_NAME, priv);
>>
>> This seem to make a old Hard IRQ handler, and inside of this handler
>> sleep APIs can't be used, but i see some SPI drivers that seem to
>> register a IRQ of this form and make API calls that can sleep in the
>> handler.
>
> Not quite.  The prototype for request_threaded_irq() is:
>
> int request_threaded_irq(unsigned int irq, irq_handler_t handler,
> 			 irq_handler_t thread_fn, unsigned long irqflags,
> 			 const char *devname, void *dev_id)
>
> Note the presents of *two* handlers, called "handler" and "thread_fn".
> The first, "handler", is called in interrupt context; it's job is usually
> to quiet the device and return; it cannot sleep.  If it's return value is
> IRQ_WAKE_THREAD, the thread_fn() will be called in process context; it
> *can* sleep.  In the example you cite, there is no immediate handler, only
> the thread_fn(); the call to a blocking function from within the
> thread_fn() is correct.
>
> Hope that helps,
>
> jon
>
> Jonathan Corbet / LWN.net / corbet@lwn.net
>

