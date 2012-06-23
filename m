Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2FWS0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:26:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52563 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2FWS0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120621143950.GA1818@kroah.com>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
	<20120620235503.GA31520@kroah.com>
	<CAHdPZaMfVz82_Rk1ywtX+Y95a3JsvjHGxUA1YJovQmmAQxn-OA@mail.gmail.com>
	<20120621143950.GA1818@kroah.com>
Date: Sat, 23 Jun 2012 23:56:15 +0530
Message-ID: <CAHdPZaPM1mY6axH47WUjmkTKsSRSn+YpT8R7DmL9_r4rfPqUFg@mail.gmail.com>
Subject: Re: [PATCH] drivers/w1: free the w1_master at w1_free_dev and return
 a correct return value
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
On Thu, Jun 21, 2012 at 8:09 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 21, 2012 at 10:14:53AM +0530, devendra.aaru wrote:
>> Hi Greg,
>>
>> Yeah, correct but the following change is correct no?
>>
>>  int w1_add_master_device(struct w1_bus_master *master)
>> @@ -148,7 +149,7 @@ int w1_add_master_device(struct w1_bus_master *master)
>>                &w1_master_driver, &w1_master_device);
>>        if (!dev) {
>>                mutex_unlock(&w1_mlock);
>> -               return -ENOMEM;
>> +               return -ENODEV;
>
> Possibly, care to resend it in a format that explains it and allows it
> to be applied?
>
I think i need to go through the kernel doc, and figure out what
should be returned and why.
I think we need to send -EINVAL as most of the drivers does if their
registration fails.

It may take more time to send the patch out :(. sorry.
> thanks,
>
> greg k-h

Thanks,
Devendra.
