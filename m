Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1EVPqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 11:46:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64338 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1EVPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 11:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DWAMW7pQ9/Xc+JgRsMVuMspCkuwWQOAApfv+IZJ5EdPogL0XRE9xbsqlJylpDDyea1
         7kF014poMR3s/P+FX0rlPnUXfAhfsas+RpADUWLZxrZfRmoI4eckWkP5mZcF/IFSyS0/
         BQjCYmHM0G/Z45lJ64pWP4tGnx3rn7YsSNFNo=
Message-ID: <4DD92FBB.2050601@gmail.com>
Date: Sun, 22 May 2011 10:46:03 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>	<20110519233958.GB18181@ponder.secretlab.ca>	<4DD66B8A.5040404@gmail.com> <201105201621.03801.arnd@arndb.de>	<4DD68614.6090209@gmail.com>	<a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>	<BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com> <20110521234725.GB17672@n2100.arm.linux.org.uk>
In-Reply-To: <20110521234725.GB17672@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 06:47 PM, Russell King - ARM Linux wrote:
> On Sat, May 21, 2011 at 11:42:34AM -0600, Grant Likely wrote:
>> Russell, it seems to me that the primary behaviour that amba_bus has
>> over platform_bus is the clock management, and secondarily
>> verification of the type of device by the device id.  Am I correct, or
>> am I missing something?
>
> It matches by vendor/device ID just like PCI does, and does the bus
> clock management and power management in a really nice way, which I
> doubt platform devices will ever do.
>

Matching by ID is just one aspect of PCI. AMBA devices require defining 
the base address and irq just like platform devices. Having the ID is 
optional on AMBA buses. In PCI the bus and devices are probe-able. For 
AMBA, the bus is not probe-able, only the devices (or maybe not).

I believe OMAP is doing clock and power mgt at the bus level for 
platform devices.

Rob
