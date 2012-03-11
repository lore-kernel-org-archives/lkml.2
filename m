Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2CKVeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:34:23 -0400
Received: from toro.web-alm.net ([62.245.132.31]:41330 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab2CKVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:34:18 -0400
Message-ID: <4F5D17CA.5010308@osadl.org>
Date: Sun, 11 Mar 2012 22:23:22 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers-gpu-drm-allow-to-load-edid-firmware.patch
References: <20120310202014.828058552@osadl.org>	<20120310202241.764367925@osadl.org> <20120311134405.05942964@pyramind.ukuu.org.uk>
In-Reply-To: <20120311134405.05942964@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 02:44 PM, Alan Cox wrote:
>> This patch allows to load an EDID data set via the firmware interface.
>> It contains data sets of frequently used screen resolutions (1024x768,
>> 1280x1024, 1680x1050 and 1920x1080). The requested EDID data are
>> specified as a module parameter of the drm_kms_helper module, e.g.
>> options drm_kms_helper edid_firmware=edid/1280x1024.bin or as kernel
>> command line parameter.
>
> What if the DRM layer and driver are compiled in. They'll come up as
> console before the file system so the firmware request will hang ?
Admittedly I did not try to compile the DRM layer and driver into the 
kernel. However, I created an error condition by specifying a 
non-existing EDID file. In this case, the function returns with error, 
the mode count remains 0, and the system continues to run as if the 
edid_firmware= parameter had not been specified.

Now that you were asking, I created a static kernel and did some more 
tests, but I couldn't find any problem. Everything worked as expected. I 
believe that the early console still runs in BIOS VGA mode, i.e. either 
using the BIOS default mode or the one that was specified using the vga= 
parameter, if any. DRM apparently comes into play at a later stage only, 
but I will do some more testing.

> Given the EDID is tiny and is data not code wouldn't it be simpler (and
> smaller) if this option compiled in a few generic EDIDs to use ?
Yes, this certainly would be possible. However, we would loose the 
flexibility to specify an individual EDID data set without recompiling 
the kernel. As an alternative, we could compile the four standard EDIDs 
into the DRM helper instead of providing them as a file, but still leave 
the option to load an individual EDID via the firmware interface. This 
would make the patch much smaller and avoid spamming the firmware 
directory. How about that?

Thanks,
	-Carsten.
