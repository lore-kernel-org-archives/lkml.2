Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2EaIOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:14:09 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:39335 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757967Ab2EaIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <201205301843.51568.arnd@arndb.de>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
	<201205301843.51568.arnd@arndb.de>
Date: Thu, 31 May 2012 13:44:04 +0530
Message-ID: <CAAe_U6LFFstds=iQ7cy7gM9vWbfRgf5z0gaRp_-bu0Qjx6eA1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, May 31, 2012 at 12:13 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 30 May 2012, Kishon Vijay Abraham I wrote:
>>
>> This patch series is done as a preparatory step for adding phy drivers
>> for dwc3 and musb.
>>
>> This series adds a new driver for ocp2scp to which phy drivers are connected.
>>
>> I'm planning to send phy drivers asap. Meanwhile I'd like to get some
>> review comments for this series. I have also plans to send device tree
>> adaptation of the ocp2scp driver.
>>
>> Developed on
>> http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next
>>
>> If it has to be based on some other tree, please let me know.
>
> This must be the most pointless driver I've seen in a long time. It doesn't
> actually do anything at all, it just creates child devices from a static
> lookup table.
>
> Just put the devices you actually want into the device tree instead and
> have them automatically created.

But shouldn't device tree support and non-device tree support co-exist
till the non-device tree is completely knocked out of the kernel? Even
then shouldn't there be a separate driver to extract the child nodes
of ocp2scp and create a device (using of_platform_populate)?
As far as I've seen, the devices are automatically created (by virtue
of of_platform_populate() in  mach-omap2/board-generic.c in omap case)
only for the devices that is connected to the system bus. For other
cases, the parent should be responsible for creating the child
devices.

Thanks
Kishon
