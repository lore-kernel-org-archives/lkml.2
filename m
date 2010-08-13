Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401Ab0HMJPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:15:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:33558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379Ab0HMJO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:14:59 -0400
Subject: Re: [PATCH] ideapad-laptop: add new driver
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 10:14:53 +0100
Message-ID: <1281690893.23680.475.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 12:08 +0800, Ike Panhc wrote:
> 
> The driver will bind on ACPI HID:VPC2004. When hotkey pressed, the
> notify
> function will be called and query EC to tell which key pressed.
> 
> Hotkeys enabled listed below:
>  * LCD backlight switch - reports KEY_DISPLAY_OFF
>  * One key restore - reports KEY_PROG1
>  * Brightness Up/down - reports KEY_BRIGHTNESS_CYCLE
>    Both up/down keys reports the same event. Need to find other way to
> detect
>  * Touchpad switch - reports KEY_F13
>  * Video output switch - reports KEY_SWITCHVIDEOMODE
>  * Camera switch - reports KEY_CAMERA
>  * Video resolution switch - reports KEY_VIDEO_NEXT
>  * S/W rfkill key - reports KEY_WLAN 

Hm, interesting. What model (and BIOS version) are you testing with?

On my S10-3, (DMI BIOS version 2ACN23WW, date 03/12/2010), I get these
keys through the normal keyboard controller -- and we can tell the
brightness up/down apart, too.

http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=9cd075e3

Do you see those keycodes too... and do they *stop* arriving through the
keyboard controller when you load your driver?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

