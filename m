Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0IVKCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:02:35 -0400
Received: from daytona.panasas.com ([67.152.220.89]:43591 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751532Ab0IVKCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:02:34 -0400
Message-ID: <4C99D436.700@panasas.com>
Date: Wed, 22 Sep 2010 12:02:30 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error handling
References: <1284900889-24369-1-git-send-email-segooon@gmail.com> <20100921152031.30365b3f.akpm@linux-foundation.org> <20100921224947.GA20183@kroah.com> <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
In-Reply-To: <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2010 10:02:33.0757 (UTC) FILETIME=[46CD84D0:01CB5A3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 10:53 AM, Kay Sievers wrote:
> On Wed, Sep 22, 2010 at 00:49, Greg KH <greg@kroah.com> wrote:
> 
>>  int device_register(struct device *dev)
>>  {
>> +       int retval;
>> +
>>        device_initialize(dev);
>> -       return device_add(dev);
>> +       retval = device_add(dev);
>> +       if (retval)
>> +               put_device(dev);
>> +       return retval;
>>  }
> 
>> Kay, what am I missing here, why can't we just do this?  Hm, the
>> side-affect might be that if device_register() fails, NO ONE had better
>> touch that device again, as it might have just been freed from the
>> system.  I wonder if that will cause problems...
> 
> That looks right, besides that there might be callers already doing
> this. Which needs to be checked.
> 
> I never liked this pretty useless "convenience API", which just wraps
> two simple functions and the first one can never fail anyway.
> 
> We better remove that device_register() stuff entirely in the long
> run, it's not doing any good. At the kobject level we killed the same
> stuff already long ago.
> 

That would be fine, and ping me when you do it, I'll help with my
driver. But don't forget to let us have a way to embed a device inside
a bigger structure.

For meanwhile Please check the patch James sent to add_device that cleans
up the allocation of the kobj.name member. (And the comment made there)

> Kay

Thanks
Boaz
