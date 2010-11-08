Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0KHLW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:22:29 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:54972 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0KHLW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:22:27 -0500
Subject: Re: [Intel-gfx] [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
	 <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 06:22:44 -0500
Message-ID: <1289215364.3916.400.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 05:54 -0500, Jon Masters wrote:

> Here is the EDID output after booting:
> 
> [jcm@monticello ~]$ hexdump /sys/class/drm/card0-LVDS-1/edid
> 0000000 ff00 ffff ffff 00ff 6422 03e9 8544 0001
> 0000010 141c 0301 1680 780d 860a 9426 5157 2790
> 0000020 4f21 0054 0000 0101 0101 0101 0101 0101
> 0000030 0101 0101 0101 1194 b000 5840 2019 2335
> 0000040 0045 81dc 0000 1900 1416 d800 5840 2026
> 0000050 235d 0415 81dc 0000 0000 0000 fe00 0000
> 0000060 0000 0000 0000 0000 0000 0000 0000 fe00
> 0000070 0000 0000 0000 0000 0100 0000 0000 f200
> 0000080

As I mentioned on IRC, I'm familiar with how I2C works electrically, and
therefore EDID implementation as a concept, but I am not really a
graphics hacker so I wasn't aware that you prefer edid-decode :)

Here is a decoded version of the output:

Extracted contents:
header:          00 ff ff ff ff ff ff 00
serial number:   22 64 e9 03 44 85 01 00 1c 14
version:         01 03
basic params:    80 16 0d 78 0a
chroma info:     86 26 94 57 51 90 27 21 4f 54
established:     00 00 00
standard:        01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
descriptor 1:    94 11 00 b0 40 58 19 20 35 23 45 00 dc 81 00 00 00 19
descriptor 2:    16 14 00 d8 40 58 26 20 5d 23 15 04 dc 81 00 00 00 00
descriptor 3:    00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00
descriptor 4:    00 00 00 fe 00 00 00 00 00 00 00 00 00 01 00 00 00 00
extensions:      00
checksum:        f2

Manufacturer: HSD Model 3e9 Serial Number 99652
Made week 28 of 2010
EDID version: 1.3
Digital display
Maximum image size: 22 cm x 13 cm
Gamma: 2.20
Supported color formats: RGB 4:4:4, YCrCb 4:2:2
First detailed timing is preferred timing
Established timings supported:
Standard timings supported:
Detailed mode: Clock 45.000 MHz, 220 mm x 129 mm
               1024 1077 1112 1200 hborder 0
                600  604  609  625 vborder 0
               -hsync -vsync
Detailed mode: Clock 51.420 MHz, 220 mm x 129 mm
               1024 1117 1152 1240 hborder 0
                600  617  622  638 vborder 0
               -hsync -vsync analog composite
ASCII string: ASCII string: Checksum: 0xf2
EDID block does NOT conform to EDID 1.3!
	Missing name descriptor
	Missing monitor ranges

If you send me a hacked up patch that dumps out whatever you want in the
kernel ringbugger, I'll build and run it for you. Presumably you are
expecting some of the reported geometry to vary, etc.

Here is the output from xrandr FWIW (but as I mentioned, this is
happening way before X gets its hands on the scene):

[jcm@monticello ~]$ xrandr --verbose
Screen 0: minimum 320 x 200, current 1024 x 600, maximum 4096 x 4096
LVDS1 connected 1024x600+0+0 (0x43) normal (normal left inverted right x
axis y axis) 220mm x 129mm
	Identifier: 0x41
	Timestamp:  337852
	Subpixel:   horizontal rgb
	Gamma:      1.0:1.0:1.0
	Brightness: 1.0
	Clones:    
	CRTC:       1
	CRTCs:      1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	EDID:
		00ffffffffffff002264e90344850100
		1c14010380160d780a86269457519027
		214f5400000001010101010101010101
		010101010101941100b0405819203523
		4500dc8100000019161400d840582620
		5d231504dc8100000000000000fe0000
		000000000000000000000000000000fe
		000000000000000000010000000000f2
	BACKLIGHT: 10 (0x0000000a)	range:  (0,10)
	Backlight: 10 (0x0000000a)	range:  (0,10)
	scaling mode:	Full aspect
		supported: None         Full         Center       Full aspect 
  1024x600 (0x43)   45.0MHz -HSync -VSync *current +preferred
        h: width  1024 start 1077 end 1112 total 1200 skew    0 clock
37.5KHz
        v: height  600 start  604 end  609 total  625           clock
60.0Hz
  1024x600 (0x44)   51.4MHz -HSync -VSync
        h: width  1024 start 1117 end 1152 total 1240 skew    0 clock
41.5KHz
        v: height  600 start  601 end  606 total  638           clock
65.0Hz
  800x600 (0x45)   40.0MHz +HSync +VSync
        h: width   800 start  840 end  968 total 1056 skew    0 clock
37.9KHz
        v: height  600 start  601 end  605 total  628           clock
60.3Hz
  800x600 (0x46)   36.0MHz +HSync +VSync
        h: width   800 start  824 end  896 total 1024 skew    0 clock
35.2KHz
        v: height  600 start  601 end  603 total  625           clock
56.2Hz
  640x480 (0x47)   25.2MHz -HSync -VSync
        h: width   640 start  656 end  752 total  800 skew    0 clock
31.5KHz
        v: height  480 start  490 end  492 total  525           clock
59.9Hz
VGA1 disconnected (normal left inverted right x axis y axis)
	Identifier: 0x42
	Timestamp:  337852
	Subpixel:   unknown
	Clones:    
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 

Jon.


