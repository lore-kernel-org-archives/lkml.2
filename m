Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1GYTDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:03:44 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1GYTDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:03:36 -0400
Date: Mon, 25 Jul 2011 21:03:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, grant.likely@secretlab.ca,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, abelay@mit.edu,
        eric.piel@tremplin-utc.net, x86@kernel.org, lm-sensors@lm-sensors.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, johnpol@2ka.mipt.ru,
        linux-watchdog@vger.kernel.org, rtc-linux@googlegroups.com,
        dz@debian.org, openipmi-developer@lists.sourceforge.net,
        evel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, rpurdie@rpsys.net,
        linux-crypto@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH 01/34] System Firmware Interface
Message-ID: <20110725210321.1e2f252e@endymion.delvare>
In-Reply-To: <1310994528-26276-2-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
	<1310994528-26276-2-git-send-email-prarit@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 09:08:15 -0400, Prarit Bhargava wrote:
> This patch introduces a general System Firmware interface to the kernel, called
> sysfw.
> 
> Inlcluded in this interface is the ability to search a standard set of fields,
> sysfw_lookup().  The fields are currently based upon the x86 and ia64 SMBIOS
> fields but exapandable to fields that other arches may introduce.  Also
> included is  the ability to search and match against those fields, and run
> a callback function against the matches, sysfw_callback().
> 
> Modify module code to use sysfw instead of old DMI interface.

This is a HUGE patch set. You'd need to have a good reason for such a
big and intrusive change, yet I see no such reason explained. I
understand that we _can_ abstract system information interfaces, but
just because we can doesn't mean we have to. I would at least wait for
a second DMI-like interface to be widely implemented and support before
any attempt to abstract, otherwise your design is bound to be missing
the target. And even then, you'd still need to convince me that there
is a need for a unified interface to access both backends at once. I
would guess that you know what backend is present on a system when you
try to identify it.

At this point, I see the work needed to review your patches, the risk
of regressions due to the large size of the patch set, but I don't see
any immediate benefit. Thus I am not going to look into it at all,
sorry.

-- 
Jean Delvare
