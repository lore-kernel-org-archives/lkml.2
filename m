Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab2ASTsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:48:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49926 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2ASTsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:48:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120119171808.GB23144@ubuntu-macmini>
References: <20120119171808.GB23144@ubuntu-macmini>
Date: Thu, 19 Jan 2012 14:48:52 -0500
Message-ID: <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
Subject: Re: radeon issues on MacBook Pro 8,2
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:18 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> I'm seeing several issues related to the radeon driver on a MacBook Pro
> 8,2 with the following graphics card:
>
>  ATI Technologies Inc Whistler [AMD Radeon HD 6600M Series] [1002:6741]
>
> All problems were observed when using kernel version 3.2.1. None are
> seen when using fglrx.
>
>  1. Excessive power draw. When using the radeon driver ACPI reports a
>    power draw of about 30W on an idle desktop. Using fglrx brings this
>    number down to 15W.

The power saving features of the open source driver are not yet as
good as the closed source driver.  Please see the power management
section of this page (http://wiki.x.org/wiki/RadeonFeature) for more
info on the options currently available.

>
>  2. Occasional long delays when suspending. When this happens I see
>    messages like following in dmesg:
>
>      [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
>      [drm:atom_execute_table_locked] *ERROR* atombios stuck executing D44E (len 62, WS 0, PS 0) @ 0xD46A
>
>    Sometimes one of suspend or resume hangs completely, but I can't
>    tell which and am not sure whether or not it's related. I'm also
>    testing a Mac Mini with the exact same card which does not seem to
>    suffer from this issue.
>
>    I ran a bisections that identified f8d0edd (drm/radeon/kms: improve
>    DP detect logic) as introducing problems with suspend, and reverting
>    this patch on top of 3.2.1 does seem to eliminate both issues.
>

That patch doesn't really affect the modesetting paths directly; it
looks like a red herring to me.

>  3. When the LVDS panel is powered off and back on, the display
>    flickers, as if the backlight is cycling rapidly between low and
>    high brightness. If the panel is left on this effect gradually
>    lessens and is eventually no longer noticable. This is not seen with
>    fglrx.
>

For the sake of tracking this properly, it would probably be best to file a bug:
https://bugs.freedesktop.org
Product: DRI
Component: DRM/Radeon
What connectors does your card actually have on it?  Please attach a
copy of your dmesg output and vbios:
(as root)
(use lspci to get the bus id)
cd /sys/bus/pci/devices/<pci bus id>
echo 1 > rom
cat rom > /tmp/vbios.rom
echo 0 > rom

Also, keep in mind that this is a mac so it's likely there may be
wonky mac specific problems.

Alex

> Thanks,
> Seth
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
