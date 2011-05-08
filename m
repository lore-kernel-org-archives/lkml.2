Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1EHNlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:41:45 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:58801 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab1EHNlo (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Sun, 8 May 2011 09:41:44 -0400
Message-Id: <4DC72A34020000230002C541@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Sun, 08 May 2011 07:41:40 -0600
From: "Joey Lee" <jlee@novell.com>
To: <melchior.franz@gmail.com>
Cc: <chris@chris-wilson.co.uk>, <dri-devel@lists.freedesktop.org>,
        "Joey Lee" <JLee@novell.com>, <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <4DC47937020000230002C446@novprvlin0050.provo.novell.com>
 <201105061823.07083@rk-nord.at> <201105072222.41807@rk-nord.at>
In-Reply-To: <201105072222.41807@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 六，2011-05-07 於 22:22 +0200，Melchior FRANZ 提到：
> * Melchior FRANZ -- Friday 06 May 2011:
> > last patch prevents the backlight from being turned off, but it also
> > breaks the brightness adjustment keys at runtime with acpi_osi=Linux.
> 
> It has turned out that acpi key events seem to be handled correctly
> and even the state of /sys/class/backlight/acer-wmi/brightness is

That's interesting for acer-wmi generated brightness interface when this
machine declare acpi brightness interface in DSDT.

> updated accordingly. The only problem is that this maintained

Does it work to you direct control brightness by access
by /sys/class/backlight/acer-wmi/brightness ?

> brightness state isn't applied to the actual backlight. It remains
> at highest level. Google pointed me to this workaround for another
> Acer notebook:
> 
>   https://help.ubuntu.com/community/AspireTimeline/Fixes#Alternative%20fix%20for%2010.10
> 
> This uses the acpid to write the brightness value to the display
> using setpci. And this works on my notebook as well (Acer Travelmate

As I remember, use setpci to control brightness is not recommended
because BIOS or ACPI will also touch brightness level. That will be
better control brightness by the function that was provided by BIOS. 
e.g. ACPI or WMI interface, or direct control by EC.

That means that will be better fix your Fn key control brightness like
before, you just need press Fn key to change brightness and don't need
have any workaround.

> 5735Z-452G32Mnss). Not pretty but better than nothing. Is Acer
> not able to build proper notebooks? Or is it a kernel bug?
> 
> m.

Looks like current status is we try to fix bko#31522 but the patch
causes your brightness no work by press Fn key even with acpi_osi=Linux.
Does it right?

Could you please also help to check:
	replace acpi_osi=Linux by acpi_osi="!Windows 2006"

Does it also works to you for backlight control?


Thank's
Joey Lee

