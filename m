Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0LGOrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:47:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0LGOrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:47:18 -0500
Date: Tue, 7 Dec 2010 15:47:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Valentine Barshak <vbarshak@mvista.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: HID: Fix race between disconnect and
 hiddev_ioctl
In-Reply-To: <20101206145141.GA8462@mvista.com>
Message-ID: <alpine.LNX.2.00.1012071546040.14806@pobox.suse.cz>
References: <20101206145141.GA8462@mvista.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Valentine Barshak wrote:

> A USB HID device can be disconnected at any time.
> If this happens right before or while hiddev_ioctl is in progress,
> the hiddev_ioctl tries to access invalid hiddev->hid pointer.
> When the hid device is disconnected, the hiddev_disconnect()
> ends up with a call to hid_device_release() which frees
> hid_device, but doesn't set the hiddev->hid pointer to NULL.
> If the deallocated memory region has been re-used by the kernel,
> this can cause a crash or memory corruption.
> 
> Since disconnect can happen at any time, we can't initialize
> struct hid_device *hid = hiddev->hid at the beginning of ioctl
> and then use it.
> 
> This change checks hiddev->exist flag while holding
> the existancelock and uses hid_device only if it exists.

The code duplication isn't really particularly nice, but I don't see any 
way around it that wouldn't complicate things even more.

I will be applying the patches, thanks.

(BTW your patches didn't reach mail mailbox, I had to dig them out from 
mailinglist -- did you receive bounces by any chance?).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
