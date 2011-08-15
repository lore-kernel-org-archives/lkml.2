Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1HOPSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:18:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53071 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1HOPSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:18:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E4937A4.5070204@linutronix.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de> <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
 <4E4937A4.5070204@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 15 Aug 2011 09:17:41 -0600
X-Google-Sender-Auth: G34_2sJ8eOge7oFQehEjrpQLHLM
Message-ID: <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for uevent
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 9:13 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Grant Likely wrote:
>>>
>>> --- a/drivers/base/platform.c
>>> +++ b/drivers/base/platform.c
>>> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct
>>> kobj_uevent_env *env)
>>>               return rc;
>>>
>>>       add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
>>> -               (pdev->id_entry) ? pdev->id_entry->name : pdev->name);
>>> +                       pdev->name);
>>
>> Yes, this looks like the right thing to do to me.  Also, I think the
>> original code is suspect because it causes the uevent data to be
>> different after binding a driver to a device.
>
> Why different? The code matches (pdev->name == id->name) or
> (pdev->name ==  driver->name) so in both cases it should be equal to
> pdev->name.
>
> Are you or Greg taking this?

This one is all Greg.

g.
