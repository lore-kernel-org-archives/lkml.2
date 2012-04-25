Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2DYCcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:32:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58370 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776Ab2DYCcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:32:13 -0400
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
Date: Wed, 25 Apr 2012 02:30:32 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <c2bca06f15de4d0f8e4f7973719c644a-mfwitten@gmail.com>
In-Reply-To: <4F5D17CA.5010308@osadl.org>
References: <20120310202014.828058552@osadl.org>
            <20120310202241.764367925@osadl.org>
            <20120311134405.05942964@pyramind.ukuu.org.uk>
            <4F5D17CA.5010308@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 22:23:22 +0100, Carsten Emde wrote:

> On 03/11/2012 02:44 PM, Alan Cox wrote:
>
>>> This patch allows to load an EDID data set via the firmware interface.
>>> It contains data sets of frequently used screen resolutions (1024x768,
>>> 1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
>>> specified as a module parameter of the drm_kms_helper module, e.g.
>>> options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
>>> command line parameter.
>>
>> What if the DRM layer and driver are compiled in. They'll come up as
>> console before the file system so the firmware request will hang ?
>
> Admittedly I did not try to compile the DRM layer and driver into the 
> kernel. However, I created an error condition by specifying a 
> non-existing EDID file. In this case, the function returns with error, 
> the mode count remains 0, and the system continues to run as if the 
> edid_firmware= parameter had not been specified.

Unfortunately, as of at least last month, my system hangs when I try to
use your feature (just as described by Alan Cox); the log shows that
during the boot process, there is a one-minute hang:

  [    0.175207] [drm] radeon: power management initialized
  [   60.896507] [drm:edid_load] *ERROR* Requesting EDID firmware "edid/1920x1200.bin" failed (err=-2)

Is there any way to make your feature smarter about its timing with
relation to file system accessibility?

Sincerely,
Michael Witten
