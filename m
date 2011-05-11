Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1EKQPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:15:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48497 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1EKQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:14 -0400
Message-ID: <82D549BB195345A1A189D569952B387C@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105051612.18522.arnd@arndb.de> <FBFC0000E34D487086421780A0F5252A@subhasishg> <201105102344.58598.arnd@arndb.de>
In-Reply-To: <201105102344.58598.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 11 May 2011 14:58:23 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please look into implementing one of the three I suggested before
> you go off in another direction. In case of the third one, the idea
> was to configure the name of the device for each pru using sysfs,
> which then gets bound to the driver, which loads its own firmware
> as you do today. Only in the first two suggestions, the mfd driver
> would be responsible for loading the firmware.

Ok, thanks for the clarification.
Instead of passing the device name, will it be ok to pass the mfd_id.
The benefit will be that I can use the ID directly as an array
index for the mfd_cell entries.

Just to verify my understanding, all that's needs to be done is add
a sysfs entry at 
/sys/devices/platform/pruss_mfd/mfd_id

Writing to this entry would create the respective device.
Rewriting would unload the old (mfd_remove_device)
and reload the new device.
Reading may return the various devices and their name
aliases.
 
