Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2CKU5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 16:57:22 -0400
Received: from toro.web-alm.net ([62.245.132.31]:41276 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2CKU5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 16:57:16 -0400
Message-ID: <4F5D0F13.2010204@osadl.org>
Date: Sun, 11 Mar 2012 21:46:11 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: David Airlie <airlied@linux.ie>, Thomas Gleixner <tglx@linutronix.de>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drivers-gpu-drm-add-disable-enable-connector.patch
References: <20120310202014.828058552@osadl.org>	<20120310202242.384865299@osadl.org> <CAPM=9tywM0_sroYKJxnZxXEZhcz3VfmG8eqSLUqpNHEdSwy_Qg@mail.gmail.com>
In-Reply-To: <CAPM=9tywM0_sroYKJxnZxXEZhcz3VfmG8eqSLUqpNHEdSwy_Qg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 08:20 AM, Dave Airlie wrote:
> On Sat, Mar 10, 2012 at 8:20 PM, Carsten Emde<C.Emde@osadl.org>  wrote:
>> Some recent integrated graphics chipset, notably Intel's "Pineview", also
>> provide on-chip LVDS support. As an extra service, the LVDS interface supplies
>> EDID data - irrespective of whether an LVDS panel is connected or not. The
>> drm_mode_getresources() function, therefore, causes Xorg to always include
>> the LVDS panel into the display and initialize a separate screen for it. e.g.
>> (II) intel(0): Output LVDS1 connected
>> (II) intel(0): Output VGA1 connected
>> (II) intel(0): Using spanning desktop for initial modes
>> (II) intel(0): Output LVDS1 using initial mode 1024x768 +0+0
>> (II) intel(0): Output VGA1 using initial mode 1280x1024 +1024+0
>> which is not what you want, if the only connected screen is a VGA monitor.
>> One would assume that the BIOS settings of such systems would allow to
>> separately enable or disable LVDS support; unfortunately, systems have been
>> found in the wild that do not provide this feature.
>
> So video=LVDS-1:d doesn't work for you?
Oops, yes, you are totally right. By some reason, I overlooked this 
option. I tried two systems that need forced disabling and enabling with
   video=LVDS-1:d video=VGA-1:e
which worked perfectly well.

So please skip this patch, sorry for the noise.

Thanks,
	-Carsten.
