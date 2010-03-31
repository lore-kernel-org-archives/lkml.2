Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab0CaJ2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:28:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab0CaJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:28:33 -0400
Date: Wed, 31 Mar 2010 11:28:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v6 0/8] hid: new driver for PicoLCD device
In-Reply-To: <20100330223224.18fe4f3e@neptune.home>
Message-ID: <alpine.LNX.2.00.1003311125090.24576@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home> <20100324234022.0361bd80@neptune.home> <20100326065656.GC26602@core.coreip.homeip.net> <20100326102951.3b9ecda1@neptune.home> <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz> <20100327012245.0ace6a09@neptune.home>
 <alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz> <20100329121611.0c22dcaf@pluto.restena.lu> <alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz> <20100330223224.18fe4f3e@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Bruno Prémont wrote:

> > so please either remove the parts that depend on power management for
> > now, or I'll wait on your respin of the generic HID-PM patch.
> 
> Here I respin the whole series, with PM moved to patch n°8 and
> patch n°7 being my original generic HID-PM.

Thanks!

> Without the PM part there is one compiler warning about defined but 
> unused function (picolcd_resume_backlight), I hope this is not an issue. 
> If it is that function can move over to the PM patch (with it's stub for 
> !CONFIG_BACKLIGHT_CLASS_DEVICE case)

It's actually picolcd_suspend_backlight(), the resume function is called 
from debugfs-triggered reset write.

I have removed it from the patch for now, it should better be added when 
being used (i.e. when the proper PM support goes in as well).

> So for now you can skip the last two patches during merge.

I have applied patches 1-6 to my tree. So please base any further 
additions to the driver on the version that's in my tree now (picolcd and 
for-next branches).

> Do you have any suggestions regarding generic HID-PM as to how much
> and how it should be visible to the HID driver?

I will look into the patch you have sent and comment on that shortly 
separately.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
