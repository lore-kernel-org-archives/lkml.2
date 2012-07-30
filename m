Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab2G3Tp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:45:58 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41359 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754656Ab2G3Tpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:45:55 -0400
Message-ID: <5016C708.3090509@xenotime.net>
Date: Mon, 30 Jul 2012 10:40:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.4.0+ - Linus GIT -- drivers/built-in.o: In function `nouveau_acpi_edid':
 (.text+0x112337): undefined reference to `acpi_video_get_edid'
References: <CAHFgRy_gc0sbgp2O6r4jHiDpMu0nX-ZefgEtkma1et3HAKG5+A@mail.gmail.com>
In-Reply-To: <CAHFgRy_gc0sbgp2O6r4jHiDpMu0nX-ZefgEtkma1et3HAKG5+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:10 AM, Miles Lane wrote:

> I suspect this is due to a dependency not enforced in the Kconfig logic?
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `nouveau_acpi_edid':
> (.text+0x112337): undefined reference to `acpi_video_get_edid'




This build error still happens in Linux 3.5.
It is attempting to call a symbol in a loadable module from
a builtin driver.


CONFIG_ACPI_VIDEO=m
CONFIG_VIDEO_OUTPUT_CONTROL=m

If I use change CONFIG_VIDEO_OUTPUT_CONTROL to y,
CONFIG_ACPI_VIDEO also changes to y, so the relevant
functions are all builtin, and there is no build problem.


I guess that this line in drivers/gpu/drm/nouveau/Kconfig:

	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT

sets ACPI_VIDEO=m since VIDEO_OUTPUT_CONTROL=m, even though all of the
other symbols are =y.

xconfig tells me:

Selects: FW_LOADER [=y] && DRM_KMS_HELPER [=y] && DRM_TTM [=y] && FB_CFB_FILLRECT [=y] && FB_CFB_COPYAREA [=y] && FB_CFB_IMAGEBLIT [=y] && FB [=y] && FRAMEBUFFER_CONSOLE [=y] && FB_BACKLIGHT [=y] && ACPI_VIDEO [=m] && ACPI_WMI [=y] && MXM_WMI [=y] && POWER_SUPPLY [=y]




-- 
~Randy
