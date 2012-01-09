Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2AIHNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:13:04 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:41609 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab2AIHNB (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 9 Jan 2012 02:13:01 -0500
Subject: Re: Handling special keys in platform drivers
From: joeyli <jlee@suse.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, linux-input@vger.kernel.org,
        GLin@suse.com
In-Reply-To: <CAHR064jAJkQCd_Tsrx7NHe_RbaBbNcX4sMwy=zkZCZNUNo=fAw@mail.gmail.com>
References: <CAHR064jAJkQCd_Tsrx7NHe_RbaBbNcX4sMwy=zkZCZNUNo=fAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 15:09:15 +0800
Message-ID: <1326092955.24116.131.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin, 

於 一，2012-01-09 於 07:24 +0100，Corentin Chary 提到：
> Hi,
> 
> Some of the platform drivers in platform/x86/ (and probably other) are
> relaying keys to userspace and are also controlling the device
> associated to these key. A simple example is screen brightness,
> keyboard backlight or rfkill.
> 
> In this case the driver send a key to userspace, userspace has to
> handle this key and control the right device.
> 
> Most of the time, this job is done by:
> - ACPI scripts (legacy)
> - DE (gnome-power-manager, kde's solid)
> 
> The real problem is that for keyboard backlight to work, it needs DE
> cooperation, and only gnome as implemented that right now, and other
> (except KDE) will probably neither have the resources to handle all
> the possible keys correctly. And of course, who should handle the keys
> when there is no DE running at all ?
> 
> So I was wondering if we could introduce an "auto" mode for this
> drivers. For example, with this mode enabled, asus-wmi would filter
> the keys and control keyboard backlight directly (and rfkill/screen
> brightness ?).
> 
> What do you think about it ?
> 
> Thanks,
> 

For backlight, 
I think control backlight in platform driver is generally no problem,
but need careful don't keep/change brightness level if BIOS also keep a
variable reflect to brightness level.

Another question is when the "auto" mode disable? Does it possible
disable it from user space?
Currently, like rfkill-input can disabled by ioctl from user space, e.g.
urfkill daemon will disable rfkill-input by ioctl when it launched.


For rfkill,
I am not prefer allow platform driver direct control rfkill.

that might more complex because already have the follow components
involve to it when function key pressed:
	BIOS/EC (ODM backup behavior)
	rfkill-input
	wireless/bluetooth drivers
	user space daemon/applications (e.g. NetworkManager, urfkill...)

Then, will platform driver also involve to rfkill control?

We already have rfkill-input in kernel to control rfkill state, if need
more flexible policy control on rfkill key, put policy logic in user
space will be better.
e.g. User can setup rfkill policy by account.


Thanks a lot!
Joey Lee


