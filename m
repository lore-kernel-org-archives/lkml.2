Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0HDBYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:24:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:52674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0HDBYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:24:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,312,1278313200"; 
   d="scan'208";a="592682436"
Subject: Re: [PATCH] ACPI / PM: Traverse video_device_list for backlight
 restoration
From: Zhang Rui <rui.zhang@intel.com>
To: Matthias Hopf <mhopf@suse.de>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Oliver Neukum <oneukum@suse.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100803101157.GA29721@suse.de>
References: <20100803100505.GA26948@suse.de>
	 <20100803101157.GA29721@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:27:29 +0800
Message-ID: <1280885249.1779.97.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 18:11 +0800, Matthias Hopf wrote:
> A bit of background about this patch:
> 
> 
> acpi_video_bus_get_devices() explicitly calls acpi_video_device_enumerate()
> before acpi_video_bus_get_one_device(), which does acpi_video_device_bind().
> 
> In _enumerate(), active_list[] is created, with .bind_info explicitly set to
> NULL, while the related .bind_info entry in video_device_list is set to the
> acpi_video_device ptr in _bind().
> 
> The .bind_info is later used in acpi_video_resume() to re-set the backlight
> - but it's only evaluated on the active_list[], on which all .bind_info are
> NULL by construction.

why? .bind_info in active_list is initialized in acpi_video_device_bind.

>   This results in backlight not being restored, if the
> BIOS doesn't do this by itself already.
> 
> 
> The patch resolves this by replacing the active_list[] traversal by a
> video_device_list traversal,

>  but due to the nature of the issue I'm unsure
> whether the original issue isn't of more principal quality.


> I don't understand
> why the list is (partially) transformed into an array in the first place,
> especially as both the array *and* the list are used in the code...
> 
no, the active_list is an array in fact, which equals
acpi_video_bus->attached_array. Maybe we need to change it to a more
proper name.

I'm still wondering why the patch works for you.
could you please attach the acpidump output of this laptop?

please rebuild your kernel with CONFIG_ACPI_DEBUG=y, and reboot with
kernel parameter "acpi.debug_layer=0x10 acpi.debug_level=0x400".
and attach the dmesg output after resume, both w/ and w/o the patch you
attached.

thanks,
rui


