Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2DYXL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:11:28 -0400
Received: from toro.web-alm.net ([62.245.132.31]:58063 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab2DYXL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:11:27 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 19:11:27 EDT
Message-ID: <4F987ECF.3070306@osadl.org>
Date: Thu, 26 Apr 2012 00:46:39 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Michael Witten <mfwitten@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
References: <20120310202014.828058552@osadl.org>            <20120310202241.764367925@osadl.org>            <20120311134405.05942964@pyramind.ukuu.org.uk>            <4F5D17CA.5010308@osadl.org> <c2bca06f15de4d0f8e4f7973719c644a-mfwitten@gmail.com>
In-Reply-To: <c2bca06f15de4d0f8e4f7973719c644a-mfwitten@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

> On Sun, 11 Mar 2012 22:23:22 +0100, Carsten Emde wrote:
>> On 03/11/2012 02:44 PM, Alan Cox wrote:
>>>> This patch allows to load an EDID data set via the firmware interface.
>>>> It contains data sets of frequently used screen resolutions (1024x768,
>>>> 1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
>>>> specified as a module parameter of the drm_kms_helper module, e.g.
>>>> options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
>>>> command line parameter.
>>> What if the DRM layer and driver are compiled in. They'll come up as
>>> console before the file system so the firmware request will hang ?
>> Admittedly I did not try to compile the DRM layer and driver into the
>> kernel. However, I created an error condition by specifying a
>> non-existing EDID file. In this case, the function returns with error,
>> the mode count remains 0, and the system continues to run as if the
>> edid_firmware= parameter had not been specified.
> Unfortunately, as of at least last month, my system hangs when I try to
> use your feature (just as described by Alan Cox); the log shows that
> during the boot process, there is a one-minute hang:
>
>    [    0.175207] [drm] radeon: power management initialized
>    [   60.896507] [drm:edid_load] *ERROR* Requesting EDID firmware "edid/1920x1200.bin" failed (err=-2)
>
> Is there any way to make your feature smarter about its timing with
> relation to file system accessibility?
Sure.

Please copy your EDID data file to the directory "firmware/edid" of the 
kernel source tree, configure

CONFIG_EXTRA_FIRMWARE="edid/1920x1200.bin"
CONFIG_EXTRA_FIRMWARE_DIR="firmware"

and rebuild/reboot your kernel.

Does it work then?

	-Carsten.
