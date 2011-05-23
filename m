Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1EWPaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:30:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab1EWPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:30:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Mon, 23 May 2011 17:30:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105151133.23870.arnd@arndb.de> <B876E8072D52496DB747D5CCCF64826D@subhasishg>
In-Reply-To: <B876E8072D52496DB747D5CCCF64826D@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231730.06564.arnd@arndb.de>
X-Provags-ID: V02:K0:478RQWIMiM93dEbI5P6QC8iY/5RIzLZBhVeQNLa84iT
 85ojAXJCpX22tmLo0VMJkBsLfND7QypGHt1NHwWNDsd4v+/Oy5
 IGWUYYw43cG696FcTyEVWfOvYWVlUeOM/4zrztgZYSxV8WRaPR
 6a3cxTwzxbl5lE6wtSJjZ1rIZzjCGA2UkOv8MdqBINlqAtoImA
 TWwUjzWvZVKvzIiKfAHMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 May 2011, Subhasish Ghosh wrote:
> I earlier had an implementation where I used a pruss_devices structure
> in the board file.
> 
> http://linux.omap.com/pipermail/davinci-linux-open-source/
> 2011-March/022339.html.
> 
> We can use this implementation along with the sysfs to load the devices
> runtime. 

Possibly, but the actual data structures might end up differently
when they are built around a sysfs interface. If you have a sysfs
interface, it is more important to have that in a clean way than
the board file, so we should first discuss the set of sysfs
attributes that you are going to need, and then see how to
represent that in platform data for predefined boards.

> The configs that I have in the board_file for the devices 
> structure, are fixed for a board. To swap the boards, we do not need to re-compile
> the kernel.

The other point to consider is that we are definitely moving
towards the flattened device tree for these definitions now.
It's probably good to make the sysfs attributes directly correspond
to fdt device properties. I'm not sure if we also need to allow platform
data. The easiest way could be to just require the use of device tree
for predefined pruss devices.

I'm sorry that this is moving in a different direction now, you
had an unfortunate timing here.

Let's first discuss the exact properties that are really required
to define the differences between PRU backends, as those will
be required in any case. What do you need for PRU specific
data besides the firmware and the name of the device?

	Arnd
