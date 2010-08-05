Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab0HEXBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:01:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51356 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934870Ab0HEXBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100803235631.GA17759@suse.de>
References: <4C58A7AA.8020007@codeaurora.org> <20100803235631.GA17759@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 5 Aug 2010 17:00:59 -0600
X-Google-Sender-Auth: co8lVIib9CHKP1pmjDV6O4AkOaQ
Message-ID: <AANLkTi=Mk_0en5ojVZaKrjw14DbY57agF4nztQfQrx1M@mail.gmail.com>
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of pseduo-platform 
	busses
To: Greg KH <gregkh@suse.de>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        damm@opensource.se, lethal@linux-sh.org, rjw@sisk.pl, dtor@mail.ru,
        eric.y.miao@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 5:56 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Aug 03, 2010 at 04:35:06PM -0700, Patrick Pannuto wrote:
>> @@ -539,12 +541,12 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
>>        * if the probe was successful, and make sure any forced probes of
>>        * new devices fail.
>>        */
>> -     spin_lock(&platform_bus_type.p->klist_drivers.k_lock);
>> +     spin_lock(&drv->driver.bus->p->klist_drivers.k_lock);
>>       drv->probe = NULL;
>>       if (code == 0 && list_empty(&drv->driver.p->klist_devices.k_list))
>>               retval = -ENODEV;
>>       drv->driver.probe = platform_drv_probe_fail;
>> -     spin_unlock(&platform_bus_type.p->klist_drivers.k_lock);
>> +     spin_unlock(&drv->driver.bus->p->klist_drivers.k_lock);
>>
>>       if (code != retval)
>>               platform_driver_unregister(drv);
>
> I'm guessing that this chunk can be applied now, right?

Yes, I agree.  This chunk makes sense independently of the rest of the patch.

g.
