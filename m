Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1ELMBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:01:24 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:43423 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1ELMBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iImwphsql7Ws3wxUHUinnyPC4KF9X/A+hO36gDqsm5WWoC4C6TZWCxzpXUhZsEGJ91
         Em+GbkZHWQwjKMwiJ20WxHTL4gIUp+x9upNeVTsiYLvzQV07JzLLhrOS5Xf+fX7FhgIr
         ZL5m3HIL8iMPBv8Q2eOW7LUKdUVRflmyKFz3Q=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
Date: Thu, 12 May 2011 20:01:21 +0800
Message-ID: <BANLkTim7d-szCHm1F2Hndiraa0u5795tbg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: ttlxzz ccc <boyzccc@gmail.com>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daniel:

    I remove the module and didn't happen any exception. and U can see
that memory leak of insmod has been found int the kmemleak log. So I
think it doesn't happen in the rmmod.
    Do you have other ideas, please?
    thank you~~:)
On Thu, May 12, 2011 at 7:16 PM, Daniel Baluta <daniel.baluta@gmail.com> wrote:
> On Thu, May 12, 2011 at 12:59 PM, chenxi <chenxi05@baidu.com> wrote:
>> Thx, Maxin :)
>> ok
>> I did steps below:
>> 1 make oldconfig
>> 2 vim .config
>>  ...
>>  CONFIG_DEBUG_FS = y
>>  CONFIG_DEBUG_KMEMLEAK = y
>>  CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE = 1200
>>  ...
>> 3 make ; make modules ; and replace the kernel; reboot
>> 4 mount -t debugfs debugfs /sys/kernel/debug
>> 4 I wrote a module like this
>>  #include <linux/init.h>
>>  #include <linux/module.h>
>>  #include <linux/kernel.h>
>>  #include <linux/vmalloc.h>
>>
>> void myfunc(void)
>> {
>>        char *ptr;
>>        ptr = vmalloc(512);
>>        ptr = vmalloc(512);
>>        ptr = vmalloc(512);
>> }
>>
>> int hello_init(void)
>> {
>>        printk(KERN_ALERT "Hello World");
>>        myfunc();
>>        return 0;
>> }
>>
>> static void hello_exit(void)
>> {
>>        printk(KERN_ALERT "Goodbye World");
>> }
>>
>> module_init(hello_init);
>> module_exit(hello_exit);
>>
>> MODULE_LICENSE("GPL v2");
>>
>> 5 clear the kmemleak
>>  Echo clear > /sys/kernel/debug/kmemleak
>> 6 insmod the module
>>  Insmod xxx.ko
>
> Can you please remove your module?
> I think the memory is leaked at unload time.
>
> thanks,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
