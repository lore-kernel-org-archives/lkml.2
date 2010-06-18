Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074Ab0FRL72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:59:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761043Ab0FRL70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:59:26 -0400
Date: Fri, 18 Jun 2010 13:59:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] HID: Documentation for hidraw
In-Reply-To: <1276832283-12084-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1006181353120.13809@pobox.suse.cz>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Alan Ott wrote:

> Documenation for the hidraw driver.

Thanks a lot for writing this up, Alan. It's something that has been 
lingering on my TODO for just too long, it's great that someone finally 
got fed up with it and wrote it :)

> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  The information in this patch relies on:
>   [PATCH v2] HID: Add Support for Setting and Getting Feature  Reports from hidraw
>   which has been applied by Jiri Kosina.
> 
>  Please provide comments. I'm sure someone here will have a better idea where
>  to put this than the root of Documentation/. I didn't see a better place, as
>  hidraw is used for both Bluetooth and USB.

Either Documentation/input comes to mind, or we could even establish 
Documentation/hid directory as well.

>  Documentation/hidraw.txt |  283 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 283 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hidraw.txt
> 
> diff --git a/Documentation/hidraw.txt b/Documentation/hidraw.txt
> new file mode 100644
> index 0000000..7153a06
> --- /dev/null
> +++ b/Documentation/hidraw.txt
> @@ -0,0 +1,283 @@
> +      HIDRAW - Raw Access to USB and Bluetooth Human Interface Devices 
> +     ==================================================================
> +
> +The hidraw driver provides a raw interface to USB and Bluetooth Human
> +Interface Devices (HIDs).  It differs from hiddev in that reports sent and
> +received are not parsed by the HID parser, but are sent to and received from
> +the device unmodified.

The important point behind hidraw (compared to hiddev), always has been 
that it's in fact completely independent on underlying hardware transport 
protocol. Currently there are no other implementations of HID than the 
ones using Bluetooth or USB, but there is no general obstacle to using 
hidraw once any vendor comes with HID-over-FibreChannel :) for example.

This basic principle might be worth mentioning as well.

> +Hidraw should be used if the userspace application knows exactly how to
> +communicate with the hardware device, and is able to construct the HID
> +reports manually.  This is often the case when making userspace drivers for
> +custom HID devices.
> +
> +Hidraw is also useful for communicating with non-conformant HID devices
> +which send and receive data in a way that is inconsistent with their report
> +descriptors.  Because hiddev parses reports which are sent and received
> +through it and checks them against the device's report descriptor, such
> +communication with these non-conformant devices is impossible using hiddev.

hidraw is just one of the alternatives here of course. Writing in-kernel 
driver also can be done to overcome these obstacles.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
