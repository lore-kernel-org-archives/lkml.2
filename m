Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab1ELJ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:59:51 -0400
Received: from mx1.baidu.com ([61.135.163.61]:42343 "EHLO
	Tc-ite-Edge04.internal.baidu.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757038Ab1ELJ7u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:59:50 -0400
From: chenxi <chenxi05@baidu.com>
To: "'Maxin B John'" <maxin.john@gmail.com>
CC: <linux-kernel@vger.kernel.org>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com> <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
In-Reply-To: <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
Subject: =?utf-8?Q?=E7=AD=94=E5=A4=8D:_problem_with_kmemleak?=
Date: Thu, 12 May 2011 17:59:25 +0800
Message-ID: <009c01cc108b$4635c7d0$d2a15770$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwQiS/IJtQqztMDTJmHXwPuyQXDKQAAF8tg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thx, Maxin :)
ok
I did steps below:
1 make oldconfig 
2 vim .config
  ...
  CONFIG_DEBUG_FS = y
  CONFIG_DEBUG_KMEMLEAK = y
  CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE = 1200
  ...
3 make ; make modules ; and replace the kernel; reboot
4 mount -t debugfs debugfs /sys/kernel/debug
4 I wrote a module like this
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>

void myfunc(void)
{
        char *ptr;
        ptr = vmalloc(512);
        ptr = vmalloc(512);
        ptr = vmalloc(512);
}

int hello_init(void)
{
        printk(KERN_ALERT "Hello World");
        myfunc();
        return 0;
}

static void hello_exit(void)
{
        printk(KERN_ALERT "Goodbye World");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL v2");

5 clear the kmemleak
 Echo clear > /sys/kernel/debug/kmemleak
6 insmod the module
 Insmod xxx.ko
7 echo scan > /sys/kenel/debug/kmemleak
8 watch it
 Cat / sys/kenel/debug/kmemleak
 >> unreferenced object 0xffffc90012d27000 (size 64):
>>
>>  comm "insmod", pid 13092, jiffies 4298369684
>>
>>  hex dump (first 32 bytes):
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
And I can only get the backtrace [<ffffffffffffffff>]

BTW the kernel's version is 2.6.32.

Thx to Maxin again~~~:)
-----邮件原件-----
发件人: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] 代表 Maxin B John
发送时间: 2011年5月12日 17:44
收件人: ttlxzz ccc
抄送: linux-kernel@vger.kernel.org
主题: Re: problem with kmemleak

Hi,

Could you please share some more information about your setup ?

Regards,
Maxin

On Thu, May 12, 2011 at 4:13 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> help~~~：） please ！thx！！
>
> On Thu, May 12, 2011 at 10:06 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
>> Hi, all:
>>
>>
>>
>> I just want to use kmemleak, so I make the CONFIG_DEBUG_KMEMLEAK and
>> CONFIG_DEBUG_FS on, mount the debugfs.
>>
>> But when I insmod mm/kmemleak-test.ko, echo scan >
>> /sys/kernel/debug/kmemleak and cat /sys/kernel/debug/kmemleak. I just
>> see this:
>>
>> unreferenced object 0xffffc90012d21000 (size 64):
>>
>>  comm "insmod", pid 13092, jiffies 4298369684
>>
>>  hex dump (first 32 bytes):
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> unreferenced object 0xffffc90012d24000 (size 64):
>>
>>  comm "insmod", pid 13092, jiffies 4298369684
>>
>>  hex dump (first 32 bytes):
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> unreferenced object 0xffffc90012d27000 (size 64):
>>
>>  comm "insmod", pid 13092, jiffies 4298369684
>>
>>  hex dump (first 32 bytes):
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>
>>  backtrace:
>>
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> There is no other backtrace except [<ffffffffffffffff>]
>> 0xffffffffffffffff. Then I read the mm/kmemleak.c. In
>> kmemleak_seq_show(), I find that the object->trace_len is 1.
>>
>>
>>
>> How can I get the full backtrace?
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

