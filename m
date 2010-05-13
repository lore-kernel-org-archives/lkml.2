Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0EMHsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:48:38 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38933 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0EMHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:48:36 -0400
Message-ID: <4BEBABA6.6040907@nokia.com>
Date: Thu, 13 May 2010 10:35:02 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?ext_Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: "Valkeinen Tomi (Nokia-D/Helsinki)" <Tomi.Valkeinen@nokia.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
       "paul@pwsan.com" <paul@pwsan.com>,
       "jpihet@mvista.com" <jpihet@mvista.com>,
       "kalle.valo@iki.fi" <kalle.valo@iki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: Buildfailure for omap3_defconfig due to patch OMAP: RX51: Add
 LCD Panel support
References: <201005122331.51347.PeterHuewe@gmx.de>
In-Reply-To: <201005122331.51347.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 May 2010 07:35:05.0109 (UTC) FILETIME=[CE11FC50:01CAF26E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

ext Peter Hüwe wrote:
> Hi Roger,
> 
> I just wanted to inform you that your Patch
> OMAP: RX51: Add LCD Panel support (b499d77834ae292465f8d06bb0a88f1a647dfa1a) 
> introduces a build failure for the omap3_defconfig.
> 
> You can see the error message here:
> http://kisskb.ellerman.id.au/kisskb/buildresult/2601981/
> 
> This is due to the fact that omap3_defconfig has
> CONFIG_MACH_NOKIA_RX51=y
> set which enables the compilation of arch/arm/mach-omap2/board-rx51.c
> 
> board-rx51.c calls rx51_video_mem_init in arch/arm/mach-omap2/board-rx51-
> video.c which is guarded by 
> #if defined(CONFIG_FB_OMAP2) || defined(CONFIG_FB_OMAP2_MODULE)
> 
> Unfortunately none if them is set in the omap3_defconfig.
> 
> Would be nice if you could fix this :)
> 
Thanks for pointing this out. Kevin Hilman had already informed me of this earlier.

The patch with the fix is here
https://patchwork.kernel.org/patch/98092/

Tomi has picked up the fixed patch in his tree in the for-next branch
http://gitorious.org/linux-omap-dss2/linux/commit/9585a7e56c51d224830adb29b1843310a87cd034

regards,
-roger
