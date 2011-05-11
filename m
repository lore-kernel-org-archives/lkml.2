Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1EKUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:04:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1EKUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:04:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 11 May 2011 22:03:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105102344.58598.arnd@arndb.de> <82D549BB195345A1A189D569952B387C@subhasishg>
In-Reply-To: <82D549BB195345A1A189D569952B387C@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112203.54838.arnd@arndb.de>
X-Provags-ID: V02:K0:7yy0UA0LoYPGE1Io8oIo+CMVpvvWpKZ0z1FhJCoJ/80
 BQBrKUOnLulVKRKAXX8d7uroII6/vCz3eJhe1HrgMpI1Ef8Uc8
 lto2IdKoq7NTdummzo+c0bvI4YainSg3p9p3Vk7FPnxghmuety
 FbaBwpsQ2LrtLOrtpa6+MfCiR00CaUstAv+AEsPyU0i6uupRav
 /ELH9XGi3MHcEPGGXJ4IA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 May 2011, Subhasish Ghosh wrote:
> > Please look into implementing one of the three I suggested before
> > you go off in another direction. In case of the third one, the idea
> > was to configure the name of the device for each pru using sysfs,
> > which then gets bound to the driver, which loads its own firmware
> > as you do today. Only in the first two suggestions, the mfd driver
> > would be responsible for loading the firmware.
> 
> Ok, thanks for the clarification.
> Instead of passing the device name, will it be ok to pass the mfd_id.
> The benefit will be that I can use the ID directly as an array
> index for the mfd_cell entries.

I think a device name would be clearer here, especially in order
to avoid conflicts when the list gets extended in different ways
depending on which kernel runs.

We had a little discussion at the Linaro Developer Summit about your
driver and mfd drivers in general. There was a general feeling among
some people (including me) that by the point you dynamically create
the subdevices, MFD is probably not the right abstraction any more,
as it does not provide any service that you need.

Instead, maybe you can simply call platform_device_register
at that stage to create the children and not use MFD at all.

Samuel, can you comment on this as well? Do you still see pruss
as an MFD driver when the uses are completely dynamic and determined
by the firmware loaded into it?

> Just to verify my understanding, all that's needs to be done is add
> a sysfs entry at 
> /sys/devices/platform/pruss_mfd/mfd_id
> 
> Writing to this entry would create the respective device.
> Rewriting would unload the old (mfd_remove_device)
> and reload the new device.

Yes

> Reading may return the various devices and their name
> aliases.

I would just return the current value. You might want to have two
files in sysfs, one per PRU, so you can set them individually.

	Arnd
