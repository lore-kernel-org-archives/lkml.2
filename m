Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2AUS43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:56:29 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45488 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829Ab2AUS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:56:23 -0500
Date: Sat, 21 Jan 2012 13:56:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [BUG] Intel HD Graphic QM57 chipset: Dell U3011 monitor turns to
	power saving mode
Message-ID: <20120121185621.GA31106@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:48:48 up 423 days, 23:51,  4 users,  load average: 0.09, 0.15,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell U3011 monitor turns to power saving mode when resolution set to 2560 x 1600
(intermittent)

Reproduced with:
Linux 2.6.38-1-amd64 (Debian kernel)
Linux 3.1.0-1-amd64  (Debian kernel)
Linux 3.2.0-1-amd64  (Debian kernel)

The computer is a Lenovo X201 Tablet (Intel QM57 chipset), on a X200
docking station. The docking station uses a DisplayPort cable to connect
to the monitor.  I tried upgrading my Bios from 1.34/1.13 to 1.38/1.14
(latest), which did not fix the problem. I cannot use anything else
than DisplayPort in this case to connect the monitor at 2560 x 1600,
because this resolution requires either the bandwidth provided by a
dual-link DVI (which I cannot connect in my docking station), or
DisplayPort.

The laptop Intel HD Graphic along with the X200 displayport is
documented to support this resolution (ref.
http://www.intel.com/products/notebook/chipsets/qm57/qm57-overview.htm).
The screen works at 2560 x 1600 resolution, but it takes many
attempts to get it to work. I usually need to restart the screen and
reboot the laptop a few times, and shutting down the LVDS screen of the
laptop seems to help (sometimes). Interesting fact, if I bring the LVDS
screen back up after that, I had a few successful cases where both
screens worked fine together. I sometimes had to close the lid of my
laptop, which puts it to sleep, and open it to find that the two screens
end up working correctly.

I run this in gnome 3.2 (in "classic" mode), setup with a resolution of
2560x1600 for the Dell 30", and 1280x800 for my laptop. Both DP1 and
LVDS1 displays are activated (dual-screen).

In my dmesg (3.2 kernel), I sometimes get this message when I power
cycle my monitor (in the cases where it does not work):

[ 3486.644818] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 182
[ 3486.644824] [drm:drm_edid_block_valid] *ERROR* Raw EDID:
[ 3486.644830] <3>00 ff ff ff ff ff ff 00 10 ac 65 40 34 34 30 31  ..........e@4401
[ 3486.644834] <3>15 01 04 b5 40 28 78 3a 8d 85 ad 4f 35 b1 25 0e  ....@(x:...O5.%.
[ 3486.644837] <3>50 54 a5 4b 00 71 4f 81 00 81 80 a9 40 d1 00 d1  PT.K.qO.....@...
[ 3486.644841] <3>40 01 01 01 01 e2 68 00 a0 a0 40 2e 60 30 20 36  @.....h...@.`0 6
[ 3486.644845] <3>00 81 91 21 00 00 1a 00 00 00 ff 00 50 48 35 4e  ...!........PH5N
[ 3486.644848] <3>59 31 43 39 30 34 34 4c 0a 00 00 00 fc 00 44 45  Y1C9044L......DE
[ 3486.644852] <3>4c 4c 20 55 33 30 31 31 0a 20 20 00 00 00 fd 00  LL U3011.  .....
[ 3486.644855] <3>31 56 1d 71 1c 00 0a 20 20 20 20 20 20 01 08 02  1V.q...      ...

I've also seen this other message (after a reboot):

[   52.638311] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting

The i915 and drm drivers are used (detailed dmesg at the bottom of this
email), with kms.

Xorg version:

% dpkg -l xorg
ii  xorg           1:7.6+10       X.Org X Window System
% dpkg -l xserver-xorg-video-intel
ii  xserver-xorg-v 2:2.17.0-1     X.Org X server -- Intel i8xx, i9xx display d
% dpkg -l gnome
ii  gnome                   1:3.0+6                 The GNOME Desktop Environment, with extra components


xrandr -q --verbose outputs are identical (except for "Timestamp"
fields) for the runs "fail" and "ok" detailed below.

% xrandr -q --verbose   # when the screen is in power saving mode (fail)

Screen 0: minimum 320 x 200, current 2560 x 1600, maximum 8192 x 8192
LVDS1 connected 1280x800+0+0 (0x45) normal (normal left inverted right x axis y axis) 261mm x 163mm
	Identifier: 0x41
	Timestamp:  779491
	Subpixel:   horizontal rgb
	Gamma:      1.0:1.0:1.0
	Brightness: 1.0
	Clones:    
	CRTC:       0
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	EDID:
		00ffffffffffff0030ae114000000000
		00130103801a1078ea2f158a58568f26
		18505400000001010101010101010101
		0101010101015c1d00f2502017303054
		360005a3100000195c1d00f250201730
		3054360005a3100000190000000f0081
		0a3c810a3c1e0a0000009e08000000fe
		0048563132315758362d3131300a0014
	BACKLIGHT: 15 (0x0000000f)	range:  (0,15)
	Backlight: 15 (0x0000000f)	range:  (0,15)
	scaling mode:	Full aspect
		supported: None         Full         Center       Full aspect 
  1280x800 (0x45)   75.2MHz -HSync -VSync *current +preferred
        h: width  1280 start 1328 end 1412 total 1522 skew    0 clock   49.4KHz
        v: height  800 start  803 end  809 total  823           clock   60.0Hz
  1024x768 (0x46)   65.0MHz -HSync -VSync
        h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz
        v: height  768 start  771 end  777 total  806           clock   60.0Hz
  800x600 (0x47)   40.0MHz +HSync +VSync
        h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9KHz
        v: height  600 start  601 end  605 total  628           clock   60.3Hz
  800x600 (0x48)   36.0MHz +HSync +VSync
        h: width   800 start  824 end  896 total 1024 skew    0 clock   35.2KHz
        v: height  600 start  601 end  603 total  625           clock   56.2Hz
  640x480 (0x49)   25.2MHz -HSync -VSync
        h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KHz
        v: height  480 start  490 end  492 total  525           clock   59.9Hz
VGA1 disconnected (normal left inverted right x axis y axis)
	Identifier: 0x42
	Timestamp:  779491
	Subpixel:   unknown
	Clones:    
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
HDMI1 disconnected (normal left inverted right x axis y axis)
	Identifier: 0x43
	Timestamp:  779491
	Subpixel:   unknown
	Clones:    
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	Broadcast RGB:	Full
		supported: Full         Limited 16:2
	audio:	auto
		supported: off          auto         on          
DP1 connected 2560x1600+0+0 (0x4a) normal (normal left inverted right x axis y axis) 641mm x 401mm
	Identifier: 0x44
	Timestamp:  779491
	Subpixel:   unknown
	Gamma:      1.0:1.0:1.0
	Brightness: 1.0
	Clones:    
	CRTC:       1
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	EDID:
		00ffffffffffff0010ac65404c343430
		31150104b54028783a8d85ad4f35b125
		0e5054a54b00714f81008180a940d100
		d14001010101e26800a0a0402e603020
		360081912100001a000000ff00504835
		4e593143393034344c0a000000fc0044
		454c4c2055333031310a2020000000fd
		0031561d711c000a2020202020200108
		02031df1509005040302071601061112
		1513141f20230d7f07830f0000023a80
		1871382d40582c450081912100001e01
		1d8018711c1620582c25008191210000
		9e011d007251d01e206e285500819121
		00001e8c0ad08a20e02d10103e960081
		91210000180000000000000000000000
		00000000000000000000000000000077
	Broadcast RGB:	Full
		supported: Full         Limited 16:2
	audio:	auto
		supported: off          auto         on          
  2560x1600 (0x4a)  268.5MHz +HSync -VSync *current +preferred
        h: width  2560 start 2608 end 2640 total 2720 skew    0 clock   98.7KHz
        v: height 1600 start 1603 end 1609 total 1646           clock   60.0Hz
  1920x1440 (0x4b)  234.0MHz -HSync +VSync
        h: width  1920 start 2048 end 2256 total 2600 skew    0 clock   90.0KHz
        v: height 1440 start 1441 end 1444 total 1500           clock   60.0Hz
  1920x1200 (0x4c)  193.2MHz -HSync +VSync
        h: width  1920 start 2056 end 2256 total 2592 skew    0 clock   74.6KHz
        v: height 1200 start 1203 end 1209 total 1245           clock   59.9Hz
  1920x1080 (0x4d)  148.5MHz +HSync +VSync
        h: width  1920 start 2008 end 2052 total 2200 skew    0 clock   67.5KHz
        v: height 1080 start 1084 end 1089 total 1125           clock   60.0Hz
  1600x1200 (0x4e)  162.0MHz +HSync +VSync
        h: width  1600 start 1664 end 1856 total 2160 skew    0 clock   75.0KHz
        v: height 1200 start 1201 end 1204 total 1250           clock   60.0Hz
  1280x1024 (0x4f)  135.0MHz +HSync +VSync
        h: width  1280 start 1296 end 1440 total 1688 skew    0 clock   80.0KHz
        v: height 1024 start 1025 end 1028 total 1066           clock   75.0Hz
  1280x1024 (0x50)  108.0MHz +HSync +VSync
        h: width  1280 start 1328 end 1440 total 1688 skew    0 clock   64.0KHz
        v: height 1024 start 1025 end 1028 total 1066           clock   60.0Hz
  1280x800 (0x51)   83.5MHz +HSync -VSync
        h: width  1280 start 1352 end 1480 total 1680 skew    0 clock   49.7KHz
        v: height  800 start  803 end  809 total  831           clock   59.8Hz
  1152x864 (0x52)  108.0MHz +HSync +VSync
        h: width  1152 start 1216 end 1344 total 1600 skew    0 clock   67.5KHz
        v: height  864 start  865 end  868 total  900           clock   75.0Hz
  1024x768 (0x53)   78.8MHz +HSync +VSync
        h: width  1024 start 1040 end 1136 total 1312 skew    0 clock   60.1KHz
        v: height  768 start  769 end  772 total  800           clock   75.1Hz
  1024x768 (0x46)   65.0MHz -HSync -VSync
        h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz
        v: height  768 start  771 end  777 total  806           clock   60.0Hz
  800x600 (0x54)   49.5MHz +HSync +VSync
        h: width   800 start  816 end  896 total 1056 skew    0 clock   46.9KHz
        v: height  600 start  601 end  604 total  625           clock   75.0Hz
  800x600 (0x47)   40.0MHz +HSync +VSync
        h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9KHz
        v: height  600 start  601 end  605 total  628           clock   60.3Hz
  640x480 (0x55)   31.5MHz -HSync -VSync
        h: width   640 start  656 end  720 total  840 skew    0 clock   37.5KHz
        v: height  480 start  481 end  484 total  500           clock   75.0Hz
  640x480 (0x56)   25.2MHz -HSync -VSync
        h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KHz
        v: height  480 start  490 end  492 total  525           clock   60.0Hz
  720x400 (0x57)   28.3MHz -HSync +VSync
        h: width   720 start  738 end  846 total  900 skew    0 clock   31.5KHz
        v: height  400 start  412 end  414 total  449           clock   70.1Hz


% xrandr -q --verbose   # when the screen works fine (ok)

Screen 0: minimum 320 x 200, current 2560 x 1600, maximum 8192 x 8192
LVDS1 connected 1280x800+0+0 (0x45) normal (normal left inverted right x axis y axis) 261mm x 163mm
	Identifier: 0x41
	Timestamp:  138701
	Subpixel:   horizontal rgb
	Gamma:      1.0:1.0:1.0
	Brightness: 1.0
	Clones:    
	CRTC:       0
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	EDID:
		00ffffffffffff0030ae114000000000
		00130103801a1078ea2f158a58568f26
		18505400000001010101010101010101
		0101010101015c1d00f2502017303054
		360005a3100000195c1d00f250201730
		3054360005a3100000190000000f0081
		0a3c810a3c1e0a0000009e08000000fe
		0048563132315758362d3131300a0014
	BACKLIGHT: 15 (0x0000000f)	range:  (0,15)
	Backlight: 15 (0x0000000f)	range:  (0,15)
	scaling mode:	Full aspect
		supported: None         Full         Center       Full aspect 
  1280x800 (0x45)   75.2MHz -HSync -VSync *current +preferred
        h: width  1280 start 1328 end 1412 total 1522 skew    0 clock   49.4KHz
        v: height  800 start  803 end  809 total  823           clock   60.0Hz
  1024x768 (0x46)   65.0MHz -HSync -VSync
        h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz
        v: height  768 start  771 end  777 total  806           clock   60.0Hz
  800x600 (0x47)   40.0MHz +HSync +VSync
        h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9KHz
        v: height  600 start  601 end  605 total  628           clock   60.3Hz
  800x600 (0x48)   36.0MHz +HSync +VSync
        h: width   800 start  824 end  896 total 1024 skew    0 clock   35.2KHz
        v: height  600 start  601 end  603 total  625           clock   56.2Hz
  640x480 (0x49)   25.2MHz -HSync -VSync
        h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KHz
        v: height  480 start  490 end  492 total  525           clock   59.9Hz
VGA1 disconnected (normal left inverted right x axis y axis)
	Identifier: 0x42
	Timestamp:  138701
	Subpixel:   unknown
	Clones:    
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
HDMI1 disconnected (normal left inverted right x axis y axis)
	Identifier: 0x43
	Timestamp:  138701
	Subpixel:   unknown
	Clones:    
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	Broadcast RGB:	Full
		supported: Full         Limited 16:2
	audio:	auto
		supported: off          auto         on          
DP1 connected 2560x1600+0+0 (0x4a) normal (normal left inverted right x axis y axis) 641mm x 401mm
	Identifier: 0x44
	Timestamp:  138701
	Subpixel:   unknown
	Gamma:      1.0:1.0:1.0
	Brightness: 1.0
	Clones:    
	CRTC:       1
	CRTCs:      0 1
	Transform:  1.000000 0.000000 0.000000
	            0.000000 1.000000 0.000000
	            0.000000 0.000000 1.000000
	           filter: 
	EDID:
		00ffffffffffff0010ac65404c343430
		31150104b54028783a8d85ad4f35b125
		0e5054a54b00714f81008180a940d100
		d14001010101e26800a0a0402e603020
		360081912100001a000000ff00504835
		4e593143393034344c0a000000fc0044
		454c4c2055333031310a2020000000fd
		0031561d711c000a2020202020200108
		02031df1509005040302071601061112
		1513141f20230d7f07830f0000023a80
		1871382d40582c450081912100001e01
		1d8018711c1620582c25008191210000
		9e011d007251d01e206e285500819121
		00001e8c0ad08a20e02d10103e960081
		91210000180000000000000000000000
		00000000000000000000000000000077
	Broadcast RGB:	Full
		supported: Full         Limited 16:2
	audio:	auto
		supported: off          auto         on          
  2560x1600 (0x4a)  268.5MHz +HSync -VSync *current +preferred
        h: width  2560 start 2608 end 2640 total 2720 skew    0 clock   98.7KHz
        v: height 1600 start 1603 end 1609 total 1646           clock   60.0Hz
  1920x1440 (0x4b)  234.0MHz -HSync +VSync
        h: width  1920 start 2048 end 2256 total 2600 skew    0 clock   90.0KHz
        v: height 1440 start 1441 end 1444 total 1500           clock   60.0Hz
  1920x1200 (0x4c)  193.2MHz -HSync +VSync
        h: width  1920 start 2056 end 2256 total 2592 skew    0 clock   74.6KHz
        v: height 1200 start 1203 end 1209 total 1245           clock   59.9Hz
  1920x1080 (0x4d)  148.5MHz +HSync +VSync
        h: width  1920 start 2008 end 2052 total 2200 skew    0 clock   67.5KHz
        v: height 1080 start 1084 end 1089 total 1125           clock   60.0Hz
  1600x1200 (0x4e)  162.0MHz +HSync +VSync
        h: width  1600 start 1664 end 1856 total 2160 skew    0 clock   75.0KHz
        v: height 1200 start 1201 end 1204 total 1250           clock   60.0Hz
  1280x1024 (0x4f)  135.0MHz +HSync +VSync
        h: width  1280 start 1296 end 1440 total 1688 skew    0 clock   80.0KHz
        v: height 1024 start 1025 end 1028 total 1066           clock   75.0Hz
  1280x1024 (0x50)  108.0MHz +HSync +VSync
        h: width  1280 start 1328 end 1440 total 1688 skew    0 clock   64.0KHz
        v: height 1024 start 1025 end 1028 total 1066           clock   60.0Hz
  1280x800 (0x51)   83.5MHz +HSync -VSync
        h: width  1280 start 1352 end 1480 total 1680 skew    0 clock   49.7KHz
        v: height  800 start  803 end  809 total  831           clock   59.8Hz
  1152x864 (0x52)  108.0MHz +HSync +VSync
        h: width  1152 start 1216 end 1344 total 1600 skew    0 clock   67.5KHz
        v: height  864 start  865 end  868 total  900           clock   75.0Hz
  1024x768 (0x53)   78.8MHz +HSync +VSync
        h: width  1024 start 1040 end 1136 total 1312 skew    0 clock   60.1KHz
        v: height  768 start  769 end  772 total  800           clock   75.1Hz
  1024x768 (0x46)   65.0MHz -HSync -VSync
        h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz
        v: height  768 start  771 end  777 total  806           clock   60.0Hz
  800x600 (0x54)   49.5MHz +HSync +VSync
        h: width   800 start  816 end  896 total 1056 skew    0 clock   46.9KHz
        v: height  600 start  601 end  604 total  625           clock   75.0Hz
  800x600 (0x47)   40.0MHz +HSync +VSync
        h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9KHz
        v: height  600 start  601 end  605 total  628           clock   60.3Hz
  640x480 (0x55)   31.5MHz -HSync -VSync
        h: width   640 start  656 end  720 total  840 skew    0 clock   37.5KHz
        v: height  480 start  481 end  484 total  500           clock   75.0Hz
  640x480 (0x56)   25.2MHz -HSync -VSync
        h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KHz
        v: height  480 start  490 end  492 total  525           clock   60.0Hz
  720x400 (0x57)   28.3MHz -HSync +VSync
        h: width   720 start  738 end  846 total  900 skew    0 clock   31.5KHz
        v: height  400 start  412 end  414 total  449           clock   70.1Hz

* The information I get with get-edid gives me a warning:

get-edid: get-edid version 2.0.0

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f00 bx=0x0 cx=0x0
	Function supported
	Call successful

	VBE version 300
	VBE string at 0x11100 "Intel(R)Ironlake Mobile Graphics Chipset
Accelerated VGA BIOS"

VBE/DDC service about to be called
	Report DDC capabilities

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f15 bx=0x0 cx=0x0
	Function supported
	Call successful

	Monitor and video card combination does not support DDC1
transfers
	Monitor and video card combination supports DDC2 transfers
	0 seconds per 128 byte EDID block transfer
	Screen is not blanked during DDC transfer

Reading next EDID block

VBE/DDC service about to be called
	Read EDID

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f15 bx=0x1 cx=0x0
	Function supported
	Call successful

[ ...skipping non-ascii chars... ]

*********** Something special has happened!
Please contact the author, Matthew Kern
E-mail: pyrophobicman@gmail.com
Please include full output from this program (especially that to stderr)



Reading next EDID block

VBE/DDC service about to be called
	Read EDID

	Performing real mode VBE call
	Interrupt 0x10 ax=0x4f15 bx=0x1 cx=0x0
	Function supported
	Call successful

[ ...skipping non-ascii chars... ]

EDID claims 1 more blocks left
EDID blocks left is wrong.
Your EDID is probably invalid.

* Running parse-edid on the output

parse-edid: parse-edid version 2.0.0
parse-edid: EDID checksum passed.

	# EDID version 1 revision 4
Section "Monitor"
	# Block type: 2:0 3:ff
	# Block type: 2:0 3:fc
	Identifier "DELL U3011"
	VendorName "DEL"
	ModelName "DELL U3011"
	# Block type: 2:0 3:ff
	# Block type: 2:0 3:fc
	# Block type: 2:0 3:fd
	HorizSync 29-113
	VertRefresh 49-86
	# Max dot clock (video bandwidth) 280 MHz
	# DPMS capabilities: Active off:yes  Suspend:no  Standby:no

	Mode 	"2560x1600"	# vfreq 59.972Hz, hfreq 98.713kHz
		DotClock	268.500000
		HTimings	2560 2608 2640 2720
		VTimings	1600 1603 1609 1646
		Flags	"-HSync" "+VSync"
	EndMode
	# Block type: 2:0 3:ff
	# Block type: 2:0 3:fc
	# Block type: 2:0 3:fd
EndSection


* Xorg.0.log

Here is a log where I finally got the Dell screen to work after power
cycling it about 10 times.

[    10.943] 
X.Org X Server 1.11.2.902 (1.11.3 RC 2)
Release Date: 2011-12-09
[    10.943] X Protocol Version 11, Revision 0
[    10.943] Build Operating System: Linux 3.1.0-1-amd64 x86_64 Debian
[    10.943] Current Operating System: Linux thinkos 3.2.0-1-amd64 #1 SMP Thu Jan 19 09:46:46 UTC 2012 x86_64
[    10.944] Kernel command line: BOOT_IMAGE=/vmlinuz-3.2.0-1-amd64 root=UUID=e8fc8b68-76d3-4320-8b40-97c2a2769495 ro quiet pcie_aspm=force
[    10.944] Build Date: 10 December 2011  09:55:45PM
[    10.944] xorg-server 2:1.11.2.902-1 (Cyril Brulebois <kibi@debian.org>) 
[    10.944] Current version of pixman: 0.24.0
[    10.944] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    10.944] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    10.944] (==) Log file: "/var/log/Xorg.0.log", Time: Sat Jan 21 11:32:54 2012
[    10.945] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    10.946] (==) No Layout section.  Using the first Screen section.
[    10.946] (==) No screen section available. Using defaults.
[    10.946] (**) |-->Screen "Default Screen Section" (0)
[    10.946] (**) |   |-->Monitor "<default monitor>"
[    10.947] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    10.947] (==) Automatically adding devices
[    10.947] (==) Automatically enabling devices
[    10.952] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[    10.952] 	Entry deleted from font path.
[    10.955] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    10.955] (==) ModulePath set to "/usr/lib/xorg/modules"
[    10.955] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    10.955] (II) Loader magic: 0x7f8641fcfae0
[    10.955] (II) Module ABI versions:
[    10.955] 	X.Org ANSI C Emulation: 0.4
[    10.955] 	X.Org Video Driver: 11.0
[    10.955] 	X.Org XInput driver : 13.0
[    10.955] 	X.Org Server Extension : 6.0
[    10.956] (--) PCI:*(0:0:2:0) 8086:0046:17aa:215a rev 2, Mem @ 0xf2000000/4194304, 0xd0000000/268435456, I/O @ 0x00001800/8
[    10.956] (II) Open ACPI successful (/var/run/acpid.socket)
[    10.956] (II) LoadModule: "extmod"
[    10.957] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    10.959] (II) Module extmod: vendor="X.Org Foundation"
[    10.959] 	compiled for 1.11.2.902, module version = 1.0.0
[    10.959] 	Module class: X.Org Server Extension
[    10.959] 	ABI class: X.Org Server Extension, version 6.0
[    10.959] (II) Loading extension SELinux
[    10.959] (II) Loading extension MIT-SCREEN-SAVER
[    10.959] (II) Loading extension XFree86-VidModeExtension
[    10.959] (II) Loading extension XFree86-DGA
[    10.959] (II) Loading extension DPMS
[    10.959] (II) Loading extension XVideo
[    10.959] (II) Loading extension XVideo-MotionCompensation
[    10.959] (II) Loading extension X-Resource
[    10.959] (II) LoadModule: "dbe"
[    10.959] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    10.962] (II) Module dbe: vendor="X.Org Foundation"
[    10.962] 	compiled for 1.11.2.902, module version = 1.0.0
[    10.962] 	Module class: X.Org Server Extension
[    10.962] 	ABI class: X.Org Server Extension, version 6.0
[    10.962] (II) Loading extension DOUBLE-BUFFER
[    10.962] (II) LoadModule: "glx"
[    10.962] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    10.964] (II) Module glx: vendor="X.Org Foundation"
[    10.964] 	compiled for 1.11.2.902, module version = 1.0.0
[    10.964] 	ABI class: X.Org Server Extension, version 6.0
[    10.964] (==) AIGLX enabled
[    10.964] (II) Loading extension GLX
[    10.965] (II) LoadModule: "record"
[    10.965] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    10.966] (II) Module record: vendor="X.Org Foundation"
[    10.966] 	compiled for 1.11.2.902, module version = 1.13.0
[    10.966] 	Module class: X.Org Server Extension
[    10.966] 	ABI class: X.Org Server Extension, version 6.0
[    10.966] (II) Loading extension RECORD
[    10.966] (II) LoadModule: "dri"
[    10.966] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    10.968] (II) Module dri: vendor="X.Org Foundation"
[    10.968] 	compiled for 1.11.2.902, module version = 1.0.0
[    10.968] 	ABI class: X.Org Server Extension, version 6.0
[    10.968] (II) Loading extension XFree86-DRI
[    10.968] (II) LoadModule: "dri2"
[    10.969] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    10.969] (II) Module dri2: vendor="X.Org Foundation"
[    10.969] 	compiled for 1.11.2.902, module version = 1.2.0
[    10.969] 	ABI class: X.Org Server Extension, version 6.0
[    10.969] (II) Loading extension DRI2
[    10.969] (==) Matched intel as autoconfigured driver 0
[    10.969] (==) Matched vesa as autoconfigured driver 1
[    10.969] (==) Matched fbdev as autoconfigured driver 2
[    10.969] (==) Assigned the driver to the xf86ConfigLayout
[    10.970] (II) LoadModule: "intel"
[    10.970] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    10.973] (II) Module intel: vendor="X.Org Foundation"
[    10.974] 	compiled for 1.11.1.902, module version = 2.17.0
[    10.974] 	Module class: X.Org Video Driver
[    10.974] 	ABI class: X.Org Video Driver, version 11.0
[    10.974] (II) LoadModule: "vesa"
[    10.974] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    10.975] (II) Module vesa: vendor="X.Org Foundation"
[    10.975] 	compiled for 1.11.0, module version = 2.3.0
[    10.975] 	Module class: X.Org Video Driver
[    10.975] 	ABI class: X.Org Video Driver, version 11.0
[    10.975] (II) LoadModule: "fbdev"
[    10.975] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    10.975] (II) Module fbdev: vendor="X.Org Foundation"
[    10.975] 	compiled for 1.11.0, module version = 0.4.2
[    10.976] 	ABI class: X.Org Video Driver, version 11.0
[    10.976] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge Desktop (GT1), Sandybridge Desktop (GT2),
	Sandybridge Desktop (GT2+), Sandybridge Mobile (GT1),
	Sandybridge Mobile (GT2), Sandybridge Mobile (GT2+),
	Sandybridge Server, Ivybridge Mobile (GT1), Ivybridge Mobile (GT2),
	Ivybridge Desktop (GT1), Ivybridge Desktop (GT2), Ivybridge Server
[    10.976] (II) VESA: driver for VESA chipsets: vesa
[    10.977] (II) FBDEV: driver for framebuffer: fbdev
[    10.977] (++) using VT number 7

[    10.988] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    10.988] (WW) Falling back to old probe method for vesa
[    10.988] (WW) Falling back to old probe method for fbdev
[    10.988] (II) Loading sub module "fbdevhw"
[    10.988] (II) LoadModule: "fbdevhw"
[    10.988] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    10.989] (II) Module fbdevhw: vendor="X.Org Foundation"
[    10.989] 	compiled for 1.11.2.902, module version = 0.0.2
[    10.989] 	ABI class: X.Org Video Driver, version 11.0
[    10.989] drmOpenDevice: node name is /dev/dri/card0
[    10.989] drmOpenDevice: open result is 9, (OK)
[    10.989] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    10.989] drmOpenDevice: node name is /dev/dri/card0
[    10.989] drmOpenDevice: open result is 9, (OK)
[    10.989] drmOpenByBusid: drmOpenMinor returns 9
[    10.989] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    10.989] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    10.989] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    10.989] (==) intel(0): RGB weight 888
[    10.989] (==) intel(0): Default visual is TrueColor
[    10.989] (II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
[    10.989] (--) intel(0): Chipset: "Arrandale"
[    10.989] (**) intel(0): Relaxed fencing enabled
[    10.989] (**) intel(0): Wait on SwapBuffers? enabled
[    10.989] (**) intel(0): Triple buffering? enabled
[    10.989] (**) intel(0): Framebuffer tiled
[    10.989] (**) intel(0): Pixmaps tiled
[    10.989] (**) intel(0): 3D buffers tiled
[    10.989] (**) intel(0): SwapBuffers wait enabled
[    10.989] (==) intel(0): video overlay key set to 0x101fe
[    10.990] (II) intel(0): Output LVDS1 has no monitor section
[    10.990] (II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
[    10.990] (II) intel(0): Output VGA1 has no monitor section
[    11.013] (II) intel(0): Output HDMI1 has no monitor section
[    11.124] (II) intel(0): Output DP1 has no monitor section
[    11.124] (II) intel(0): EDID for output LVDS1
[    11.124] (II) intel(0): Manufacturer: LEN  Model: 4011  Serial#: 0
[    11.124] (II) intel(0): Year: 2009  Week: 0
[    11.124] (II) intel(0): EDID Version: 1.3
[    11.124] (II) intel(0): Digital Display Input
[    11.124] (II) intel(0): Max Image Size [cm]: horiz.: 26  vert.: 16
[    11.124] (II) intel(0): Gamma: 2.20
[    11.124] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[    11.124] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    11.124] (II) intel(0): First detailed timing is preferred mode
[    11.124] (II) intel(0): redX: 0.539 redY: 0.346   greenX: 0.339 greenY: 0.562
[    11.124] (II) intel(0): blueX: 0.148 blueY: 0.095   whiteX: 0.313 whiteY: 0.329
[    11.124] (II) intel(0): Manufacturer's mask: 0
[    11.124] (II) intel(0): Supported detailed timing:
[    11.124] (II) intel(0): clock: 75.2 MHz   Image Size:  261 x 163 mm
[    11.124] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1412 h_blank_end 1522 h_border: 0
[    11.124] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_blanking: 823 v_border: 0
[    11.124] (II) intel(0): Supported detailed timing:
[    11.124] (II) intel(0): clock: 75.2 MHz   Image Size:  261 x 163 mm
[    11.124] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1412 h_blank_end 1522 h_border: 0
[    11.124] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_blanking: 823 v_border: 0
[    11.124] (II) intel(0): Unknown vendor-specific block f
[    11.124] (II) intel(0):  HV121WX6-110
[    11.124] (II) intel(0): EDID (in hex):
[    11.124] (II) intel(0): 	00ffffffffffff0030ae114000000000
[    11.124] (II) intel(0): 	00130103801a1078ea2f158a58568f26
[    11.124] (II) intel(0): 	18505400000001010101010101010101
[    11.124] (II) intel(0): 	0101010101015c1d00f2502017303054
[    11.124] (II) intel(0): 	360005a3100000195c1d00f250201730
[    11.124] (II) intel(0): 	3054360005a3100000190000000f0081
[    11.124] (II) intel(0): 	0a3c810a3c1e0a0000009e08000000fe
[    11.124] (II) intel(0): 	0048563132315758362d3131300a0014
[    11.124] (II) intel(0): EDID vendor "LEN", prod id 16401
[    11.124] (II) intel(0): Printing DDC gathered Modelines:
[    11.124] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    11.124] (II) intel(0): Not using default mode "320x240" (doublescan mode not supported)
[    11.124] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    11.124] (II) intel(0): Not using default mode "400x300" (doublescan mode not supported)
[    11.124] (II) intel(0): Not using default mode "512x384" (doublescan mode not supported)
[    11.124] (II) intel(0): Not using default mode "640x480" (doublescan mode not supported)
[    11.124] (II) intel(0): Not using default mode "640x512" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "800x600" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "896x672" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "928x696" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "960x720" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "576x432" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "680x384" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "700x525" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "720x450" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "800x512" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "840x525" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "960x540" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "960x600" (doublescan mode not supported)
[    11.125] (II) intel(0): Not using default mode "1024x768" (doublescan mode not supported)
[    11.125] (II) intel(0): Printing probed modes for output LVDS1
[    11.125] (II) intel(0): Modeline "1280x800"x60.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    11.125] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    11.125] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    11.125] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    11.125] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    11.125] (II) intel(0): EDID for output VGA1
[    11.148] (II) intel(0): EDID for output HDMI1
[    11.258] (II) intel(0): EDID for output DP1
[    11.258] (II) intel(0): Manufacturer: DEL  Model: 4065  Serial#: 808727628
[    11.258] (II) intel(0): Year: 2011  Week: 49
[    11.258] (II) intel(0): EDID Version: 1.4
[    11.258] (II) intel(0): Digital Display Input
[    11.258] (II) intel(0): 10 bits per channel
[    11.258] (II) intel(0): Digital interface is DisplayPort
[    11.258] (II) intel(0): Max Image Size [cm]: horiz.: 64  vert.: 40
[    11.258] (II) intel(0): Gamma: 2.20
[    11.258] (II) intel(0): DPMS capabilities: Off
[    11.258] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 YCrCb 4:2:2
[    11.258] (II) intel(0): First detailed timing is preferred mode
[    11.258] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    11.258] (II) intel(0): redX: 0.678 redY: 0.309   greenX: 0.210 greenY: 0.692
[    11.258] (II) intel(0): blueX: 0.146 blueY: 0.055   whiteX: 0.313 whiteY: 0.329
[    11.258] (II) intel(0): Supported established timings:
[    11.258] (II) intel(0): 720x400@70Hz
[    11.258] (II) intel(0): 640x480@60Hz
[    11.258] (II) intel(0): 640x480@75Hz
[    11.258] (II) intel(0): 800x600@60Hz
[    11.259] (II) intel(0): 800x600@75Hz
[    11.259] (II) intel(0): 1024x768@60Hz
[    11.259] (II) intel(0): 1024x768@75Hz
[    11.259] (II) intel(0): 1280x1024@75Hz
[    11.259] (II) intel(0): Manufacturer's mask: 0
[    11.259] (II) intel(0): Supported standard timings:
[    11.259] (II) intel(0): #0: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    11.259] (II) intel(0): #1: hsize: 1280  vsize 800  refresh: 60  vid: 129
[    11.259] (II) intel(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    11.259] (II) intel(0): #3: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    11.259] (II) intel(0): #4: hsize: 1920  vsize 1200  refresh: 60  vid: 209
[    11.259] (II) intel(0): #5: hsize: 1920  vsize 1440  refresh: 60  vid: 16593
[    11.259] (II) intel(0): Supported detailed timing:
[    11.259] (II) intel(0): clock: 268.5 MHz   Image Size:  641 x 401 mm
[    11.259] (II) intel(0): h_active: 2560  h_sync: 2608  h_sync_end 2640 h_blank_end 2720 h_border: 0
[    11.259] (II) intel(0): v_active: 1600  v_sync: 1603  v_sync_end 1609 v_blanking: 1646 v_border: 0
[    11.259] (II) intel(0): Serial No: PH5NY1C9044L
[    11.259] (II) intel(0): Monitor name: DELL U3011
[    11.259] (II) intel(0): Ranges: V min: 49 V max: 86 Hz, H min: 29 H max: 113 kHz, PixClock max 285 MHz
[    11.259] (II) intel(0): Supported detailed timing:
[    11.259] (II) intel(0): clock: 148.5 MHz   Image Size:  641 x 401 mm
[    11.259] (II) intel(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    11.259] (II) intel(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[    11.259] (II) intel(0): Supported detailed timing:
[    11.259] (II) intel(0): clock: 74.2 MHz   Image Size:  641 x 401 mm
[    11.259] (II) intel(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    11.259] (II) intel(0): v_active: 540  v_sync: 542  v_sync_end 547 v_blanking: 562 v_border: 0
[    11.259] (II) intel(0): Supported detailed timing:
[    11.259] (II) intel(0): clock: 74.2 MHz   Image Size:  641 x 401 mm
[    11.259] (II) intel(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[    11.259] (II) intel(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    11.259] (II) intel(0): Supported detailed timing:
[    11.259] (II) intel(0): clock: 27.0 MHz   Image Size:  641 x 401 mm
[    11.259] (II) intel(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    11.259] (II) intel(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    11.259] (II) intel(0): Number of EDID sections to follow: 1
[    11.259] (II) intel(0): EDID (in hex):
[    11.259] (II) intel(0): 	00ffffffffffff0010ac65404c343430
[    11.259] (II) intel(0): 	31150104b54028783a8d85ad4f35b125
[    11.259] (II) intel(0): 	0e5054a54b00714f81008180a940d100
[    11.259] (II) intel(0): 	d14001010101e26800a0a0402e603020
[    11.259] (II) intel(0): 	360081912100001a000000ff00504835
[    11.259] (II) intel(0): 	4e593143393034344c0a000000fc0044
[    11.259] (II) intel(0): 	454c4c2055333031310a2020000000fd
[    11.259] (II) intel(0): 	0031561d711c000a2020202020200108
[    11.259] (II) intel(0): 	02031df1509005040302071601061112
[    11.259] (II) intel(0): 	1513141f20230d7f07830f0000023a80
[    11.259] (II) intel(0): 	1871382d40582c450081912100001e01
[    11.259] (II) intel(0): 	1d8018711c1620582c25008191210000
[    11.259] (II) intel(0): 	9e011d007251d01e206e285500819121
[    11.259] (II) intel(0): 	00001e8c0ad08a20e02d10103e960081
[    11.259] (II) intel(0): 	91210000180000000000000000000000
[    11.259] (II) intel(0): 	00000000000000000000000000000077
[    11.259] (II) intel(0): Printing probed modes for output DP1
[    11.259] (II) intel(0): Modeline "2560x1600"x60.0  268.50  2560 2608 2640 2720  1600 1603 1609 1646 +hsync -vsync (98.7 kHz)
[    11.259] (II) intel(0): Modeline "1920x1440"x60.0  234.00  1920 2048 2256 2600  1440 1441 1444 1500 -hsync +vsync (90.0 kHz)
[    11.259] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz)
[    11.259] (II) intel(0): Modeline "1920x1080"x60.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz)
[    11.259] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    11.259] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    11.259] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    11.259] (II) intel(0): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 +hsync -vsync (49.7 kHz)
[    11.259] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    11.259] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    11.259] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    11.259] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    11.259] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    11.259] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    11.259] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    11.259] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    11.259] (II) intel(0): Output LVDS1 connected
[    11.259] (II) intel(0): Output VGA1 disconnected
[    11.259] (II) intel(0): Output HDMI1 disconnected
[    11.259] (II) intel(0): Output DP1 connected
[    11.259] (II) intel(0): Using exact sizes for initial modes
[    11.259] (II) intel(0): Output LVDS1 using initial mode 1280x800
[    11.259] (II) intel(0): Output DP1 using initial mode 1280x800
[    11.259] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    11.259] (II) intel(0): Kernel page flipping support detected, enabling
[    11.259] (**) intel(0): Display dimensions: (260, 160) mm
[    11.259] (**) intel(0): DPI set to (125, 127)
[    11.259] (II) Loading sub module "fb"
[    11.259] (II) LoadModule: "fb"
[    11.260] (II) Loading /usr/lib/xorg/modules/libfb.so
[    11.262] (II) Module fb: vendor="X.Org Foundation"
[    11.262] 	compiled for 1.11.2.902, module version = 1.0.0
[    11.262] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    11.262] (II) Loading sub module "dri2"
[    11.262] (II) LoadModule: "dri2"
[    11.262] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    11.262] (II) Module dri2: vendor="X.Org Foundation"
[    11.262] 	compiled for 1.11.2.902, module version = 1.2.0
[    11.262] 	ABI class: X.Org Server Extension, version 6.0
[    11.262] (II) UnloadModule: "vesa"
[    11.262] (II) Unloading vesa
[    11.262] (II) UnloadModule: "fbdev"
[    11.262] (II) Unloading fbdev
[    11.262] (II) UnloadModule: "fbdevhw"
[    11.262] (II) Unloading fbdevhw
[    11.262] (==) Depth 24 pixmap format is 32 bpp
[    11.262] (II) intel(0): [DRI2] Setup complete
[    11.262] (II) intel(0): [DRI2]   DRI driver: i965
[    11.262] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120, tiled
[    11.275] (II) UXA(0): Driver registered support for the following operations:
[    11.275] (II)         solid
[    11.275] (II)         copy
[    11.275] (II)         composite (RENDER acceleration)
[    11.275] (II)         put_image
[    11.275] (II)         get_image
[    11.275] (==) intel(0): Backing store disabled
[    11.275] (==) intel(0): Silken mouse enabled
[    11.275] (II) intel(0): Initializing HW Cursor
[    11.794] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    11.797] (==) intel(0): DPMS enabled
[    11.797] (==) intel(0): Intel XvMC decoder enabled
[    11.797] (II) intel(0): Set up textured video
[    11.797] (II) intel(0): [XvMC] xvmc_vld driver initialized.
[    11.797] (II) intel(0): direct rendering: DRI2 Enabled
[    11.797] (==) intel(0): hotplug detection: "enabled"
[    11.798] (--) RandR disabled
[    11.798] (II) Initializing built-in extension Generic Event Extension
[    11.798] (II) Initializing built-in extension SHAPE
[    11.798] (II) Initializing built-in extension MIT-SHM
[    11.798] (II) Initializing built-in extension XInputExtension
[    11.798] (II) Initializing built-in extension XTEST
[    11.798] (II) Initializing built-in extension BIG-REQUESTS
[    11.798] (II) Initializing built-in extension SYNC
[    11.798] (II) Initializing built-in extension XKEYBOARD
[    11.798] (II) Initializing built-in extension XC-MISC
[    11.798] (II) Initializing built-in extension SECURITY
[    11.798] (II) Initializing built-in extension XINERAMA
[    11.798] (II) Initializing built-in extension XFIXES
[    11.798] (II) Initializing built-in extension RENDER
[    11.798] (II) Initializing built-in extension RANDR
[    11.798] (II) Initializing built-in extension COMPOSITE
[    11.798] (II) Initializing built-in extension DAMAGE
[    11.798] (II) SELinux: Disabled on system
[    11.819] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    11.819] (II) AIGLX: enabled GLX_INTEL_swap_event
[    11.819] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    11.819] (II) AIGLX: enabled GLX_SGI_make_current_read
[    11.819] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    11.820] (II) AIGLX: Loaded and initialized i965
[    11.820] (II) GLX: Initialized DRI2 GL provider for screen 0
[    11.820] (II) intel(0): Setting screen physical size to 338 x 211
[    11.906] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[    11.907] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    11.907] (II) LoadModule: "evdev"
[    11.907] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.908] (II) Module evdev: vendor="X.Org Foundation"
[    11.908] 	compiled for 1.11.0, module version = 2.6.0
[    11.908] 	Module class: X.Org XInput Driver
[    11.908] 	ABI class: X.Org XInput driver, version 13.0
[    11.908] (II) Using input driver 'evdev' for 'Power Button'
[    11.908] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.908] (**) Power Button: always reports core events
[    11.908] (**) Power Button: Device: "/dev/input/event3"
[    11.908] (--) Power Button: Found keys
[    11.908] (II) Power Button: Configuring as keyboard
[    11.908] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[    11.908] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[    11.908] (**) Option "xkb_rules" "evdev"
[    11.908] (**) Option "xkb_model" "pc105"
[    11.908] (**) Option "xkb_layout" "ca"
[    11.943] (II) config/udev: Adding input device Video Bus (/dev/input/event10)
[    11.944] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    11.944] (II) Using input driver 'evdev' for 'Video Bus'
[    11.944] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.944] (**) Video Bus: always reports core events
[    11.944] (**) Video Bus: Device: "/dev/input/event10"
[    11.944] (--) Video Bus: Found keys
[    11.944] (II) Video Bus: Configuring as keyboard
[    11.944] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10/event10"
[    11.944] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[    11.944] (**) Option "xkb_rules" "evdev"
[    11.944] (**) Option "xkb_model" "pc105"
[    11.944] (**) Option "xkb_layout" "ca"
[    11.944] (II) config/udev: Adding input device Lid Switch (/dev/input/event1)
[    11.945] (II) No input driver/identifier specified (ignoring)
[    11.945] (II) config/udev: Adding input device Sleep Button (/dev/input/event2)
[    11.945] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    11.945] (II) Using input driver 'evdev' for 'Sleep Button'
[    11.945] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.945] (**) Sleep Button: always reports core events
[    11.945] (**) Sleep Button: Device: "/dev/input/event2"
[    11.945] (--) Sleep Button: Found keys
[    11.945] (II) Sleep Button: Configuring as keyboard
[    11.945] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2/event2"
[    11.945] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD, id 8)
[    11.945] (**) Option "xkb_rules" "evdev"
[    11.945] (**) Option "xkb_model" "pc105"
[    11.945] (**) Option "xkb_layout" "ca"
[    11.946] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event6)
[    11.946] (**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
[    11.946] (II) Using input driver 'evdev' for 'Logitech USB-PS/2 Optical Mouse'
[    11.946] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.946] (**) Logitech USB-PS/2 Optical Mouse: always reports core events
[    11.946] (**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event6"
[    11.946] (--) Logitech USB-PS/2 Optical Mouse: Found 12 mouse buttons
[    11.946] (--) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
[    11.946] (--) Logitech USB-PS/2 Optical Mouse: Found relative axes
[    11.946] (--) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
[    11.946] (II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
[    11.946] (II) Logitech USB-PS/2 Optical Mouse: Adding scrollwheel support
[    11.946] (**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
[    11.946] (**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    11.947] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input6/event6"
[    11.947] (II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE, id 9)
[    11.947] (II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
[    11.947] (**) Logitech USB-PS/2 Optical Mouse: (accel) keeping acceleration scheme 1
[    11.947] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration profile 0
[    11.947] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration factor: 2.000
[    11.947] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration threshold: 4
[    11.947] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse0)
[    11.947] (II) No input driver/identifier specified (ignoring)
[    11.948] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event7)
[    11.948] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[    11.948] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[    11.948] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.948] (**) Logitech USB Multimedia Keyboard: always reports core events
[    11.948] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event7"
[    11.948] (--) Logitech USB Multimedia Keyboard: Found keys
[    11.948] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[    11.948] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input7/event7"
[    11.948] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 10)
[    11.948] (**) Option "xkb_rules" "evdev"
[    11.948] (**) Option "xkb_model" "pc105"
[    11.948] (**) Option "xkb_layout" "ca"
[    11.949] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event9)
[    11.949] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[    11.949] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[    11.949] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.949] (**) Logitech USB Multimedia Keyboard: always reports core events
[    11.949] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event9"
[    11.949] (--) Logitech USB Multimedia Keyboard: Found keys
[    11.949] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[    11.949] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input9/event9"
[    11.949] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 11)
[    11.949] (**) Option "xkb_rules" "evdev"
[    11.950] (**) Option "xkb_model" "pc105"
[    11.950] (**) Option "xkb_layout" "ca"
[    11.950] (II) config/udev: Adding input device Integrated Camera (/dev/input/event8)
[    11.950] (**) Integrated Camera: Applying InputClass "evdev keyboard catchall"
[    11.950] (II) Using input driver 'evdev' for 'Integrated Camera'
[    11.950] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.950] (**) Integrated Camera: always reports core events
[    11.950] (**) Integrated Camera: Device: "/dev/input/event8"
[    11.950] (--) Integrated Camera: Found keys
[    11.950] (II) Integrated Camera: Configuring as keyboard
[    11.950] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input8/event8"
[    11.950] (II) XINPUT: Adding extended input device "Integrated Camera" (type: KEYBOARD, id 12)
[    11.950] (**) Option "xkb_rules" "evdev"
[    11.951] (**) Option "xkb_model" "pc105"
[    11.951] (**) Option "xkb_layout" "ca"
[    11.951] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event11)
[    11.951] (II) No input driver/identifier specified (ignoring)
[    11.952] (II) config/udev: Adding input device HDA Intel HDMI/DP,pcm=3 (/dev/input/event12)
[    11.952] (II) No input driver/identifier specified (ignoring)
[    11.952] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    11.952] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    11.952] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    11.952] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    11.952] (**) AT Translated Set 2 keyboard: always reports core events
[    11.952] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    11.952] (--) AT Translated Set 2 keyboard: Found keys
[    11.952] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    11.952] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    11.952] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 13)
[    11.952] (**) Option "xkb_rules" "evdev"
[    11.953] (**) Option "xkb_model" "pc105"
[    11.953] (**) Option "xkb_layout" "ca"
[    11.953] (II) config/udev: Adding input device SynPS/2 Synaptics TouchPad (/dev/input/event13)
[    11.953] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev touchpad catchall"
[    11.953] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad catchall"
[    11.953] (II) LoadModule: "synaptics"
[    11.954] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    11.954] (II) Module synaptics: vendor="X.Org Foundation"
[    11.955] 	compiled for 1.11.2.902, module version = 1.5.0
[    11.955] 	Module class: X.Org XInput Driver
[    11.955] 	ABI class: X.Org XInput driver, version 13.0
[    11.955] (II) Using input driver 'synaptics' for 'SynPS/2 Synaptics TouchPad'
[    11.955] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    11.955] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    11.955] (**) Option "Device" "/dev/input/event13"
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5710
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: y-axis range 1408 - 5164
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: finger width range 0 - 0
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: buttons: left right double triple
[    12.056] (--) synaptics: SynPS/2 Synaptics TouchPad: Vendor 0x2 Product 0x7
[    12.060] (--) synaptics: SynPS/2 Synaptics TouchPad: touchpad found
[    12.060] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    12.068] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input13/event13"
[    12.068] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics TouchPad" (type: TOUCHPAD, id 14)
[    12.068] (**) synaptics: SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now constant deceleration 2.5
[    12.068] (**) synaptics: SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[    12.068] (**) synaptics: SynPS/2 Synaptics TouchPad: AccelFactor is now 0.035
[    12.068] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration scheme 1
[    12.068] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[    12.068] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: 2.000
[    12.068] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshold: 4
[    12.068] (--) synaptics: SynPS/2 Synaptics TouchPad: touchpad found
[    12.069] (II) config/udev: Adding input device SynPS/2 Synaptics TouchPad (/dev/input/mouse1)
[    12.069] (**) SynPS/2 Synaptics TouchPad: Ignoring device from InputClass "touchpad ignore duplicates"
[    12.069] (II) config/udev: Adding input device PC Speaker (/dev/input/event4)
[    12.069] (II) No input driver/identifier specified (ignoring)
[    12.070] (II) config/udev: Adding input device ThinkPad Extra Buttons (/dev/input/event5)
[    12.070] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboard catchall"
[    12.070] (II) Using input driver 'evdev' for 'ThinkPad Extra Buttons'
[    12.070] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    12.070] (**) ThinkPad Extra Buttons: always reports core events
[    12.070] (**) ThinkPad Extra Buttons: Device: "/dev/input/event5"
[    12.070] (--) ThinkPad Extra Buttons: Found keys
[    12.070] (II) ThinkPad Extra Buttons: Configuring as keyboard
[    12.070] (**) Option "config_info" "udev:/sys/devices/platform/thinkpad_acpi/input/input5/event5"
[    12.070] (II) XINPUT: Adding extended input device "ThinkPad Extra Buttons" (type: KEYBOARD, id 15)
[    12.070] (**) Option "xkb_rules" "evdev"
[    12.070] (**) Option "xkb_model" "pc105"
[    12.070] (**) Option "xkb_layout" "ca"
[    12.070] (II) config/udev: Adding input device Serial Wacom Tablet (/dev/ttyS0)
[    12.070] (**) Serial Wacom Tablet: Applying InputClass "Wacom serial class"
[    12.070] (II) LoadModule: "wacom"
[    12.071] (II) Loading /usr/lib/xorg/modules/input/wacom_drv.so
[    12.072] (II) Module wacom: vendor="X.Org Foundation"
[    12.072] 	compiled for 1.11.1.902, module version = 0.12.0
[    12.072] 	Module class: X.Org XInput Driver
[    12.072] 	ABI class: X.Org XInput driver, version 13.0
[    12.072] (II) Using input driver 'wacom' for 'Serial Wacom Tablet'
[    12.072] (II) Loading /usr/lib/xorg/modules/input/wacom_drv.so
[    12.072] (**) Serial Wacom Tablet: always reports core events
[    12.072] (**) Option "Device" "/dev/ttyS0"
[    12.072] (**) Option "StopBits" "1"
[    12.072] (**) Option "DataBits" "8"
[    12.072] (**) Option "Parity" "None"
[    12.072] (**) Option "Vmin" "1"
[    12.072] (**) Option "Vtime" "10"
[    12.072] (**) Option "FlowControl" "Xoff"
[    12.073] (II) Serial Wacom Tablet: type not specified, assuming 'stylus'.
[    12.073] (II) Serial Wacom Tablet: other types will be automatically added.
[    12.584] (II) Serial Wacom Tablet stylus: serial tablet id 0xE3.
[    12.584] (--) Serial Wacom Tablet stylus: using pressure threshold of 27 for button 1
[    12.584] (--) Serial Wacom Tablet stylus: Wacom General ISDV4 tablet maxX=26312 maxY=16520 maxZ=255 resX=100000 resY=100000  tilt=disabled
[    12.584] (II) Serial Wacom Tablet stylus: hotplugging dependent devices.
[    12.584] (EE) Serial Wacom Tablet stylus: Invalid type 'cursor' for this device.
[    12.584] (EE) Serial Wacom Tablet stylus: Invalid type 'pad' for this device.
[    12.584] (II) Serial Wacom Tablet stylus: hotplugging completed.
[    12.585] (**) Option "config_info" "udev:/sys/devices/pnp0/00:0b/tty/ttyS0"
[    12.585] (II) XINPUT: Adding extended input device "Serial Wacom Tablet stylus" (type: STYLUS, id 16)
[    12.585] (**) Serial Wacom Tablet stylus: (accel) keeping acceleration scheme 1
[    12.585] (**) Serial Wacom Tablet stylus: (accel) acceleration profile 0
[    12.585] (**) Serial Wacom Tablet stylus: (accel) acceleration factor: 2.000
[    12.585] (**) Serial Wacom Tablet stylus: (accel) acceleration threshold: 4
[    12.585] (**) Option "BaudRate" "38400"
[    12.586] (II) config/udev: Adding input device ACPI Virtual Keyboard Device (/dev/input/event14)
[    12.586] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev keyboard catchall"
[    12.586] (II) Using input driver 'evdev' for 'ACPI Virtual Keyboard Device'
[    12.586] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    12.586] (**) ACPI Virtual Keyboard Device: always reports core events
[    12.586] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event14"
[    12.586] (--) ACPI Virtual Keyboard Device: Found keys
[    12.586] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    12.586] (**) Option "config_info" "udev:/sys/devices/virtual/input/input14/event14"
[    12.586] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboard Device" (type: KEYBOARD, id 17)
[    12.586] (**) Option "xkb_rules" "evdev"
[    12.586] (**) Option "xkb_model" "pc105"
[    12.586] (**) Option "xkb_layout" "ca"
[    12.592] (**) Serial Wacom Tablet eraser: Applying InputClass "Wacom serial class"
[    12.592] (II) Using input driver 'wacom' for 'Serial Wacom Tablet eraser'
[    12.592] (II) Loading /usr/lib/xorg/modules/input/wacom_drv.so
[    12.592] (**) Serial Wacom Tablet eraser: always reports core events
[    12.592] (**) Option "Device" "/dev/ttyS0"
[    12.592] (**) Option "Type" "eraser"
[    12.592] (**) Option "BaudRate" "38400"
[    12.592] (**) Option "StopBits" "1"
[    12.592] (**) Option "DataBits" "8"
[    12.592] (**) Option "Parity" "None"
[    12.592] (**) Option "Vmin" "1"
[    12.592] (**) Option "Vtime" "10"
[    12.592] (**) Option "FlowControl" "Xoff"
[    12.593] (--) Serial Wacom Tablet eraser: Wacom General ISDV4 tablet maxX=26312 maxY=16520 maxZ=255 resX=100000 resY=100000  tilt=disabled
[    12.593] (**) Option "config_info" "udev:/sys/devices/pnp0/00:0b/tty/ttyS0"
[    12.593] (II) XINPUT: Adding extended input device "Serial Wacom Tablet eraser" (type: ERASER, id 18)
[    12.593] (**) Serial Wacom Tablet eraser: (accel) keeping acceleration scheme 1
[    12.593] (**) Serial Wacom Tablet eraser: (accel) acceleration profile 0
[    12.593] (**) Serial Wacom Tablet eraser: (accel) acceleration factor: 2.000
[    12.593] (**) Serial Wacom Tablet eraser: (accel) acceleration threshold: 4
[    12.593] (**) Serial Wacom Tablet touch: Applying InputClass "Wacom serial class"
[    12.593] (II) Using input driver 'wacom' for 'Serial Wacom Tablet touch'
[    12.593] (II) Loading /usr/lib/xorg/modules/input/wacom_drv.so
[    12.593] (**) Serial Wacom Tablet touch: always reports core events
[    12.593] (**) Option "Device" "/dev/ttyS0"
[    12.593] (**) Option "Type" "touch"
[    12.593] (**) Option "BaudRate" "38400"
[    12.593] (**) Option "StopBits" "1"
[    12.593] (**) Option "DataBits" "8"
[    12.594] (**) Option "Parity" "None"
[    12.594] (**) Option "Vmin" "1"
[    12.594] (**) Option "Vtime" "10"
[    12.594] (**) Option "FlowControl" "Xoff"
[    12.594] (--) Serial Wacom Tablet touch: Wacom General ISDV4 tablet maxX=26312 maxY=16520 maxZ=255 resX=100000 resY=100000  tilt=disabled
[    12.594] (**) Option "config_info" "udev:/sys/devices/pnp0/00:0b/tty/ttyS0"
[    12.594] (II) XINPUT: Adding extended input device "Serial Wacom Tablet touch" (type: TOUCH, id 19)
[    12.594] (**) Serial Wacom Tablet touch: (accel) keeping acceleration scheme 1
[    12.594] (**) Serial Wacom Tablet touch: (accel) acceleration profile 0
[    12.594] (**) Serial Wacom Tablet touch: (accel) acceleration factor: 2.000
[    12.594] (**) Serial Wacom Tablet touch: (accel) acceleration threshold: 4
[    12.595] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/dev/input/mouse2)
[    12.595] (II) No input driver/identifier specified (ignoring)
[    12.595] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/dev/input/event15)
[    12.595] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer catchall"
[    12.595] (II) Using input driver 'evdev' for 'TPPS/2 IBM TrackPoint'
[    12.595] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    12.595] (**) TPPS/2 IBM TrackPoint: always reports core events
[    12.595] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event15"
[    12.616] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[    12.616] (--) TPPS/2 IBM TrackPoint: Found relative axes
[    12.616] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[    12.616] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[    12.616] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[    12.616] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    12.616] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/serio2/input/input15/event15"
[    12.616] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoint" (type: MOUSE, id 20)
[    12.616] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[    12.616] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration scheme 1
[    12.616] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[    12.616] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[    12.616] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[    12.620] (II) intel(0): EDID vendor "LEN", prod id 16401
[    12.620] (II) intel(0): Printing DDC gathered Modelines:
[    12.620] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    13.097] (II) intel(0): EDID vendor "LEN", prod id 16401
[    13.097] (II) intel(0): Printing DDC gathered Modelines:
[    13.097] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    13.531] (II) intel(0): EDID vendor "LEN", prod id 16401
[    13.531] (II) intel(0): Printing DDC gathered Modelines:
[    13.531] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    13.673] (II) intel(0): EDID vendor "LEN", prod id 16401
[    13.673] (II) intel(0): Printing DDC gathered Modelines:
[    13.673] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    13.810] (II) intel(0): EDID vendor "LEN", prod id 16401
[    13.810] (II) intel(0): Printing DDC gathered Modelines:
[    13.810] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    13.948] (II) intel(0): EDID vendor "LEN", prod id 16401
[    13.948] (II) intel(0): Printing DDC gathered Modelines:
[    13.948] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    14.085] (II) intel(0): EDID vendor "LEN", prod id 16401
[    14.085] (II) intel(0): Printing DDC gathered Modelines:
[    14.085] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    14.507] (II) intel(0): EDID vendor "LEN", prod id 16401
[    14.508] (II) intel(0): Printing DDC gathered Modelines:
[    14.508] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    31.295] (II) intel(0): EDID vendor "LEN", prod id 16401
[    31.295] (II) intel(0): Printing DDC gathered Modelines:
[    31.295] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    31.452] (II) intel(0): EDID vendor "LEN", prod id 16401
[    31.452] (II) intel(0): Printing DDC gathered Modelines:
[    31.452] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    31.591] (II) intel(0): EDID vendor "LEN", prod id 16401
[    31.591] (II) intel(0): Printing DDC gathered Modelines:
[    31.591] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    31.727] (II) intel(0): EDID vendor "LEN", prod id 16401
[    31.727] (II) intel(0): Printing DDC gathered Modelines:
[    31.727] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    31.865] (II) intel(0): EDID vendor "LEN", prod id 16401
[    31.865] (II) intel(0): Printing DDC gathered Modelines:
[    31.865] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    32.004] (II) intel(0): Allocated new frame buffer 1600x2000 stride 6656, tiled
[    33.571] (II) intel(0): EDID vendor "LEN", prod id 16401
[    33.571] (II) intel(0): Printing DDC gathered Modelines:
[    33.571] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    34.212] (II) intel(0): EDID vendor "LEN", prod id 16401
[    34.212] (II) intel(0): Printing DDC gathered Modelines:
[    34.212] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    34.608] (II) intel(0): EDID vendor "LEN", prod id 16401
[    34.608] (II) intel(0): Printing DDC gathered Modelines:
[    34.608] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    35.307] (II) intel(0): Allocated new frame buffer 2560x2400 stride 10240, tiled
[    36.112] (II) intel(0): EDID vendor "LEN", prod id 16401
[    36.112] (II) intel(0): Printing DDC gathered Modelines:
[    36.112] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    36.448] (II) intel(0): Allocated new frame buffer 2560x1600 stride 10240, tiled
[    36.783] (II) intel(0): EDID vendor "LEN", prod id 16401
[    36.783] (II) intel(0): Printing DDC gathered Modelines:
[    36.783] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    37.810] (II) intel(0): EDID vendor "LEN", prod id 16401
[    37.810] (II) intel(0): Printing DDC gathered Modelines:
[    37.810] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    52.415] (II) intel(0): EDID vendor "LEN", prod id 16401
[    52.415] (II) intel(0): Printing DDC gathered Modelines:
[    52.416] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    65.452] (II) intel(0): EDID vendor "LEN", prod id 16401
[    65.453] (II) intel(0): Printing DDC gathered Modelines:
[    65.453] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    73.813] (II) intel(0): EDID vendor "LEN", prod id 16401
[    73.813] (II) intel(0): Printing DDC gathered Modelines:
[    73.813] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    73.958] (II) intel(0): EDID vendor "LEN", prod id 16401
[    73.958] (II) intel(0): Printing DDC gathered Modelines:
[    73.958] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    74.101] (II) intel(0): Allocated new frame buffer 2560x2400 stride 10240, tiled
[    80.628] (II) intel(0): EDID vendor "LEN", prod id 16401
[    80.629] (II) intel(0): Printing DDC gathered Modelines:
[    80.629] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    80.774] (II) intel(0): EDID vendor "LEN", prod id 16401
[    80.774] (II) intel(0): Printing DDC gathered Modelines:
[    80.774] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    82.263] (II) intel(0): EDID vendor "LEN", prod id 16401
[    82.263] (II) intel(0): Printing DDC gathered Modelines:
[    82.263] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    88.967] (II) intel(0): EDID vendor "LEN", prod id 16401
[    88.967] (II) intel(0): Printing DDC gathered Modelines:
[    88.967] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    89.110] (II) intel(0): EDID vendor "LEN", prod id 16401
[    89.110] (II) intel(0): Printing DDC gathered Modelines:
[    89.110] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    89.251] (II) intel(0): EDID vendor "LEN", prod id 16401
[    89.251] (II) intel(0): Printing DDC gathered Modelines:
[    89.251] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    89.549] (II) intel(0): Allocated new frame buffer 2560x1600 stride 10240, tiled
[    90.918] (II) intel(0): EDID vendor "LEN", prod id 16401
[    90.918] (II) intel(0): Printing DDC gathered Modelines:
[    90.918] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    91.590] (II) intel(0): EDID vendor "LEN", prod id 16401
[    91.590] (II) intel(0): Printing DDC gathered Modelines:
[    91.591] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    91.731] (II) intel(0): EDID vendor "LEN", prod id 16401
[    91.731] (II) intel(0): Printing DDC gathered Modelines:
[    91.731] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    91.870] (II) intel(0): EDID vendor "LEN", prod id 16401
[    91.870] (II) intel(0): Printing DDC gathered Modelines:
[    91.870] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    93.049] (II) intel(0): EDID vendor "LEN", prod id 16401
[    93.050] (II) intel(0): Printing DDC gathered Modelines:
[    93.050] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    93.622] (II) intel(0): EDID vendor "LEN", prod id 16401
[    93.623] (II) intel(0): Printing DDC gathered Modelines:
[    93.623] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    93.763] (II) intel(0): EDID vendor "LEN", prod id 16401
[    93.763] (II) intel(0): Printing DDC gathered Modelines:
[    93.763] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    93.902] (II) intel(0): EDID vendor "LEN", prod id 16401
[    93.902] (II) intel(0): Printing DDC gathered Modelines:
[    93.902] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    95.082] (II) intel(0): EDID vendor "LEN", prod id 16401
[    95.082] (II) intel(0): Printing DDC gathered Modelines:
[    95.082] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    95.462] (II) intel(0): EDID vendor "LEN", prod id 16401
[    95.462] (II) intel(0): Printing DDC gathered Modelines:
[    95.463] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    95.601] (II) intel(0): EDID vendor "LEN", prod id 16401
[    95.601] (II) intel(0): Printing DDC gathered Modelines:
[    95.601] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    95.740] (II) intel(0): EDID vendor "LEN", prod id 16401
[    95.740] (II) intel(0): Printing DDC gathered Modelines:
[    95.740] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[    96.918] (II) intel(0): EDID vendor "LEN", prod id 16401
[    96.918] (II) intel(0): Printing DDC gathered Modelines:
[    96.918] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   107.132] (II) config/udev: removing device Logitech USB-PS/2 Optical Mouse
[   107.132] (II) Logitech USB-PS/2 Optical Mouse: Close
[   107.132] (II) UnloadModule: "evdev"
[   107.132] (II) Unloading evdev
[   107.280] (II) config/udev: removing device Logitech USB Multimedia Keyboard
[   107.280] (II) Logitech USB Multimedia Keyboard: Close
[   107.280] (II) UnloadModule: "evdev"
[   107.280] (II) Unloading evdev
[   107.324] (II) config/udev: removing device Logitech USB Multimedia Keyboard
[   107.324] (II) Logitech USB Multimedia Keyboard: Close
[   107.324] (II) UnloadModule: "evdev"
[   107.324] (II) Unloading evdev
[   114.896] (II) intel(0): EDID vendor "LEN", prod id 16401
[   114.896] (II) intel(0): Printing DDC gathered Modelines:
[   114.896] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   115.038] (II) intel(0): EDID vendor "LEN", prod id 16401
[   115.038] (II) intel(0): Printing DDC gathered Modelines:
[   115.038] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   115.174] (II) intel(0): EDID vendor "LEN", prod id 16401
[   115.174] (II) intel(0): Printing DDC gathered Modelines:
[   115.174] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   116.907] (II) intel(0): EDID vendor "LEN", prod id 16401
[   116.907] (II) intel(0): Printing DDC gathered Modelines:
[   116.907] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   117.049] (II) intel(0): EDID vendor "LEN", prod id 16401
[   117.049] (II) intel(0): Printing DDC gathered Modelines:
[   117.049] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   117.189] (II) intel(0): EDID vendor "LEN", prod id 16401
[   117.189] (II) intel(0): Printing DDC gathered Modelines:
[   117.189] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   117.326] (II) intel(0): EDID vendor "LEN", prod id 16401
[   117.326] (II) intel(0): Printing DDC gathered Modelines:
[   117.326] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   118.731] (II) intel(0): EDID vendor "LEN", prod id 16401
[   118.731] (II) intel(0): Printing DDC gathered Modelines:
[   118.731] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   118.870] (II) intel(0): EDID vendor "LEN", prod id 16401
[   118.870] (II) intel(0): Printing DDC gathered Modelines:
[   118.870] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   119.010] (II) intel(0): EDID vendor "LEN", prod id 16401
[   119.010] (II) intel(0): Printing DDC gathered Modelines:
[   119.010] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   119.150] (II) intel(0): EDID vendor "LEN", prod id 16401
[   119.150] (II) intel(0): Printing DDC gathered Modelines:
[   119.150] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   119.350] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse0)
[   119.350] (II) No input driver/identifier specified (ignoring)
[   119.351] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event6)
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
[   119.351] (II) Using input driver 'evdev' for 'Logitech USB-PS/2 Optical Mouse'
[   119.351] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: always reports core events
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event6"
[   119.351] (--) Logitech USB-PS/2 Optical Mouse: Found 12 mouse buttons
[   119.351] (--) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
[   119.351] (--) Logitech USB-PS/2 Optical Mouse: Found relative axes
[   119.351] (--) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
[   119.351] (II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
[   119.351] (II) Logitech USB-PS/2 Optical Mouse: Adding scrollwheel support
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   119.351] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input16/event6"
[   119.351] (II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE, id 9)
[   119.351] (II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: (accel) keeping acceleration scheme 1
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration profile 0
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration factor: 2.000
[   119.351] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration threshold: 4
[   119.372] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event7)
[   119.372] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[   119.372] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[   119.372] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   119.372] (**) Logitech USB Multimedia Keyboard: always reports core events
[   119.373] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event7"
[   119.373] (--) Logitech USB Multimedia Keyboard: Found keys
[   119.373] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[   119.373] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input17/event7"
[   119.373] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 10)
[   119.373] (**) Option "xkb_rules" "evdev"
[   119.373] (**) Option "xkb_model" "pc105"
[   119.373] (**) Option "xkb_layout" "ca"
[   119.388] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event9)
[   119.388] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[   119.388] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[   119.388] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   119.388] (**) Logitech USB Multimedia Keyboard: always reports core events
[   119.388] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event9"
[   119.388] (--) Logitech USB Multimedia Keyboard: Found keys
[   119.388] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[   119.389] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input18/event9"
[   119.389] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 11)
[   119.389] (**) Option "xkb_rules" "evdev"
[   119.389] (**) Option "xkb_model" "pc105"
[   119.389] (**) Option "xkb_layout" "ca"
[   120.325] (II) intel(0): EDID vendor "LEN", prod id 16401
[   120.325] (II) intel(0): Printing DDC gathered Modelines:
[   120.325] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   120.467] (II) intel(0): EDID vendor "LEN", prod id 16401
[   120.467] (II) intel(0): Printing DDC gathered Modelines:
[   120.467] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   120.605] (II) intel(0): EDID vendor "LEN", prod id 16401
[   120.605] (II) intel(0): Printing DDC gathered Modelines:
[   120.605] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   120.745] (II) intel(0): EDID vendor "LEN", prod id 16401
[   120.745] (II) intel(0): Printing DDC gathered Modelines:
[   120.745] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   121.922] (II) intel(0): EDID vendor "LEN", prod id 16401
[   121.923] (II) intel(0): Printing DDC gathered Modelines:
[   121.923] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   124.511] (II) intel(0): EDID vendor "LEN", prod id 16401
[   124.511] (II) intel(0): Printing DDC gathered Modelines:
[   124.511] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   124.652] (II) intel(0): EDID vendor "LEN", prod id 16401
[   124.652] (II) intel(0): Printing DDC gathered Modelines:
[   124.652] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   124.791] (II) intel(0): EDID vendor "LEN", prod id 16401
[   124.791] (II) intel(0): Printing DDC gathered Modelines:
[   124.791] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   125.971] (II) intel(0): EDID vendor "LEN", prod id 16401
[   125.971] (II) intel(0): Printing DDC gathered Modelines:
[   125.971] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   134.072] (II) config/udev: removing device Logitech USB-PS/2 Optical Mouse
[   134.072] (II) Logitech USB-PS/2 Optical Mouse: Close
[   134.072] (II) UnloadModule: "evdev"
[   134.072] (II) Unloading evdev
[   134.168] (II) config/udev: removing device Logitech USB Multimedia Keyboard
[   134.168] (II) Logitech USB Multimedia Keyboard: Close
[   134.168] (II) UnloadModule: "evdev"
[   134.168] (II) Unloading evdev
[   134.204] (II) config/udev: removing device Logitech USB Multimedia Keyboard
[   134.204] (II) Logitech USB Multimedia Keyboard: Close
[   134.204] (II) UnloadModule: "evdev"
[   134.204] (II) Unloading evdev
[   135.763] (II) intel(0): EDID vendor "LEN", prod id 16401
[   135.763] (II) intel(0): Printing DDC gathered Modelines:
[   135.763] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   135.903] (II) intel(0): EDID vendor "LEN", prod id 16401
[   135.904] (II) intel(0): Printing DDC gathered Modelines:
[   135.904] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   136.043] (II) intel(0): EDID vendor "LEN", prod id 16401
[   136.043] (II) intel(0): Printing DDC gathered Modelines:
[   136.043] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   137.222] (II) intel(0): EDID vendor "LEN", prod id 16401
[   137.222] (II) intel(0): Printing DDC gathered Modelines:
[   137.222] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   138.549] (II) intel(0): EDID vendor "LEN", prod id 16401
[   138.549] (II) intel(0): Printing DDC gathered Modelines:
[   138.549] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   138.689] (II) intel(0): EDID vendor "LEN", prod id 16401
[   138.689] (II) intel(0): Printing DDC gathered Modelines:
[   138.689] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   138.831] (II) intel(0): EDID vendor "LEN", prod id 16401
[   138.831] (II) intel(0): Printing DDC gathered Modelines:
[   138.831] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   140.010] (II) intel(0): EDID vendor "LEN", prod id 16401
[   140.010] (II) intel(0): Printing DDC gathered Modelines:
[   140.010] (II) intel(0): Modeline "1280x800"x0.0   75.16  1280 1328 1412 1522  800 803 809 823 -hsync -vsync (49.4 kHz)
[   140.144] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/mouse0)
[   140.144] (II) No input driver/identifier specified (ignoring)
[   140.144] (II) config/udev: Adding input device Logitech USB-PS/2 Optical Mouse (/dev/input/event6)
[   140.144] (**) Logitech USB-PS/2 Optical Mouse: Applying InputClass "evdev pointer catchall"
[   140.144] (II) Using input driver 'evdev' for 'Logitech USB-PS/2 Optical Mouse'
[   140.144] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   140.144] (**) Logitech USB-PS/2 Optical Mouse: always reports core events
[   140.144] (**) Logitech USB-PS/2 Optical Mouse: Device: "/dev/input/event6"
[   140.144] (--) Logitech USB-PS/2 Optical Mouse: Found 12 mouse buttons
[   140.144] (--) Logitech USB-PS/2 Optical Mouse: Found scroll wheel(s)
[   140.144] (--) Logitech USB-PS/2 Optical Mouse: Found relative axes
[   140.144] (--) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes
[   140.145] (II) Logitech USB-PS/2 Optical Mouse: Configuring as mouse
[   140.145] (II) Logitech USB-PS/2 Optical Mouse: Adding scrollwheel support
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: YAxisMapping: buttons 4 and 5
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   140.145] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input19/event6"
[   140.145] (II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optical Mouse" (type: MOUSE, id 9)
[   140.145] (II) Logitech USB-PS/2 Optical Mouse: initialized for relative axes.
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: (accel) keeping acceleration scheme 1
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration profile 0
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration factor: 2.000
[   140.145] (**) Logitech USB-PS/2 Optical Mouse: (accel) acceleration threshold: 4
[   140.145] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event7)
[   140.145] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[   140.145] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[   140.145] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   140.145] (**) Logitech USB Multimedia Keyboard: always reports core events
[   140.145] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event7"
[   140.146] (--) Logitech USB Multimedia Keyboard: Found keys
[   140.146] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[   140.146] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input20/event7"
[   140.146] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 10)
[   140.146] (**) Option "xkb_rules" "evdev"
[   140.146] (**) Option "xkb_model" "pc105"
[   140.146] (**) Option "xkb_layout" "ca"
[   140.146] (II) config/udev: Adding input device Logitech USB Multimedia Keyboard (/dev/input/event9)
[   140.146] (**) Logitech USB Multimedia Keyboard: Applying InputClass "evdev keyboard catchall"
[   140.146] (II) Using input driver 'evdev' for 'Logitech USB Multimedia Keyboard'
[   140.146] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   140.146] (**) Logitech USB Multimedia Keyboard: always reports core events
[   140.146] (**) Logitech USB Multimedia Keyboard: Device: "/dev/input/event9"
[   140.146] (--) Logitech USB Multimedia Keyboard: Found keys
[   140.146] (II) Logitech USB Multimedia Keyboard: Configuring as keyboard
[   140.146] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input21/event9"
[   140.146] (II) XINPUT: Adding extended input device "Logitech USB Multimedia Keyboard" (type: KEYBOARD, id 11)
[   140.146] (**) Option "xkb_rules" "evdev"
[   140.146] (**) Option "xkb_model" "pc105"
[   140.146] (**) Option "xkb_layout" "ca"

* Here is a 3.2.0 kernel dmesg output, where I had to power cycle the
  screen and go to sleep mode and resume to get the two screens to work:


ask: 0x1d
[    0.721775] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.722107] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.722165] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.722167] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.722169] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.722171] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.722173] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.722176] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.722186] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.722201] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.722217] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.722227] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.722233] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.722237] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.722296] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.722324] pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
[    0.722398] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.722404] pci 0000:00:16.0: PME# disabled
[    0.722432] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    0.722454] pci 0000:00:16.3: reg 10: [io  0x1808-0x180f]
[    0.722466] pci 0000:00:16.3: reg 14: [mem 0xf2524000-0xf2524fff]
[    0.722580] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.722605] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.722616] pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
[    0.722627] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.722693] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.722698] pci 0000:00:19.0: PME# disabled
[    0.722731] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.722756] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.722844] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.722848] pci 0000:00:1a.0: PME# disabled
[    0.722879] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.722900] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.722976] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.722980] pci 0000:00:1b.0: PME# disabled
[    0.723009] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.723085] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.723090] pci 0000:00:1c.0: PME# disabled
[    0.723122] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.723197] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.723202] pci 0000:00:1c.3: PME# disabled
[    0.723231] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    0.723308] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.723312] pci 0000:00:1c.4: PME# disabled
[    0.723350] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.723375] pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
[    0.723467] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.723472] pci 0000:00:1d.0: PME# disabled
[    0.723497] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.723573] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.723691] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.723717] pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
[    0.723728] pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
[    0.723738] pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
[    0.723749] pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
[    0.723760] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    0.723770] pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
[    0.723817] pci 0000:00:1f.2: PME# supported from D3hot
[    0.723822] pci 0000:00:1f.2: PME# disabled
[    0.723845] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.723865] pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
[    0.723895] pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
[    0.723942] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.723969] pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
[    0.724105] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.724171] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.724175] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.724180] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.724187] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
[    0.724338] pci 0000:02:00.0: [8086:4238] type 0 class 0x000280
[    0.724402] pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.724596] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.724622] pci 0000:02:00.0: PME# disabled
[    0.731497] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.731505] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.731582] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    0.731595] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.731597] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.731599] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.731601] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.731603] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.731605] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.731631] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.731782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.731820] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.731857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.732022]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.732233]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.732235] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.735294] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.735364] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.735419] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.735495] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.735563] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.735618] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.735673] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.735741] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.735847] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.735855] vgaarb: loaded
[    0.735856] vgaarb: bridge control possible 0000:00:02.0
[    0.735890] PCI: Using ACPI for IRQ routing
[    0.745765] PCI: pci_cache_line_size set to 64 bytes
[    0.745892] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    0.745895] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff 
[    0.745901] reserve RAM buffer: 00000000bb35f000 - 00000000bbffffff 
[    0.745907] reserve RAM buffer: 00000000bb46f000 - 00000000bbffffff 
[    0.745913] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff 
[    0.745917] reserve RAM buffer: 00000000bb76b000 - 00000000bbffffff 
[    0.745921] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff 
[    0.746031] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.746036] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.748057] Switching to clocksource hpet
[    0.749857] pnp: PnP ACPI init
[    0.749871] ACPI: bus type pnp registered
[    0.750514] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.750517] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.750519] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.750521] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.750522] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.750524] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.750526] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.750528] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.750531] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.750533] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.750534] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.750536] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.750538] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.750539] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.750541] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.750543] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.750544] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.750595] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.750598] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.750600] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.750603] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.750605] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.750607] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.750610] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.750612] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.750615] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.750617] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.750619] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.750622] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.750624] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.750627] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.750629] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.750632] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.750644] pnp 00:01: [bus ff]
[    0.750682] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.750697] pnp 00:02: [bus 00-fe]
[    0.750700] pnp 00:02: [io  0x0cf8-0x0cff]
[    0.750702] pnp 00:02: [io  0x0000-0x0cf7 window]
[    0.750704] pnp 00:02: [io  0x0d00-0xffff window]
[    0.750705] pnp 00:02: [mem 0x000a0000-0x000bffff window]
[    0.750707] pnp 00:02: [mem 0x000c0000-0x000c3fff window]
[    0.750709] pnp 00:02: [mem 0x000c4000-0x000c7fff window]
[    0.750711] pnp 00:02: [mem 0x000c8000-0x000cbfff window]
[    0.750713] pnp 00:02: [mem 0x000cc000-0x000cffff window]
[    0.750714] pnp 00:02: [mem 0x000d0000-0x000d3fff window]
[    0.750716] pnp 00:02: [mem 0x000d4000-0x000d7fff window]
[    0.750718] pnp 00:02: [mem 0x000d8000-0x000dbfff window]
[    0.750720] pnp 00:02: [mem 0x000dc000-0x000dffff window]
[    0.750721] pnp 00:02: [mem 0x000e0000-0x000e3fff window]
[    0.750723] pnp 00:02: [mem 0x000e4000-0x000e7fff window]
[    0.750725] pnp 00:02: [mem 0x000e8000-0x000ebfff window]
[    0.750727] pnp 00:02: [mem 0x000ec000-0x000effff window]
[    0.750728] pnp 00:02: [mem 0xc0000000-0xfebfffff window]
[    0.750730] pnp 00:02: [mem 0xfed40000-0xfed4bfff window]
[    0.750766] pnp 00:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.751042] pnp 00:03: [io  0x0010-0x001f]
[    0.751045] pnp 00:03: [io  0x0090-0x009f]
[    0.751047] pnp 00:03: [io  0x0024-0x0025]
[    0.751049] pnp 00:03: [io  0x0028-0x0029]
[    0.751050] pnp 00:03: [io  0x002c-0x002d]
[    0.751052] pnp 00:03: [io  0x0030-0x0031]
[    0.751053] pnp 00:03: [io  0x0034-0x0035]
[    0.751055] pnp 00:03: [io  0x0038-0x0039]
[    0.751056] pnp 00:03: [io  0x003c-0x003d]
[    0.751058] pnp 00:03: [io  0x00a4-0x00a5]
[    0.751059] pnp 00:03: [io  0x00a8-0x00a9]
[    0.751061] pnp 00:03: [io  0x00ac-0x00ad]
[    0.751062] pnp 00:03: [io  0x00b0-0x00b5]
[    0.751064] pnp 00:03: [io  0x00b8-0x00b9]
[    0.751065] pnp 00:03: [io  0x00bc-0x00bd]
[    0.751067] pnp 00:03: [io  0x0050-0x0053]
[    0.751068] pnp 00:03: [io  0x0072-0x0077]
[    0.751070] pnp 00:03: [io  0x164e-0x164f]
[    0.751071] pnp 00:03: [io  0x002e-0x002f]
[    0.751073] pnp 00:03: [io  0x1000-0x107f]
[    0.751074] pnp 00:03: [io  0x1180-0x11ff]
[    0.751076] pnp 00:03: [io  0x0800-0x080f]
[    0.751077] pnp 00:03: [io  0x15e0-0x15ef]
[    0.751079] pnp 00:03: [io  0x1600-0x1641]
[    0.751080] pnp 00:03: [io  0x1644-0x167f]
[    0.751082] pnp 00:03: [mem 0xe0000000-0xefffffff]
[    0.751084] pnp 00:03: [mem 0xfeaff000-0xfeafffff]
[    0.751085] pnp 00:03: [mem 0xfed1c000-0xfed1ffff]
[    0.751087] pnp 00:03: [mem 0xfed10000-0xfed13fff]
[    0.751089] pnp 00:03: [mem 0xfed18000-0xfed18fff]
[    0.751090] pnp 00:03: [mem 0xfed19000-0xfed19fff]
[    0.751093] pnp 00:03: [mem 0xfed45000-0xfed4bfff]
[    0.751158] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.751160] system 00:03: [io  0x1000-0x107f] has been reserved
[    0.751162] system 00:03: [io  0x1180-0x11ff] has been reserved
[    0.751166] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.751168] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.751171] system 00:03: [io  0x1600-0x1641] has been reserved
[    0.751173] system 00:03: [io  0x1644-0x167f] could not be reserved
[    0.751176] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.751179] system 00:03: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.751181] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.751184] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.751186] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.751189] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.751191] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.751194] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.751225] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.751253] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.751262] pnp 00:05: [io  0x0000-0x000f]
[    0.751264] pnp 00:05: [io  0x0080-0x008f]
[    0.751265] pnp 00:05: [io  0x00c0-0x00df]
[    0.751267] pnp 00:05: [dma 4]
[    0.751291] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.751299] pnp 00:06: [io  0x0061]
[    0.751324] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.751332] pnp 00:07: [io  0x00f0]
[    0.751347] pnp 00:07: [irq 13]
[    0.751377] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.751386] pnp 00:08: [io  0x0070-0x0071]
[    0.751391] pnp 00:08: [irq 8]
[    0.751437] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.751447] pnp 00:09: [io  0x0060]
[    0.751449] pnp 00:09: [io  0x0064]
[    0.751454] pnp 00:09: [irq 1]
[    0.751483] pnp 00:09: Plug and Play ACPI device, IDs LEN0010 PNP0303 (active)
[    0.751496] pnp 00:0a: [irq 12]
[    0.751522] pnp 00:0a: Plug and Play ACPI device, IDs LEN0018 PNP0f13 (active)
[    0.751612] pnp 00:0b: Plug and Play ACPI device, IDs WACf00c (disabled)
[    0.751863] pnp 00:0c: [mem 0xfed40000-0xfed44fff]
[    0.751893] pnp 00:0c: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.752387] pnp: PnP ACPI: found 13 devices
[    0.752389] ACPI: ACPI bus type pnp unregistered
[    0.759366] PCI: max bus depth: 1 pci_try_num: 2
[    0.759407] pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
[    0.759421] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.759425] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.759431] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.759436] pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
[    0.759444] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.759450] pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.759460] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.759488] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.759493] pci 0000:00:1c.0: setting latency timer to 64
[    0.759504] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.759509] pci 0000:00:1c.3: setting latency timer to 64
[    0.759516] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.759520] pci 0000:00:1c.4: setting latency timer to 64
[    0.759528] pci 0000:00:1e.0: setting latency timer to 64
[    0.759532] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.759534] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.759535] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.759537] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.759539] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.759541] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.759543] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.759545] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.759546] pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit pref]
[    0.759548] pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.759550] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.759552] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.759554] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.759555] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.759557] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.759559] pci_bus 0000:0e: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.759636] NET: Registered protocol family 2
[    0.759846] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.760939] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.762672] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.762897] TCP: Hash tables configured (established 524288 bind 65536)
[    0.762899] TCP reno registered
[    0.762915] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.762953] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.763101] NET: Registered protocol family 1
[    0.763127] pci 0000:00:02.0: Boot video device
[    0.763256] PCI: CLS 64 bytes, default 64
[    0.763308] Unpacking initramfs...
[    0.981461] Freeing initrd memory: 11860k freed
[    0.984043] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.984048] Placing 64MB software IO TLB between ffff8800b727c000 - ffff8800bb27c000
[    0.984050] software IO TLB at phys 0xb727c000 - 0xbb27c000
[    0.984068] Simple Boot Flag at 0x35 set to 0x80
[    0.984615] audit: initializing netlink socket (disabled)
[    0.984629] type=2000 audit(1327169896.756:1): initialized
[    1.012264] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.042866] VFS: Disk quotas dquot_6.5.2
[    1.042902] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.042985] msgmni has been set to 15604
[    1.043180] alg: No test for stdrng (krng)
[    1.043220] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.043223] io scheduler noop registered
[    1.043224] io scheduler deadline registered
[    1.043246] io scheduler cfq registered (default)
[    1.043597] intel_idle: MWAIT substates: 0x1120
[    1.043599] intel_idle: v0.4 model 0x25
[    1.043600] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.043664] ERST: Table is not found!
[    1.043666] GHES: HEST is not enabled!
[    1.043738] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.272006] serial 00:0b: [io  0x0200-0x0207]
[    1.272093] serial 00:0b: [irq 5]
[    1.272377] serial 00:0b: activated
[    1.272530] 00:0b: ttyS0 at I/O 0x200 (irq = 5) is a NS16550A
[    1.335907] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.356301] 0000:00:16.3: ttyS1 at I/O 0x1808 (irq = 17) is a 16550A
[    1.399957] Linux agpgart interface v0.103
[    1.400026] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.400159] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.401286] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.401454] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.401584] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.406304] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.406312] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.406442] mousedev: PS/2 mouse device common for all mice
[    1.406492] rtc_cmos 00:08: RTC can wake from S4
[    1.406613] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    1.406645] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.406763] cpuidle: using governor ladder
[    1.406924] cpuidle: using governor menu
[    1.407106] TCP cubic registered
[    1.407259] NET: Registered protocol family 10
[    1.407935] Mobile IPv6
[    1.407938] NET: Registered protocol family 17
[    1.407949] Registering the dns_resolver key type
[    1.408281] PM: Hibernation image not present or could not be loaded.
[    1.408302] registered taskstats version 1
[    1.423992] rtc_cmos 00:08: setting system clock to 2012-01-21 18:18:17 UTC (1327169897)
[    1.424093] Initializing network drop monitor service
[    1.425130] Freeing unused kernel memory: 568k freed
[    1.425213] Write protecting the kernel read-only data: 6144k
[    1.427522] Freeing unused kernel memory: 712k freed
[    1.429830] Freeing unused kernel memory: 684k freed
[    1.430753] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.548006] udevd[60]: starting version 175
[    1.571344] usbcore: registered new interface driver usbfs
[    1.571376] usbcore: registered new interface driver hub
[    1.578370] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    1.578373] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    1.578417] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.578432] e1000e 0000:00:19.0: setting latency timer to 64
[    1.578580] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    1.584906] usbcore: registered new device driver usb
[    1.585576] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.589402] SCSI subsystem initialized
[    1.596085] libata version 3.00 loaded.
[    1.600386] thermal LNXTHERM:00: registered as thermal_zone0
[    1.600393] ACPI: Thermal Zone [THM0] (61 C)
[    1.768934] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:38:a0:66
[    1.768937] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.769007] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    1.769089] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.769097] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.769110] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.769149] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.769154] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.769192] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.769250] ehci_hcd 0000:00:1a.0: debug port 2
[    1.773151] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.773172] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
[    1.787742] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.787777] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.787782] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.787785] usb usb1: Product: EHCI Host Controller
[    1.787788] usb usb1: Manufacturer: Linux 3.2.0-1-amd64 ehci_hcd
[    1.787791] usb usb1: SerialNumber: 0000:00:1a.0
[    1.788032] hub 1-0:1.0: USB hub found
[    1.788041] hub 1-0:1.0: 3 ports detected
[    1.788151] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.788157] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.788179] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.788199] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.788205] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.788215] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.788249] ehci_hcd 0000:00:1d.0: debug port 2
[    1.792163] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.792184] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
[    1.811740] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.811822] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.811826] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.811830] usb usb2: Product: EHCI Host Controller
[    1.811832] usb usb2: Manufacturer: Linux 3.2.0-1-amd64 ehci_hcd
[    1.811835] usb usb2: SerialNumber: 0000:00:1d.0
[    1.812146] hub 2-0:1.0: USB hub found
[    1.812154] hub 2-0:1.0: 3 ports detected
[    1.812271] ahci 0000:00:1f.2: version 3.0
[    1.812306] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.812374] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.812431] ahci: SSS flag set, parallel bus scan disabled
[    1.812495] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.812503] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.812512] ahci 0000:00:1f.2: setting latency timer to 64
[    1.836927] scsi0 : ahci
[    1.837147] scsi1 : ahci
[    1.837254] scsi2 : ahci
[    1.837388] scsi3 : ahci
[    1.837517] scsi4 : ahci
[    1.837646] scsi5 : ahci
[    1.838037] ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727100 irq 41
[    1.838040] ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727180 irq 41
[    1.838042] ata3: DUMMY
[    1.838043] ata4: DUMMY
[    1.838046] ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727300 irq 41
[    1.838049] ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727380 irq 41
[    1.983618] Refined TSC clocksource calibration: 2127.999 MHz.
[    1.983625] Switching to clocksource tsc
[    2.099555] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.155566] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.156071] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.156078] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.156083] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.156445] ata1.00: ATA-7: INTEL SSDSA2M160G2LE, 2CV102L1, max UDMA/133
[    2.156451] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.157047] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.157053] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.157059] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.157419] ata1.00: configured for UDMA/133
[    2.157719] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    2.232263] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.232268] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.232694] hub 1-1:1.0: USB hub found
[    2.232818] hub 1-1:1.0: 6 ports detected
[    2.343490] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.475413] ata2: SATA link down (SStatus 0 SControl 300)
[    2.475773] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.475778] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.476203] hub 2-1:1.0: USB hub found
[    2.476396] hub 2-1:1.0: 8 ports detected
[    2.547497] usb 1-1.3: new full-speed USB device number 3 using ehci_hcd
[    2.644082] usb 1-1.3: New USB device found, idVendor=0a5c, idProduct=217f
[    2.644087] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.644090] usb 1-1.3: Product: Broadcom Bluetooth Device
[    2.644093] usb 1-1.3: Manufacturer: Broadcom Corp
[    2.644096] usb 1-1.3: SerialNumber: 889FFAF856CC
[    2.715431] usb 1-1.4: new full-speed USB device number 4 using ehci_hcd
[    2.795268] ata5: SATA link down (SStatus 0 SControl 300)
[    2.808769] usb 1-1.4: New USB device found, idVendor=147e, idProduct=2016
[    2.808774] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.808778] usb 1-1.4: Product: Biometric Coprocessor
[    2.808781] usb 1-1.4: Manufacturer: UPEK
[    2.879356] usb 1-1.5: new high-speed USB device number 5 using ehci_hcd
[    2.971568] usb 1-1.5: New USB device found, idVendor=17ef, idProduct=1005
[    2.971573] usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.972021] hub 1-1.5:1.0: USB hub found
[    2.972156] hub 1-1.5:1.0: 4 ports detected
[    3.043291] usb 1-1.6: new high-speed USB device number 6 using ehci_hcd
[    3.115136] ata6: SATA link down (SStatus 0 SControl 300)
[    3.120411] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.120654] sd 0:0:0:0: [sda] Write Protect is off
[    3.120661] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.120712] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.121442]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    3.122614] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.141203] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=4816
[    3.141209] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.141214] usb 1-1.6: Product: Integrated Camera
[    3.141218] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    3.211221] usb 2-1.4: new high-speed USB device number 3 using ehci_hcd
[    3.305189] usb 2-1.4: config 1 has an invalid interface number: 1 but max is 0
[    3.305194] usb 2-1.4: config 1 has no interface number 0
[    3.306996] usb 2-1.4: New USB device found, idVendor=05c6, idProduct=9204
[    3.307002] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[    3.307007] usb 2-1.4: Product: Qualcomm Gobi 2000
[    3.307010] usb 2-1.4: Manufacturer: Qualcomm Incorporated
[    3.395143] usb 1-1.5.3: new high-speed USB device number 7 using ehci_hcd
[    3.456389] device-mapper: uevent: version 1.0.3
[    3.456498] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.487312] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[    3.487320] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.487771] hub 1-1.5.3:1.0: USB hub found
[    3.487915] hub 1-1.5.3:1.0: 4 ports detected
[    3.663931] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.758988] usb 1-1.5.3.1: new high-speed USB device number 8 using ehci_hcd
[    3.851176] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[    3.851183] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.851581] hub 1-1.5.3.1:1.0: USB hub found
[    3.851805] hub 1-1.5.3.1:1.0: 2 ports detected
[    3.938889] usb 1-1.5.3.3: new low-speed USB device number 9 using ehci_hcd
[    3.977377] udevd[298]: starting version 175
[    4.052312] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[    4.052316] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.052319] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[    4.052321] usb 1-1.5.3.3: Manufacturer: Logitech
[    4.062489] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    4.064119] ACPI: Lid Switch [LID]
[    4.064201] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    4.064209] ACPI: Sleep Button [SLPB]
[    4.064287] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.064291] ACPI: Power Button [PWRF]
[    4.076267] wmi: Mapper loaded
[    4.090340] cfg80211: Calling CRDA to update world regulatory domain
[    4.094366] [drm] Initialized drm 1.1.0 20060810
[    4.097352] ACPI: AC Adapter [AC] (on-line)
[    4.099089] tpm_tis 00:0c: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.104186] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.104192] i915 0000:00:02.0: power state changed by ACPI to D0
[    4.104201] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.104206] i915 0000:00:02.0: setting latency timer to 64
[    4.104284] Non-volatile memory driver v1.3
[    4.106040] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    4.106044] Copyright(c) 2003-2011 Intel Corporation
[    4.106149] iwlwifi 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.106158] iwlwifi 0000:02:00.0: setting latency timer to 64
[    4.106180] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[    4.106184] iwlwifi 0000:02:00.0: pci_resource_base = ffffc90011798000
[    4.106187] iwlwifi 0000:02:00.0: HW Revision ID = 0x35
[    4.106270] iwlwifi 0000:02:00.0: irq 42 for MSI/MSI-X
[    4.106308] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[    4.106397] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    4.117824] Bluetooth: Core ver 2.16
[    4.117845] NET: Registered protocol family 31
[    4.117847] Bluetooth: HCI device and connection manager initialized
[    4.117851] Bluetooth: HCI socket layer initialized
[    4.117853] Bluetooth: L2CAP socket layer initialized
[    4.117858] Bluetooth: SCO socket layer initialized
[    4.122536] iwlwifi 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    4.122540] iwlwifi 0000:02:00.0: Device SKU: 0X1f0
[    4.122543] iwlwifi 0000:02:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[    4.122727] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    4.130040] iTCO_vendor_support: vendor-support=0
[    4.137448] ACPI: Battery Slot [BAT0] (battery present)
[    4.138756] usb 1-1.5.3.4: new low-speed USB device number 10 using ehci_hcd
[    4.139110] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    4.139230] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[    4.139300] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.140200] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.141977] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.141980] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.141982] thinkpad_acpi: ThinkPad BIOS 6QET68WW (1.38 ), EC 6SHT33WW-1.14
[    4.141985] thinkpad_acpi: Lenovo ThinkPad X201 Tablet, model 0831CTO
[    4.144234] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    4.145601] usbcore: registered new interface driver btusb
[    4.150849] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.151012] thinkpad_acpi: radio switch found; radios are enabled
[    4.151294] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    4.154508] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    4.159261] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[    4.159550] Registered led device: tpacpi::thinklight
[    4.159588] Registered led device: tpacpi::power
[    4.159612] Registered led device: tpacpi::standby
[    4.159639] Registered led device: tpacpi::thinkvantage
[    4.164460] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    4.164557] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.166256] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
[    4.196783] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    4.196790] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.196792] [drm] Driver supports precise vblank timestamp query.
[    4.196842] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.211232] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
[    4.211554] Registered led device: phy0-led
[    4.223286] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.252831] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[    4.252835] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.252838] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[    4.252840] usb 1-1.5.3.4: Manufacturer: Logitech
[    4.346744] usb 1-1.5.3.1.1: new high-speed USB device number 11 using ehci_hcd
[    4.477818] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[    4.477824] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.477829] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[    4.477832] usb 1-1.5.3.1.1: Manufacturer: Generic
[    4.477835] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[    4.489734] Linux media interface: v0.10
[    4.490034] usbcore: registered new interface driver uas
[    4.492067] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input6
[    4.493796] Initializing USB Mass Storage driver...
[    4.493809] Linux video capture interface: v2.00
[    4.494092] generic-usb 0003:046D:C01E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[    4.494508] usbcore: registered new interface driver usbserial
[    4.494522] USB Serial support registered for generic
[    4.495309] scsi6 : usb-storage 1-1.5.3.1.1:1.0
[    4.495422] usbcore: registered new interface driver usb-storage
[    4.495424] USB Mass Storage support registered.
[    4.495546] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:4816)
[    4.497034] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input7
[    4.497140] generic-usb 0003:046D:C317.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[    4.497564] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input8
[    4.497665] usbcore: registered new interface driver uvcvideo
[    4.497667] USB Video Class driver (1.1.1)
[    4.503370] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input9
[    4.503589] generic-usb 0003:046D:C317.0003: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[    4.503628] usbcore: registered new interface driver usbhid
[    4.503633] usbhid: USB HID core driver
[    4.503732] usbcore: registered new interface driver usbserial_generic
[    4.503735] usbserial: USB Serial Driver core
[    4.505395] USB Serial support registered for Qualcomm USB modem
[    4.505431] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[    4.505526] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[    4.505554] usbcore: registered new interface driver qcserial
[    4.574409] fbcon: inteldrmfb (fb0) is primary device
[    4.576286] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[    4.979524] Console: switching to colour frame buffer device 160x50
[    4.982484] fb0: inteldrmfb frame buffer device
[    4.982485] drm: registered panic notifier
[    4.989070] acpi device:02: registered as cooling_device4
[    4.989303] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[    4.989402] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    4.989493] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.989619] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.989805] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 18, expected 21)
[    4.989815] intel ips 0000:00:1f.6: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.989951] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    4.990165] snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.990237] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    4.990278] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    5.031832] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input11
[    5.095332] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd047b3/0xb40000/0xa0000
[    5.095347] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    5.152690] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input12
[    5.499931] scsi 6:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[    5.509184] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    6.037908] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[    6.044583] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[    6.044588] HDMI: available speakers: FL/FR LFE FC RL/RR
[    6.044596] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[    6.044868] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    6.154208] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    6.288830] EXT4-fs (sda2): re-mounted. Opts: (null)
[    6.335689] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    6.370291] loop: module loaded
[    6.641988] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    6.884233] RPC: Registered named UNIX socket transport module.
[    6.884238] RPC: Registered udp transport module.
[    6.884241] RPC: Registered tcp transport module.
[    6.884244] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.891376] FS-Cache: Loaded
[    6.899497] FS-Cache: Netfs 'nfs' registered for caching
[    6.906106] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.961164] fuse init (API version 7.17)
[    7.321512] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    7.377379] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    7.378204] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.696750] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[    7.698909] NFSD: starting 90-second grace period
[    8.622797] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
[    8.810908] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.810913] Bluetooth: BNEP filters: protocol multicast
[    8.810961] Bluetooth: RFCOMM TTY layer initialized
[    8.810966] Bluetooth: RFCOMM socket layer initialized
[    8.810968] Bluetooth: RFCOMM ver 1.11
[    8.934994] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
[    8.935003] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    8.935842] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    9.088755] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    9.095340] iwlwifi 0000:02:00.0: Radio type=0x0-0x3-0x1
[    9.336235] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    9.342810] iwlwifi 0000:02:00.0: Radio type=0x0-0x3-0x1
[    9.450455] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   10.104545] lp: driver loaded but no devices found
[   10.108041] ppdev: user-space parallel port driver
[   10.216144] Bridge firewalling registered
[   10.296135] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.337596] ADDRCONF(NETDEV_UP): virbr1: link is not ready
[   10.375500] e1000e 0000:00:19.0: eth0: changing MTU from 1500 to 1392
[   10.500932] e1000e 0000:00:19.0: eth0: Reset adapter
[   10.514652] Ebtables v2.0 registered
[   10.526192] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   10.999844] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   10.999909] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   11.299663] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   11.303243] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[   11.303247] HDMI: available speakers: FL/FR LFE FC RL/RR
[   11.303252] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[   12.265583] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
[   12.265591] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   12.579699] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.898253] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input15
[   12.942284] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
[   12.956822] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   19.032390] eth0: no IPv6 routers present
[   28.492558] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   28.492610] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   28.792259] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   28.795872] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[   28.795878] HDMI: available speakers: FL/FR LFE FC RL/RR
[   28.795886] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[   34.636677] wlan0: direct probe to 00:10:18:90:20:db (try 1/3)
[   34.639442] wlan0: direct probe responded
[   34.657752] wlan0: authenticate with 00:10:18:90:20:db (try 1)
[   34.659877] wlan0: authenticated
[   34.660181] wlan0: associate with 00:10:18:90:20:db (try 1)
[   34.662522] wlan0: RX AssocResp from 00:10:18:90:20:db (capab=0x411 status=0 aid=7)
[   34.662528] wlan0: associated
[   34.668714] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   34.688037] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   36.215234] Bluetooth: TIOCGSERIAL is not supported
[   37.042629] Bluetooth: TIOCGSERIAL is not supported
[   38.467812] Bluetooth: TIOCGSERIAL is not supported
[   43.362943] PPP generic driver version 2.4.2
[   43.458743] PPP BSD Compression module registered
[   43.462340] PPP Deflate Compression module registered
[   45.241247] wlan0: no IPv6 routers present
[   48.864820] usb 1-1.5.3.1: USB disconnect, device number 8
[   48.864826] usb 1-1.5.3.1.1: USB disconnect, device number 11
[   49.417747] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.418494] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.421805] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.425832] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.425936] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.429952] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.430044] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.434069] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.434178] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.438292] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.442337] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.442366] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.446385] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.450443] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.450536] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.454560] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.454680] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.458696] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.458849] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.462908] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.462951] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.466962] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.467004] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.471051] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.471157] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.475210] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.475292] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.479316] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.479373] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.483462] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.483494] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.487529] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.487618] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.491682] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.491772] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.495776] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.495867] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.499927] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.500022] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.504035] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.504158] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.508170] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.508277] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.512301] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.512411] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.516389] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.516515] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.520495] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.520637] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.524629] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.524767] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.528756] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.528890] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.532883] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.533009] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.536991] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.537129] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.541155] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.541237] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.545251] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.545387] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.549405] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.549504] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.553485] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.553595] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.557620] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.557712] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.561741] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.561836] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.565903] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.566000] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.569986] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.570116] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.574209] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.578258] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.582205] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.585901] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.586261] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.589825] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.593987] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.597976] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.601859] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.601949] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.605974] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.606067] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.610195] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.610226] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.614478] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.617250] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.618497] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.621224] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.625232] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[   49.625349] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.629340] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[   49.629462] usb 1-1.5.3: clear tt 4 (00a0) error -71
[   49.631060] usb 1-1.5.3: USB disconnect, device number 7
[   49.631065] usb 1-1.5.3.3: USB disconnect, device number 9
[   49.633486] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[   49.633497] usb 1-1.5.3: clear tt 4 (00a0) error -19
[   49.633637] usb 1-1.5.3: clear tt 3 (0090) error -71
[   49.683987] usb 1-1.5.3.4: USB disconnect, device number 10
[   52.276522] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
[   52.276528] ata2: irq_stat 0x00000040, connection status changed
[   52.276532] ata2: SError: { DevExch }
[   52.276543] ata2: hard resetting link
[   52.638311] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[   52.998102] ata2: SATA link down (SStatus 0 SControl 300)
[   53.014088] ata2: EH complete
[   53.106436] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
[   53.106441] ata2: irq_stat 0x00000040, connection status changed
[   53.106445] ata2: SError: { DevExch }
[   53.106455] ata2: limiting SATA link speed to 1.5 Gbps
[   53.106459] ata2: hard resetting link
[   54.821335] ata2: SATA link down (SStatus 0 SControl 310)
[   54.837318] ata2: EH complete
[   56.216833] usb 1-1.5.3: new high-speed USB device number 12 using ehci_hcd
[   56.309061] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[   56.309066] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   56.309437] hub 1-1.5.3:1.0: USB hub found
[   56.309492] hub 1-1.5.3:1.0: 4 ports detected
[   56.580699] usb 1-1.5.3.1: new high-speed USB device number 13 using ehci_hcd
[   56.672905] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[   56.672910] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   56.673353] hub 1-1.5.3.1:1.0: USB hub found
[   56.673503] hub 1-1.5.3.1:1.0: 2 ports detected
[   56.748628] usb 1-1.5.3.3: new low-speed USB device number 14 using ehci_hcd
[   56.862115] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[   56.862122] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   56.862126] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[   56.862130] usb 1-1.5.3.3: Manufacturer: Logitech
[   56.866446] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input16
[   56.866806] generic-usb 0003:046D:C01E.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[   56.952532] usb 1-1.5.3.4: new low-speed USB device number 15 using ehci_hcd
[   57.067030] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[   57.067037] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   57.067041] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[   57.067045] usb 1-1.5.3.4: Manufacturer: Logitech
[   57.070665] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input17
[   57.070916] generic-usb 0003:046D:C317.0005: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[   57.077817] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input18
[   57.078154] generic-usb 0003:046D:C317.0006: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[   57.164457] usb 1-1.5.3.1.1: new high-speed USB device number 16 using ehci_hcd
[   57.295548] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[   57.295554] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   57.295558] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[   57.295561] usb 1-1.5.3.1.1: Manufacturer: Generic
[   57.295563] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[   57.296037] scsi7 : usb-storage 1-1.5.3.1.1:1.0
[   58.301666] scsi 7:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[   58.313030] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[   94.008829] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   94.008900] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   94.308767] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   94.608564] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[   94.614541] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[   94.614547] HDMI: available speakers: FL/FR LFE FC RL/RR
[   94.614555] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  116.799251] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  116.799302] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  117.098963] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  117.102671] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  117.102674] HDMI: available speakers: FL/FR LFE FC RL/RR
[  117.102678] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  156.342496] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  156.342548] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  156.642345] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  156.942258] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  157.242042] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  833.948350] usb 1-1.5.3.1: USB disconnect, device number 13
[  833.948355] usb 1-1.5.3.1.1: USB disconnect, device number 16
[  834.299980] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.304041] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.304718] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.308078] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.308930] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.313050] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.313081] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.317072] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.317275] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.321315] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.321429] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.325404] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.325532] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.329533] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.329656] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.333669] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.333788] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.337901] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.341894] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.344691] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.345907] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.349954] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.350038] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.354021] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.354146] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.358174] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.358272] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.362408] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.366439] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.368674] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.370405] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.374406] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.374561] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.378548] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.378607] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.382674] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.382771] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.386901] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.390924] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.392681] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.394874] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.398926] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.398978] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.402999] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.403091] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.407115] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.407245] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.411374] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.415396] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.416619] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.419338] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.423382] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.423490] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.427518] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.427614] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.431661] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.431703] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.435859] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.439878] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.440643] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.443825] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.447898] generic-usb 0003:046D:C317.0006: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  834.447998] usb 1-1.5.3: clear tt 3 (00e0) error -71
[  834.451833] usb 1-1.5.3: USB disconnect, device number 12
[  834.451840] usb 1-1.5.3.3: USB disconnect, device number 14
[  834.451995] generic-usb 0003:046D:C01E.0004: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  834.452004] usb 1-1.5.3: clear tt 3 (00e0) error -19
[  834.452085] usb 1-1.5.3: clear tt 4 (00f0) error -71
[  834.456128] generic-usb 0003:046D:C317.0005: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  834.456136] usb 1-1.5.3: clear tt 4 (00f0) error -19
[  834.584143] usb 1-1.5.3.4: USB disconnect, device number 15
[  838.518273] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  838.518344] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  838.818098] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  838.824421] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  838.824426] HDMI: available speakers: FL/FR LFE FC RL/RR
[  838.824434] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  839.785757] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  839.785809] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  840.085515] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  840.089354] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  840.089356] HDMI: available speakers: FL/FR LFE FC RL/RR
[  840.089360] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  841.037244] usb 1-1.5.3: new high-speed USB device number 17 using ehci_hcd
[  841.129449] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[  841.129454] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  841.129881] hub 1-1.5.3:1.0: USB hub found
[  841.130004] hub 1-1.5.3:1.0: 4 ports detected
[  841.401085] usb 1-1.5.3.1: new high-speed USB device number 18 using ehci_hcd
[  841.493292] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[  841.493297] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  841.493704] hub 1-1.5.3.1:1.0: USB hub found
[  841.493896] hub 1-1.5.3.1:1.0: 2 ports detected
[  841.581012] usb 1-1.5.3.3: new low-speed USB device number 19 using ehci_hcd
[  841.678254] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[  841.678260] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  841.678265] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[  841.678269] usb 1-1.5.3.3: Manufacturer: Logitech
[  841.682844] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input19
[  841.683155] generic-usb 0003:046D:C01E.0007: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[  841.768941] usb 1-1.5.3.4: new low-speed USB device number 20 using ehci_hcd
[  841.882792] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[  841.882797] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  841.882801] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[  841.882804] usb 1-1.5.3.4: Manufacturer: Logitech
[  841.886315] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input20
[  841.886587] generic-usb 0003:046D:C317.0008: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[  841.893341] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input21
[  841.893609] generic-usb 0003:046D:C317.0009: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[  841.980839] usb 1-1.5.3.1.1: new high-speed USB device number 21 using ehci_hcd
[  842.111688] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[  842.111694] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  842.111698] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[  842.111701] usb 1-1.5.3.1.1: Manufacturer: Generic
[  842.111703] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[  842.112167] scsi8 : usb-storage 1-1.5.3.1.1:1.0
[  843.113961] scsi 8:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[  843.124601] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[  893.832324] usb 1-1.5.3.1: USB disconnect, device number 18
[  893.832330] usb 1-1.5.3.1.1: USB disconnect, device number 21
[  894.015895] generic-usb 0003:046D:C317.0009: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  894.019978] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.020644] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.024020] generic-usb 0003:046D:C317.0009: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  894.024728] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.028843] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.028873] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.032862] generic-usb 0003:046D:C317.0008: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  894.033072] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.037109] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.037224] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.041271] generic-usb 0003:046D:C317.0009: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  894.041329] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.045380] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.045492] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.049493] generic-usb 0003:046D:C317.0008: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  894.049581] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.053605] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.053713] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.057728] generic-usb 0003:046D:C317.0009: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  894.057828] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.061856] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.061960] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.065973] generic-usb 0003:046D:C317.0008: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  894.066064] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.070097] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.070194] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.074191] generic-usb 0003:046D:C317.0009: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  894.074282] usb 1-1.5.3: clear tt 3 (0130) error -71
[  894.074660] usb 1-1.5.3: USB disconnect, device number 17
[  894.074666] usb 1-1.5.3.3: USB disconnect, device number 19
[  894.078319] generic-usb 0003:046D:C01E.0007: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  894.078436] usb 1-1.5.3: clear tt 4 (0140) error -71
[  894.078444] usb 1-1.5.3: clear tt 3 (0130) error -19
[  894.163117] usb 1-1.5.3.4: USB disconnect, device number 20
[  895.038446] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  895.038562] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  895.338232] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  895.344887] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  895.344892] HDMI: available speakers: FL/FR LFE FC RL/RR
[  895.344900] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  896.337847] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  896.337898] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  896.637612] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  896.641348] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  896.641352] HDMI: available speakers: FL/FR LFE FC RL/RR
[  896.641357] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  897.845314] usb 1-1.5.3: new high-speed USB device number 22 using ehci_hcd
[  897.937594] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[  897.937599] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  897.938015] hub 1-1.5.3:1.0: USB hub found
[  897.938205] hub 1-1.5.3:1.0: 4 ports detected
[  898.209120] usb 1-1.5.3.1: new high-speed USB device number 23 using ehci_hcd
[  898.301614] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[  898.301620] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  898.302013] hub 1-1.5.3.1:1.0: USB hub found
[  898.302182] hub 1-1.5.3.1:1.0: 2 ports detected
[  898.389047] usb 1-1.5.3.3: new low-speed USB device number 24 using ehci_hcd
[  898.502517] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[  898.502522] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  898.502526] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[  898.502529] usb 1-1.5.3.3: Manufacturer: Logitech
[  898.506626] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input22
[  898.507009] generic-usb 0003:046D:C01E.000A: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[  898.592968] usb 1-1.5.3.4: new low-speed USB device number 25 using ehci_hcd
[  898.706928] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[  898.706934] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  898.706939] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[  898.706943] usb 1-1.5.3.4: Manufacturer: Logitech
[  898.710176] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input23
[  898.710446] generic-usb 0003:046D:C317.000B: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[  898.716855] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input24
[  898.717139] generic-usb 0003:046D:C317.000C: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[  898.788869] usb 1-1.5.3.1.1: new high-speed USB device number 26 using ehci_hcd
[  898.919710] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[  898.919715] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  898.919719] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[  898.919722] usb 1-1.5.3.1.1: Manufacturer: Generic
[  898.919725] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[  898.920212] scsi9 : usb-storage 1-1.5.3.1.1:1.0
[  899.921969] scsi 9:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[  899.931993] sd 9:0:0:0: [sdb] Attached SCSI removable disk
[  912.773329] usb 1-1.5.3.1: USB disconnect, device number 23
[  912.773334] usb 1-1.5.3.1.1: USB disconnect, device number 26
[  913.002892] generic-usb 0003:046D:C01E.000A: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  913.006951] usb 1-1.5.3: clear tt 3 (0180) error -71
[  913.010676] usb 1-1.5.3: USB disconnect, device number 22
[  913.010681] usb 1-1.5.3.3: USB disconnect, device number 24
[  913.011125] usb 1-1.5.3: clear tt 4 (0190) error -71
[  913.015205] usb 1-1.5.3: clear tt 4 (0190) error -19
[  913.015215] generic-usb 0003:046D:C317.000C: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  913.021988] generic-usb 0003:046D:C317.000B: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  913.083205] usb 1-1.5.3.4: USB disconnect, device number 25
[  914.542178] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  914.542302] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  914.841898] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  914.845460] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  914.845463] HDMI: available speakers: FL/FR LFE FC RL/RR
[  914.845466] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  915.561775] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=0
[  915.561825] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  915.562009] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  915.562044] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  915.861473] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  915.865024] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  915.865029] HDMI: available speakers: FL/FR LFE FC RL/RR
[  915.865033] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  917.037027] usb 1-1.5.3: new high-speed USB device number 27 using ehci_hcd
[  917.129493] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[  917.129498] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  917.129929] hub 1-1.5.3:1.0: USB hub found
[  917.130060] hub 1-1.5.3:1.0: 4 ports detected
[  917.401020] usb 1-1.5.3.1: new high-speed USB device number 28 using ehci_hcd
[  917.493338] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[  917.493344] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  917.493763] hub 1-1.5.3.1:1.0: USB hub found
[  917.493940] hub 1-1.5.3.1:1.0: 2 ports detected
[  917.568829] usb 1-1.5.3.3: new low-speed USB device number 29 using ehci_hcd
[  917.682176] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[  917.682182] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  917.682187] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[  917.682191] usb 1-1.5.3.3: Manufacturer: Logitech
[  917.686745] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input25
[  917.687099] generic-usb 0003:046D:C01E.000D: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[  917.772700] usb 1-1.5.3.4: new low-speed USB device number 30 using ehci_hcd
[  917.875199] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[  917.875205] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  917.875210] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[  917.875214] usb 1-1.5.3.4: Manufacturer: Logitech
[  917.878594] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input26
[  917.878894] generic-usb 0003:046D:C317.000E: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[  917.885549] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input27
[  917.885907] generic-usb 0003:046D:C317.000F: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[  917.972779] usb 1-1.5.3.1.1: new high-speed USB device number 31 using ehci_hcd
[  918.103587] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[  918.103592] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  918.103596] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[  918.103599] usb 1-1.5.3.1.1: Manufacturer: Generic
[  918.103602] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[  918.104112] scsi10 : usb-storage 1-1.5.3.1.1:1.0
[  919.105871] scsi 10:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[  919.116224] sd 10:0:0:0: [sdb] Attached SCSI removable disk
[  935.808607] usb 1-1.5.3.1: USB disconnect, device number 28
[  935.808612] usb 1-1.5.3.1.1: USB disconnect, device number 31
[  936.085906] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.087749] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.089965] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.093991] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.094092] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.098119] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.098176] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.102328] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.106347] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.108707] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.110323] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.114353] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.114459] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.118446] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.118570] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.122556] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.122694] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.126735] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.126850] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.130820] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.130942] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.134941] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.135066] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.139047] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.139156] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.143179] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.143275] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.147357] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.147439] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.151480] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.151566] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.155567] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.155700] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.159710] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.159815] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.163829] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.163952] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.167953] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.168074] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.172064] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.172185] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.176200] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.176306] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.180294] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.180388] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.184444] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.184542] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.188635] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.192053] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.192691] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.196043] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.200055] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.200172] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.204252] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.208316] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.212253] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.212658] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.216624] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.223830] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.227898] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.228677] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.231911] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.232665] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.236736] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.237028] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.240780] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.240985] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.245047] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.245141] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.249262] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.253261] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.255644] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.257232] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.261354] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.265400] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.268653] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.269387] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.273407] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.273554] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.277596] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.277636] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.281612] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.281718] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.285843] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.289925] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.292655] generic-usb 0003:046D:C01E.000D: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[  936.293872] usb 1-1.5.3: clear tt 4 (01e0) error -71
[  936.296838] usb 1-1.5.3: USB disconnect, device number 27
[  936.296842] usb 1-1.5.3.3: USB disconnect, device number 29
[  936.297920] generic-usb 0003:046D:C317.000E: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[  936.298010] usb 1-1.5.3: clear tt 3 (01d0) error -71
[  936.298017] usb 1-1.5.3: clear tt 4 (01e0) error -19
[  936.302023] generic-usb 0003:046D:C317.000F: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[  936.302032] usb 1-1.5.3: clear tt 4 (01e0) error -19
[  936.357191] usb 1-1.5.3.4: USB disconnect, device number 30
[  937.328513] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=0
[  937.328575] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  937.328760] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  937.328805] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  937.628313] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  937.632150] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  937.632171] HDMI: available speakers: FL/FR LFE FC RL/RR
[  937.632182] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  938.364064] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  938.364165] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  938.663835] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[  938.667423] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[  938.667427] HDMI: available speakers: FL/FR LFE FC RL/RR
[  938.667432] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[  939.811565] usb 1-1.5.3: new high-speed USB device number 32 using ehci_hcd
[  939.903883] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[  939.903888] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  939.904275] hub 1-1.5.3:1.0: USB hub found
[  939.904469] hub 1-1.5.3:1.0: 4 ports detected
[  940.175407] usb 1-1.5.3.1: new high-speed USB device number 33 using ehci_hcd
[  940.267724] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[  940.267730] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  940.268171] hub 1-1.5.3.1:1.0: USB hub found
[  940.268338] hub 1-1.5.3.1:1.0: 2 ports detected
[  940.355337] usb 1-1.5.3.3: new low-speed USB device number 34 using ehci_hcd
[  940.468307] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[  940.468312] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  940.468316] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[  940.468319] usb 1-1.5.3.3: Manufacturer: Logitech
[  940.472985] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input28
[  940.473271] generic-usb 0003:046D:C01E.0010: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[  940.547255] usb 1-1.5.3.4: new low-speed USB device number 35 using ehci_hcd
[  940.661230] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[  940.661236] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  940.661241] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[  940.661244] usb 1-1.5.3.4: Manufacturer: Logitech
[  940.664568] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input29
[  940.664814] generic-usb 0003:046D:C317.0011: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[  940.671183] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input30
[  940.671442] generic-usb 0003:046D:C317.0012: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[  940.743017] usb 1-1.5.3.1.1: new high-speed USB device number 36 using ehci_hcd
[  940.873976] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[  940.873981] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  940.873985] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[  940.873988] usb 1-1.5.3.1.1: Manufacturer: Generic
[  940.873991] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[  940.874489] scsi11 : usb-storage 1-1.5.3.1.1:1.0
[  941.876527] scsi 11:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[  941.886697] sd 11:0:0:0: [sdb] Attached SCSI removable disk
[ 1039.193727] usb 1-1.5.3.1: USB disconnect, device number 33
[ 1039.193732] usb 1-1.5.3.1.1: USB disconnect, device number 36
[ 1039.448023] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.449776] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.452105] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.456130] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.456186] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.460251] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.460333] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.464375] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.464481] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.468517] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.468575] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.472630] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.472727] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.476732] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.476835] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.480874] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.480946] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.484991] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.485077] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.489127] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.489223] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.493191] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.493339] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.497486] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.497573] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.501615] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.501690] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.505731] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.505830] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.509842] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.509956] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.513960] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.514065] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.518102] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.518180] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.522228] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.522327] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.526317] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.526451] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.530476] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.530552] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.534600] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.534656] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.538719] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.538802] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.542830] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.542942] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.546965] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.547042] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.551092] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.551189] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.555309] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.559335] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.559451] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.563307] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.567337] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.567381] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.571464] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.571578] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.575575] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.575651] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.579788] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.583837] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.587868] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.591056] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.595022] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.599576] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.600052] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.603666] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.607688] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.607783] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.611816] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.611899] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.615939] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.616021] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.620058] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.620141] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.624190] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.624262] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.628307] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.628382] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.632428] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.632516] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.636540] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.636649] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.640677] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.640784] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.644802] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.644887] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.648925] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.649001] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.653031] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.653130] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.657154] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.657240] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.661284] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.661388] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.665413] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.665470] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.669523] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.669631] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.673666] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.673751] usb 1-1.5.3: clear tt 4 (0230) error -71
[ 1039.677257] usb 1-1.5.3: USB disconnect, device number 32
[ 1039.677262] usb 1-1.5.3.3: USB disconnect, device number 34
[ 1039.677721] generic-usb 0003:046D:C317.0012: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1039.677871] usb 1-1.5.3: clear tt 3 (0220) error -71
[ 1039.677879] usb 1-1.5.3: clear tt 4 (0230) error -19
[ 1039.681888] generic-usb 0003:046D:C01E.0010: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1039.681898] generic-usb 0003:046D:C317.0011: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1039.681906] usb 1-1.5.3: clear tt 4 (0230) error -19
[ 1039.681911] usb 1-1.5.3: clear tt 3 (0220) error -19
[ 1039.765529] usb 1-1.5.3.4: USB disconnect, device number 35
[ 1041.708436] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1041.708498] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1042.008188] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1042.011748] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[ 1042.011751] HDMI: available speakers: FL/FR LFE FC RL/RR
[ 1042.011755] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[ 1042.715982] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1042.716034] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1043.015740] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1043.019324] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[ 1043.019326] HDMI: available speakers: FL/FR LFE FC RL/RR
[ 1043.019330] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[ 1044.215358] usb 1-1.5.3: new high-speed USB device number 37 using ehci_hcd
[ 1044.307702] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[ 1044.307708] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 1044.308235] hub 1-1.5.3:1.0: USB hub found
[ 1044.308423] hub 1-1.5.3:1.0: 4 ports detected
[ 1044.579228] usb 1-1.5.3.1: new high-speed USB device number 38 using ehci_hcd
[ 1044.671661] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[ 1044.671666] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 1044.672099] hub 1-1.5.3.1:1.0: USB hub found
[ 1044.672272] hub 1-1.5.3.1:1.0: 2 ports detected
[ 1044.759132] usb 1-1.5.3.3: new low-speed USB device number 39 using ehci_hcd
[ 1044.872491] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[ 1044.872496] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1044.872500] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[ 1044.872503] usb 1-1.5.3.3: Manufacturer: Logitech
[ 1044.876969] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input31
[ 1044.877284] generic-usb 0003:046D:C01E.0013: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[ 1044.963233] usb 1-1.5.3.4: new low-speed USB device number 40 using ehci_hcd
[ 1045.077142] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[ 1045.077149] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1045.077153] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[ 1045.077157] usb 1-1.5.3.4: Manufacturer: Logitech
[ 1045.080535] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input32
[ 1045.080781] generic-usb 0003:046D:C317.0014: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[ 1045.087630] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input33
[ 1045.087939] generic-usb 0003:046D:C317.0015: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[ 1045.178971] usb 1-1.5.3.1.1: new high-speed USB device number 41 using ehci_hcd
[ 1045.309895] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[ 1045.309900] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1045.309904] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[ 1045.309907] usb 1-1.5.3.1.1: Manufacturer: Generic
[ 1045.309910] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[ 1045.310406] scsi12 : usb-storage 1-1.5.3.1.1:1.0
[ 1046.312198] scsi 12:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[ 1046.322174] sd 12:0:0:0: [sdb] Attached SCSI removable disk
[ 1048.636192] wlan0: deauthenticating from 00:10:18:90:20:db by local choice (reason=3)
[ 1048.651600] cfg80211: Calling CRDA to update world regulatory domain
[ 1049.508954] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
[ 1049.513049] EXT4-fs (sda3): re-mounted. Opts: commit=0
[ 1049.656451] usb 1-1.3: USB disconnect, device number 3
[ 1049.656652] Bluetooth: hci0 urb ffff880230165440 submission failed
[ 1050.026502] PM: Syncing filesystems ... done.
[ 1050.028637] PM: Preparing system for mem sleep
[ 1050.884507] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1050.884570] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1051.184468] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1051.190817] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[ 1051.190819] HDMI: available speakers: FL/FR LFE FC RL/RR
[ 1051.190823] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[ 1051.732213] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1051.732268] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1051.902232] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1051.915977] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1051.931973] PM: Entering mem sleep
[ 1051.932099] Suspending console(s) (use no_console_suspend to debug)
[ 1052.032005] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
[ 1052.038412] HDMI: detected monitor DELL U3011 at connection type DisplayPort
[ 1052.038415] HDMI: available speakers: FL/FR LFE FC RL/RR
[ 1052.038418] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
[ 1052.121975] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1052.122118] sd 0:0:0:0: [sda] Stopping disk
[ 1052.375921] serial 00:0b: disabled
[ 1052.376025] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[ 1052.376036] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[ 1052.376097] ACPI handle has no context!
[ 1052.407809] i915 0000:00:02.0: power state changed by ACPI to D3
[ 1052.550531] e1000e 0000:00:19.0: PCI INT A disabled
[ 1052.550539] e1000e 0000:00:19.0: PME# enabled
[ 1052.550546] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1052.583954] snd_hda_intel 0000:00:1b.0: PCI INT B disabled
[ 1052.599846] PM: suspend of devices complete after 667.825 msecs
[ 1052.615822] ehci_hcd 0000:00:1d.0: PME# enabled
[ 1052.615827] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[ 1052.631653] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[ 1052.631713] ehci_hcd 0000:00:1a.0: PME# enabled
[ 1052.631722] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[ 1052.647645] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[ 1052.647769] PM: late suspend of devices complete after 47.935 msecs
[ 1052.647953] ACPI: Preparing to enter system sleep state S3
[ 1052.859602] PM: Saving platform NVS memory
[ 1052.864120] Disabling non-boot CPUs ...
[ 1052.967524] CPU 1 is now offline
[ 1053.071469] CPU 2 is now offline
[ 1053.175438] CPU 3 is now offline
[ 1053.176134] Extended CMOS year: 2000
[ 1053.176425] ACPI: Low-level resume complete
[ 1053.176481] PM: Restoring platform NVS memory
[ 1053.177138] Extended CMOS year: 2000
[ 1053.177188] Enabling non-boot CPUs ...
[ 1053.177355] Booting Node 0 Processor 1 APIC 0x1
[ 1053.177357] smpboot cpu 1: start_ip = 99000
[ 1053.188384] Calibrating delay loop (skipped) already calibrated this CPU
[ 1053.208813] NMI watchdog enabled, takes one hw-pmu counter.
[ 1053.272489] CPU1 is up
[ 1053.272675] Booting Node 0 Processor 2 APIC 0x4
[ 1053.272677] smpboot cpu 2: start_ip = 99000
[ 1053.283704] Calibrating delay loop (skipped) already calibrated this CPU
[ 1053.304197] NMI watchdog enabled, takes one hw-pmu counter.
[ 1053.368452] CPU2 is up
[ 1053.368646] Booting Node 0 Processor 3 APIC 0x5
[ 1053.368648] smpboot cpu 3: start_ip = 99000
[ 1053.379674] Calibrating delay loop (skipped) already calibrated this CPU
[ 1053.400314] NMI watchdog enabled, takes one hw-pmu counter.
[ 1053.464479] CPU3 is up
[ 1053.467649] ACPI: Waking up from system sleep state S3
[ 1053.800289] agpgart-intel 0000:00:00.0: restoring config space at offset 0x1 (was 0x900006, writing 0x20900006)
[ 1053.800304] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[ 1053.800450] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[ 1053.800467] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728000)
[ 1053.800475] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[ 1053.800497] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[ 1053.800501] ehci_hcd 0000:00:1a.0: PME# disabled
[ 1053.800505] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1053.800508] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1053.800585] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[ 1053.800683] pcieport 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
[ 1053.800694] pcieport 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[ 1053.800699] pcieport 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf240f240)
[ 1053.800704] pcieport 0000:00:1c.4: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
[ 1053.800712] pcieport 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[ 1053.800718] pcieport 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[ 1053.800752] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[ 1053.800770] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728400)
[ 1053.800777] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[ 1053.800795] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[ 1053.800800] ehci_hcd 0000:00:1d.0: PME# disabled
[ 1053.800802] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1053.800806] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1053.800907] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[ 1053.800974] intel ips 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[ 1053.800995] intel ips 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[ 1053.801209] PM: early resume of devices complete after 1.017 msecs
[ 1053.801332] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1053.801338] e1000e 0000:00:19.0: PME# disabled
[ 1053.801394] i915 0000:00:02.0: power state changed by ACPI to D0
[ 1053.801402] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1053.801508] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[ 1053.804478] pci 0000:00:1e.0: setting latency timer to 64
[ 1053.804548] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1053.804593] snd_hda_intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 1053.804604] i915 0000:00:02.0: power state changed by ACPI to D0
[ 1053.804613] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1053.804618] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[ 1053.804625] i915 0000:00:02.0: setting latency timer to 64
[ 1053.804632] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[ 1053.804649] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1053.804718] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[ 1053.808125] ahci 0000:00:1f.2: setting latency timer to 64
[ 1053.808137] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1053.808146] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[ 1053.808156] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1053.808266] sd 0:0:0:0: [sda] Starting disk
[ 1053.824860] serial 00:0b: activated
[ 1053.849844] Extended CMOS year: 2000
[ 1054.056348] usb 1-1.4: reset full-speed USB device number 4 using ehci_hcd
[ 1054.128047] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1054.128665] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1054.128669] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1054.128671] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1054.129373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 1054.129379] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 1054.129384] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[ 1054.129689] ata1.00: configured for UDMA/133
[ 1054.136052] ata5: SATA link down (SStatus 0 SControl 300)
[ 1054.144005] ata2: SATA link down (SStatus 0 SControl 310)
[ 1054.152085] ata6: SATA link down (SStatus 0 SControl 300)
[ 1054.220351] usb 1-1.6: reset high-speed USB device number 6 using ehci_hcd
[ 1054.388097] usb 2-1.4: reset high-speed USB device number 3 using ehci_hcd
[ 1054.482636] qcserial 2-1.4:1.1: no reset_resume for driver qcserial?
[ 1054.482814] qcserial ttyUSB0: Qualcomm USB modem converter now disconnected from ttyUSB0
[ 1054.482830] qcserial 2-1.4:1.1: device disconnected
[ 1054.482926] PM: resume of devices complete after 681.939 msecs
[ 1054.482990] qcserial 2-1.4:1.1: Qualcomm USB modem converter detected
[ 1054.483104] usb 2-1.4: Qualcomm USB modem converter now attached to ttyUSB0
[ 1054.483269] PM: Finishing wakeup.
[ 1054.483274] Restarting tasks ... done.
[ 1054.485215] video LNXVIDEO:00: Restoring backlight state
[ 1054.637239] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
[ 1054.641907] EXT4-fs (sda3): re-mounted. Opts: commit=0
[ 1054.676162] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[ 1054.676301] iwlwifi 0000:02:00.0: Radio type=0x0-0x3-0x1
[ 1054.797014] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1055.027818] usb 1-1.3: new full-speed USB device number 42 using ehci_hcd
[ 1055.124230] usb 1-1.3: New USB device found, idVendor=0a5c, idProduct=217f
[ 1055.124237] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1055.124242] usb 1-1.3: Product: Broadcom Bluetooth Device
[ 1055.124245] usb 1-1.3: Manufacturer: Broadcom Corp
[ 1055.124249] usb 1-1.3: SerialNumber: 889FFAF856CC
[ 1055.577726] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
[ 1055.577732] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[ 1058.937023] Bluetooth: TIOCGSERIAL is not supported
[ 1059.764213] Bluetooth: TIOCGSERIAL is not supported
[ 1060.313788] Bluetooth: TIOCGSERIAL is not supported
[ 1061.772827] usb 1-1.5.3.1: USB disconnect, device number 38
[ 1061.772832] usb 1-1.5.3.1.1: USB disconnect, device number 41
[ 1062.138427] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.140169] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.142511] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.146529] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.146620] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.150638] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.150746] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.154773] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.154869] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.158899] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.158991] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.163022] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.163114] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.167129] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.167239] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.171269] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.171361] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.175392] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.175488] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.179515] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.179607] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.183624] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.183732] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.187760] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.187856] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.191883] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.191977] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.196008] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.196099] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.200125] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.200228] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.204257] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.204349] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.208378] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.208472] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.212504] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.212591] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.216606] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.216723] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.220748] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.220840] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.224872] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.224963] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.228991] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.229088] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.233107] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.233210] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.237237] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.237332] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.241363] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.241457] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.245486] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.245580] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.249596] generic-usb 0003:046D:C317.0014: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
[ 1062.249706] usb 1-1.5.3: clear tt 3 (0270) error -71
[ 1062.251328] usb 1-1.5.3: USB disconnect, device number 37
[ 1062.251332] usb 1-1.5.3.3: USB disconnect, device number 39
[ 1062.253711] generic-usb 0003:046D:C01E.0013: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
[ 1062.253830] usb 1-1.5.3: clear tt 4 (0280) error -71
[ 1062.253836] usb 1-1.5.3: clear tt 3 (0270) error -19
[ 1062.257832] generic-usb 0003:046D:C317.0015: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
[ 1062.257839] usb 1-1.5.3: clear tt 4 (0280) error -19
[ 1062.285299] usb 1-1.5.3.4: USB disconnect, device number 40
[ 1062.629196] wlan0: authenticate with 00:10:18:90:20:db (try 1)
[ 1062.632010] wlan0: authenticated
[ 1062.632244] wlan0: associate with 00:10:18:90:20:db (try 1)
[ 1062.634635] wlan0: RX AssocResp from 00:10:18:90:20:db (capab=0x411 status=0 aid=7)
[ 1062.634642] wlan0: associated
[ 1062.641064] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1067.046744] usb 1-1.5.3: new high-speed USB device number 43 using ehci_hcd
[ 1067.139238] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
[ 1067.139243] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 1067.139741] hub 1-1.5.3:1.0: USB hub found
[ 1067.139916] hub 1-1.5.3:1.0: 4 ports detected
[ 1067.414578] usb 1-1.5.3.1: new high-speed USB device number 44 using ehci_hcd
[ 1067.506787] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
[ 1067.506793] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 1067.507184] hub 1-1.5.3.1:1.0: USB hub found
[ 1067.507383] hub 1-1.5.3.1:1.0: 2 ports detected
[ 1067.594469] usb 1-1.5.3.3: new low-speed USB device number 45 using ehci_hcd
[ 1067.691834] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
[ 1067.691841] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1067.691846] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
[ 1067.691849] usb 1-1.5.3.3: Manufacturer: Logitech
[ 1067.696473] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input34
[ 1067.696855] generic-usb 0003:046D:C01E.0016: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
[ 1067.782450] usb 1-1.5.3.4: new low-speed USB device number 46 using ehci_hcd
[ 1067.896597] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
[ 1067.896604] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1067.896608] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
[ 1067.896612] usb 1-1.5.3.4: Manufacturer: Logitech
[ 1067.900019] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input35
[ 1067.900291] generic-usb 0003:046D:C317.0017: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
[ 1067.906718] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input36
[ 1067.906957] generic-usb 0003:046D:C317.0018: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
[ 1067.994325] usb 1-1.5.3.1.1: new high-speed USB device number 47 using ehci_hcd
[ 1068.125022] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
[ 1068.125027] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1068.125031] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
[ 1068.125034] usb 1-1.5.3.1.1: Manufacturer: Generic
[ 1068.125037] usb 1-1.5.3.1.1: SerialNumber: T11000038423
[ 1068.125544] scsi13 : usb-storage 1-1.5.3.1.1:1.0
[ 1069.127547] scsi 13:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
[ 1069.137452] sd 13:0:0:0: [sdb] Attached SCSI removable disk
[ 1073.627769] wlan0: no IPv6 routers present

Please let me know if I can provide more details to help solving this
issue,

Best Regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
