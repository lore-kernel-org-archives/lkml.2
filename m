Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423158Ab2CPQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:56:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35659 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031130Ab2CPQ4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <201203161732.17246.oliver@neukum.org>
References: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com>
	<201203161732.17246.oliver@neukum.org>
Date: Fri, 16 Mar 2012 22:26:20 +0530
Message-ID: <CAOD=uF4pJMousyB2FPrAF-H5nJ7W4p_NEkGdrOpT9xyLVHYQPg@mail.gmail.com>
Subject: Re: [PATCH] [media] staging: Return -EINTR in s2250_probe() if fails
 to get lock.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:02 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Freitag, 16. März 2012, 17:23:58 schrieb santosh nayak:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> In s2250_probe(), If locking attempt is interrupted by a signal then
>> it should return -EINTR after unregistering audio device and making free
>> the allocated memory.
>>
>> At present, if locking is interrupted by signal it will display message
>> "initialized successfully" and return success.  This is wrong.
>
> Indeed there's a lot wrong here. The idea of having an interruptible
> sleep in probe() is arcane. You need a very, very, very good reason for that.

Can you please explain why interruptible  sleep  should not be  in probe() ?
I am curious to know.


> The sane fix is using an uninterruptable sleep here.
>
> Second, while you are at it, fix the error case for no initialization
> due to a failing kmalloc(). You need to return -ENOMEM.

Are you talking about kmalloc or kzalloc ?
Because for failing kmalloc -ENOMEM is returned as shown below:

       state = kmalloc(sizeof(struct s2250), GFP_KERNEL);
        if (state == NULL) {
                i2c_unregister_device(audio);
                return -ENOMEM;     // ENOMEM is returned here.
        }


Regards
Santosh


>
>        Regards
>                Oliver
