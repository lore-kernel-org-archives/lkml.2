Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713Ab2JaSEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:04:20 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:58809 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965470Ab2JaSEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:04:15 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121031175219.GH12739@atomide.com>
Date: Wed, 31 Oct 2012 20:04:05 +0200
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Oct 31, 2012, at 7:52 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
>> It is painless to move the adapter DT devices to arch/arm/mach-omap2
>> 
>> However I got bit by the __init at omap_build_device family functions.
>> If you don't remove it, crashes every time you instantiate a device
>> at runtime, or you load the cape driver as a module.
> 
> Hmm I think you misunderstood me. You only need to create the
> platform_device under arch/arm/mach-omap2. The device creation
> happens only at __init, so omap_build_device can stay as __init.
> The driver itself should be under drivers.
> 
> But is this bus on non-device-tree omaps? If not, just make it
> device tree only.
> 

I'm afraid that's not the case. The whole notion of capebus is that
instantiation of the devices doesn't just happen early at the boot
sequence.

It is perfectly valid for a cape to be instantiated via loading
a module, or by making an override by writing a sysfs file.

When having the __init there, the function has been long removed
and you get a crash by calling into the weeds.

So the sequence is:

<early boot>       Register the adapter driver.

<user>             insmod bone-geiger-cape
<cape-is-matched>  call omap_build_device

Please look into the capebus patches for the details. 

> Regards,
> 
> Tony

Regards

-- Pantelis

