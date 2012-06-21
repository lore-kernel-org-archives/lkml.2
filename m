Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2FUEoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 00:44:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64592 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2FUEox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 00:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120620235503.GA31520@kroah.com>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
	<20120620235503.GA31520@kroah.com>
Date: Thu, 21 Jun 2012 10:14:53 +0530
Message-ID: <CAHdPZaMfVz82_Rk1ywtX+Y95a3JsvjHGxUA1YJovQmmAQxn-OA@mail.gmail.com>
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

On Thu, Jun 21, 2012 at 5:25 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Jun 17, 2012 at 09:47:59PM +0530, Devendra Naga wrote:
>> the w1_master pointer is allced at the w1_alloc_master and is not freed when called with
>> w1_remove_master.
>>
>> when w1_alloc_dev fails the return should be -ENODEV as it does
>> device_register, and that is the last case where that function
>> will fail.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>> ---
>>  drivers/w1/w1_int.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
>> index 6828835..a3cf27d 100644
>> --- a/drivers/w1/w1_int.c
>> +++ b/drivers/w1/w1_int.c
>> @@ -100,6 +100,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
>>  static void w1_free_dev(struct w1_master *dev)
>>  {
>>       device_unregister(&dev->dev);
>> +     kfree(dev);
>
> No, this is wrong, the memory will be freed in w1_master_release(),
> right?  It is not freed here, sorry, this patch is incorrect.
>
Yeah, correct but the following change is correct no?

 int w1_add_master_device(struct w1_bus_master *master)
@@ -148,7 +149,7 @@ int w1_add_master_device(struct w1_bus_master *master)
               &w1_master_driver, &w1_master_device);
       if (!dev) {
               mutex_unlock(&w1_mlock);
-               return -ENOMEM;
+               return -ENODEV;
       }


> greg k-h

Thanks,
Devendra.
