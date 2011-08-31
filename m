Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1HaVBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:01:54 -0400
Received: from mail.ispras.ru ([83.149.199.43]:52997 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1HaVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:01:53 -0400
Message-ID: <45954.91.79.112.141.1314824511.squirrel@mail.ispras.ru>
In-Reply-To: <4E5E9D95.2050601@opengridcomputing.com>
References: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
    <4E5E9D95.2050601@opengridcomputing.com>
Date: Thu, 1 Sep 2011 01:01:51 +0400 (MSD)
Subject: Re: [PATCH] RDMA/cxgb4: remove accidentally left 
     mutex_unlock(&dev_mutex)
From: "Alexey Khoroshilov" <khoroshilov@ispras.ru>
To: "Steve Wise" <swise@opengridcomputing.com>
Cc: "Steve Wise" <swise@chelsio.com>, "Roland Dreier" <roland@kernel.org>,
        "Sean Hefty" <sean.hefty@intel.com>,
        "Hal Rosenstock" <hal.rosenstock@gmail.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Reply-To: khoroshilov@ispras.ru
User-Agent: SquirrelMail/1.4.8-5.el5_3.7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01 Sep 2011, 00:46 Steve Wise wrote:
> On 08/31/2011 03:43 PM, Alexey Khoroshilov wrote:
>> The patch "RDMA/cxgb4: EEH errors can hang the driver" removes
>> mutex lock/unlock from c4iw_alloc() except for error path.
>> This patch removes the remained mutex_unlock(&dev_mutex).
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>
>> ---
>>   drivers/infiniband/hw/cxgb4/device.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/device.c
>> b/drivers/infiniband/hw/cxgb4/device.c
>> index 40a13cc..35896ff 100644
>> --- a/drivers/infiniband/hw/cxgb4/device.c
>> +++ b/drivers/infiniband/hw/cxgb4/device.c
>> @@ -414,7 +414,6 @@ static struct c4iw_dev *c4iw_alloc(const struct
>> cxgb4_lld_info *infop)
>>
>>   	ret = c4iw_rdev_open(&devp->rdev);
>>   	if (ret) {
>> -		mutex_unlock(&dev_mutex);
>>   		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
>>   		ib_dealloc_device(&devp->ibdev);
>>   		return ERR_PTR(ret);
>
> This is actually included in my previously submitted patch:
>
> https://patchwork.kernel.org/patch/1026942/
>
> Steve.

Great.

--
Alexey

