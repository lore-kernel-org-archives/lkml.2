Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1HOPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:13:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:51446 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1HOPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:13:46 -0400
Message-ID: <4E4937A4.5070204@linutronix.de>
Date: Mon, 15 Aug 2011 17:13:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for uevent
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de> <1313419901-13492-2-git-send-email-bigeasy@linutronix.de> <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
In-Reply-To: <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>>                return rc;
>>
>>        add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
>> -               (pdev->id_entry) ? pdev->id_entry->name : pdev->name);
>> +                       pdev->name);
> 
> Yes, this looks like the right thing to do to me.  Also, I think the
> original code is suspect because it causes the uevent data to be
> different after binding a driver to a device.

Why different? The code matches (pdev->name == id->name) or
(pdev->name ==  driver->name) so in both cases it should be equal to
pdev->name.

Are you or Greg taking this?

> g.

Sebastian
