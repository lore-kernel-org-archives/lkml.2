Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2GEIox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:44:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37457 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2GEIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <201207050809.15834.arnd@arndb.de>
References: <1341469459-29558-1-git-send-email-Barry.Song@csr.com> <201207050809.15834.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 5 Jul 2012 16:44:31 +0800
Message-ID: <CAGsJ_4xXZBWYidO1RYMLJzb_iTS21wAv7HQqP-oeVVx8x336bw@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND] mm: cma: add a simple kernel module as the
 helper to test CMA
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        mina86@mina86.com, Barry Song <Baohua.Song@csr.com>,
        Barry Song <Barry.Song@csr.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

2012/7/5 Arnd Bergmann <arnd@arndb.de>:
>
> I think it should be in mm/cma-test.c, along with kmemleak-test.c. It would be nice
> if you could add some code that just runs at boot time (or when the module is
> loaded) and allocates and frees memory using CMA.
>
>> +static struct device *cma_dev;
>
> Do you actually need this device? It's not connected to hardware so
> it doesn't actually do DMA and we might as well pass a NULL pointer
> into dma_alloc_*().
>
>> +static const struct file_operations cma_test_fops = {
>> +     .owner =    THIS_MODULE,
>> +     .read  =    cma_test_read,
>> +     .write =    cma_test_write,
>> +};
>> +
>> +static struct miscdevice cma_test_misc = {
>> +     .name = "cma_test",
>> +     .fops = &cma_test_fops,
>> +};
>> +
>> +static int __init cma_test_init(void)
>> +{
>> +     int ret = misc_register(&cma_test_misc);
>
> A better place for this is really debugfs. The driver is not meant as a stable
> kernel interface that applications can rely on, it's purely a debugging help.
>
> Just make this
>
>         ret = debugfs_create_file("cma-test", 0600, NULL, NULL, &cma_test_fops);
>

we did have some discussions about this at:
http://www.spinics.net/lists/arm-kernel/msg163548.html

i'd say both are acceptable to me.

>         Arnd
>

-barry
