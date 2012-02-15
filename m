Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2BOURL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:17:11 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46786 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753132Ab2BOURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:17:07 -0500
Date: Wed, 15 Feb 2012 15:16:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Keith Packard <keithp@keithp.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] Intel HD Graphic QM57 chipset: Dell U3011 monitor turns
	to power saving mode
Message-ID: <20120215201652.GA20425@Krystal>
References: <20120121185621.GA31106@Krystal> <86ehuskc4j.fsf@sumi.keithp.com> <20120122174829.GA8789@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120122174829.GA8789@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:08:20 up 449 days,  1:11,  5 users,  load average: 0.07, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi Keith,
> 
> * Keith Packard (keithp@keithp.com) wrote:
> > On Sat, 21 Jan 2012 13:56:21 -0500, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > Dell U3011 monitor turns to power saving mode when resolution set to 2560 x 1600
> > > (intermittent)
> > > 
> > > Reproduced with:
> > > Linux 2.6.38-1-amd64 (Debian kernel)
> > > Linux 3.1.0-1-amd64  (Debian kernel)
> > > Linux 3.2.0-1-amd64  (Debian kernel)
> > > 
> > > The computer is a Lenovo X201 Tablet (Intel QM57 chipset), on a X200
> > > docking station. The docking station uses a DisplayPort cable to connect
> > > to the monitor.  I tried upgrading my Bios from 1.34/1.13 to 1.38/1.14
> > > (latest), which did not fix the problem. I cannot use anything else
> > > than DisplayPort in this case to connect the monitor at 2560 x 1600,
> > > because this resolution requires either the bandwidth provided by a
> > > dual-link DVI (which I cannot connect in my docking station), or
> > > DisplayPort.
> > 
> > I use this same monitor, and have run it with an X200 in the past.
> > 
> > Can you capture a dmesg output with the kernel parameter drm.debug=0xe
> > set? That will let us see the DP link training adventure and see what's
> > broken. If you can, separate traces of working and non-working tries
> > would be nice.
> > 
> > And, of course, trying 3.3-rc1 would be helpful as that's what any
> > test patches would be developed on top of.
> 
> I've compiled and launched a 3.3-rc1 kernel for the following tests. The
> dmesg log follows.
> 
> FWIW, when I get the screen to run, if I launch this 1080p video with
> either mplayer or vlc (http://www.bigbuckbunny.org/index.php/download/,
> 1920x1080, mp4 format) in full screen, I get an horizontal line of blur
> at about 7/8 of the screen (from the top) when there is a lot of
> movement in the movie.  This looks like a vertical refresh sync issue
> and/or too small buffers for double(/triple)-buffering. I'm aware that
> this is a separate issue, but it might help the current investigation.
> The xrandr -q --verbose gives "+HSync -VSync" for the monitor, even
> though its EDID (taken with get-edid/parse-edid) specifies "Flags
> "-HSync" "+VSync"". So hsync and vsync +/- seems to be mixed up.

Another piece of information on this issue: I tried the monitor with an
Apple PowerBook running MacOS X, and the monitor works flawlessly
(monitor always brought up, and the same video works without glitch with
vlc).

I also simplified my routine that successfully bring the monitor into a
working state: running 5 to 20 times the following script ends up doing
the trick:

xrandr --output DP1 --off
sleep 1
xrandr --output DP1 --mode 2560x1600

Please let me know if I can provide more information on the issue than
the detailed logs (success/fail) below. I would also like to know if
there is a knob somewhere in the Intel driver I could play with to
provide more time for the screen to send its EDID information. Based on
this info: http://www.intel.com/support/graphics/sb/CS-028366.htm, Intel
provide a modified Windows driver that might target this kind of issue,
and I assume they possibly let more time than the spec requires for the
screen to send EDID info.

Thanks,

Mathieu
> 
> 
> * 3.3-rc1 up until Xorg is running, screen does not work
> 
> ] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   14.440212] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   14.440216] [drm:intel_crt_detect], CRT not detected via hotplug
> [   14.440220] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   14.440229] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   14.440234] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   14.451677] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   14.451686] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   14.451691] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   14.463035] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   14.463048] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   14.463050] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   14.463365] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   14.464389] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.491348] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.518291] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.518294] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   14.519321] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.546261] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.573232] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.573265] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   14.573266] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   14.573287] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   14.573289] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   14.573292] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   14.573296] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   14.573299] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   14.573302] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   14.573305] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   14.573308] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   14.573312] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   14.573315] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   14.573318] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   14.573321] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   14.573324] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   14.573327] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   14.573331] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   14.573334] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   14.573337] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   14.573340] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   14.573343] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   14.573346] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   14.573349] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   14.573352] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   14.573355] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   14.573359] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   14.573362] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   14.573365] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   14.573368] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   14.573374] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   14.573387] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   14.578275] [drm:intel_crtc_cursor_set], 
> [   14.578332] [drm:intel_crtc_cursor_set], 
> [   14.927715] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   14.927722] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   14.927742] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   14.927745] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   14.927752] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   14.928004] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   14.928009] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   14.928015] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   14.928018] [drm:intel_crt_detect], CRT not detected via hotplug
> [   14.928021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   14.928025] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   14.928028] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   14.928031] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   14.928034] [drm:intel_crt_detect], CRT not detected via hotplug
> [   14.928037] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   14.928044] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   14.928047] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   14.939293] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   14.939299] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   14.939301] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   14.950572] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   14.950590] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   14.950593] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   14.950908] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   14.951933] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   14.979011] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.006101] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.006108] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.007219] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.034269] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.061365] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.061444] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   15.061450] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   15.061497] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   15.061502] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   15.061510] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   15.061518] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   15.061526] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   15.061534] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   15.061542] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   15.061550] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   15.061557] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   15.061565] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   15.061573] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.061581] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.061588] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   15.061596] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   15.061604] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   15.061611] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   15.061619] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   15.061626] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   15.061634] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   15.061642] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   15.061649] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   15.061656] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   15.061664] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   15.061671] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   15.061679] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   15.061686] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.061693] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.061701] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   15.061729] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.186282] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.187309] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.214295] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.241286] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.241293] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.252689] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.252692] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.337282] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,commit=0
> [   15.350246] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.350253] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   15.350271] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   15.350275] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   15.350282] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.350528] EXT4-fs (sda3): re-mounted. Opts: commit=0
> [   15.350542] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.350545] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.350551] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.350554] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.350556] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.350560] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.350562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.350566] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.350569] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.350571] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.350577] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.350580] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.361859] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.361865] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.361867] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.373119] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.373135] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.373137] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   15.373452] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.374476] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.401501] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.428549] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.428558] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.429634] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.456647] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.483710] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.483813] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   15.483819] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   15.483866] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   15.483871] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   15.483879] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   15.483887] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   15.483895] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   15.483903] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   15.483911] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   15.483919] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   15.483927] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   15.483935] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   15.483943] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.483950] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.483958] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   15.483966] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   15.483974] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   15.483981] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   15.483989] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   15.483996] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   15.484004] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   15.484012] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   15.484019] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   15.484026] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   15.484034] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   15.484041] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   15.484049] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   15.484056] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.484064] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.484071] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   15.484107] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.493072] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.493080] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   15.493100] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   15.493106] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   15.493116] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.493586] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.493593] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.493600] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.493606] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.493610] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.493617] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.493621] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.493626] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.493631] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.493635] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.493643] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.493648] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.504970] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.504974] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.504976] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.516228] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.516242] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.516244] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   15.516558] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.517581] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.544587] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.571574] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.571580] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.572621] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.599667] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.626761] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.626830] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   15.626835] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   15.626881] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   15.626886] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   15.626894] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   15.626902] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   15.626909] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   15.626917] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   15.626925] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   15.626933] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   15.626940] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   15.626948] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   15.626956] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.626964] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.626972] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   15.626980] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   15.626989] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   15.626996] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   15.627004] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   15.627012] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   15.627020] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   15.627028] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   15.627036] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   15.627043] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   15.627051] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   15.627059] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   15.627066] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   15.627074] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.627082] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.627089] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   15.627118] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.630439] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.630445] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   15.630456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   15.630460] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   15.630467] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.630711] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.630717] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.630724] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.630729] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.630733] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.630739] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.630744] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.630752] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.630756] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.630759] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.630765] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.630768] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.642037] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.642046] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.642051] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.653282] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.653294] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.653296] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   15.653608] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.654631] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.681574] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.708557] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.708564] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.709606] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.711028] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx
> [   15.736655] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.763785] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.763922] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   15.763927] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   15.763975] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   15.763981] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   15.763989] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   15.763998] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   15.764006] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   15.764014] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   15.764022] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   15.764030] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   15.764038] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   15.764045] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   15.764053] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.764061] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.764069] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   15.764077] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   15.764085] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   15.764093] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   15.764101] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   15.764109] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   15.764117] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   15.764125] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   15.764132] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   15.764140] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   15.764148] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   15.764156] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   15.764163] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   15.764171] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.764178] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.764186] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   15.764228] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.768408] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.768413] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   15.768425] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   15.768429] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   15.768437] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.768761] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.768768] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.768775] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.768780] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.768785] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.768791] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.768796] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.768801] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.768806] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.768810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.768818] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.768822] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.780237] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.780247] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.780251] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.791559] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.791571] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.791573] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   15.791885] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.792907] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.819862] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.846946] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.846953] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.848028] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.875065] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.902130] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.902255] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   15.902261] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   15.902306] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   15.902311] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   15.902320] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   15.902328] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   15.902336] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   15.902344] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   15.902352] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   15.902360] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   15.902368] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   15.902376] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   15.902384] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.902387] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   15.902390] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   15.902394] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   15.902397] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   15.902400] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   15.902404] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   15.902407] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   15.902410] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   15.902413] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   15.902417] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   15.902420] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   15.902423] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   15.902426] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   15.902429] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   15.902432] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.902435] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   15.902438] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   15.902453] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.903654] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.903658] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   15.903665] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   15.903667] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   15.903671] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   15.903801] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.903804] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.903807] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.903809] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.903811] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.903814] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   15.903816] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   15.903818] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   15.903820] [drm:intel_crt_detect], CRT not detected via hotplug
> [   15.903822] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   15.903825] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.903827] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.915128] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.915132] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   15.915134] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   15.926417] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   15.926428] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   15.926430] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   15.926740] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   15.927764] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.954802] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.981843] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   15.981849] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   15.982957] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.009988] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.036956] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.037033] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   16.037039] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   16.037084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   16.037090] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   16.037098] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   16.037106] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   16.037114] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   16.037122] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   16.037130] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   16.037138] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   16.037146] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   16.037154] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   16.037162] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   16.037170] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   16.037178] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   16.037186] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   16.037194] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   16.037202] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   16.037210] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   16.037217] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   16.037225] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   16.037233] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   16.037241] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   16.037249] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   16.037256] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   16.037264] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   16.037272] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   16.037279] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   16.037287] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   16.037294] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   16.037323] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   16.338828] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   16.338835] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   16.338855] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   16.338859] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   16.338867] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   16.339173] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   16.339178] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   16.339184] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   16.339187] [drm:intel_crt_detect], CRT not detected via hotplug
> [   16.339190] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   16.339194] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   16.339196] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   16.339200] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   16.339203] [drm:intel_crt_detect], CRT not detected via hotplug
> [   16.339205] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   16.339211] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   16.339215] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   16.351085] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   16.351097] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   16.351100] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   16.362556] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   16.362584] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   16.362587] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   16.362903] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   16.363928] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.390997] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.418074] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.418079] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   16.419105] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.446184] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.473278] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.473421] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   16.473427] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   16.473475] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   16.473481] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   16.473490] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   16.473498] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   16.473506] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   16.473514] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   16.473522] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   16.473530] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   16.473538] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   16.473546] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   16.473554] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   16.473562] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   16.473570] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   16.473578] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   16.473587] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   16.473594] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   16.473602] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   16.473610] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   16.473618] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   16.473626] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   16.473634] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   16.473642] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   16.473649] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   16.473657] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   16.473665] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   16.473673] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   16.473680] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   16.473688] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   16.473727] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   16.728628] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   16.728634] [drm:intel_crt_detect], CRT not detected via hotplug
> [   16.728638] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
> [   16.740027] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
> [   16.740344] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   16.741372] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.768486] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.795479] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   16.795486] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   16.795490] [drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 1 to 1
> [   20.405672] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.405679] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   20.405702] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   20.405706] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   20.405713] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.405979] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.405984] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.405990] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.405993] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.405996] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.406001] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.406004] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.406009] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.406012] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.406015] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.406021] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.406024] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.417306] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.417311] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.417313] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.428587] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.428607] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.428610] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   20.428924] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   20.429949] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.457002] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.484076] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.484079] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   20.485111] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.512053] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.539006] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.539050] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   20.539053] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   20.539085] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   20.539089] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   20.539095] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   20.539100] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   20.539106] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   20.539115] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   20.539118] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   20.539122] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   20.539125] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   20.539128] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   20.539131] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.539135] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.539138] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   20.539142] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   20.539145] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   20.539148] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   20.539151] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   20.539155] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   20.539158] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   20.539161] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   20.539164] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   20.539167] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   20.539170] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   20.539174] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   20.539177] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   20.539180] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.539184] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.539187] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   20.539202] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.574767] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.574777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   20.574802] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   20.574808] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   20.574819] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.575262] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.575269] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.575277] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.575282] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.575287] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.575293] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.575298] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.575303] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.575308] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.575312] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.575321] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.575326] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.586680] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.586689] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.586693] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.598053] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.598073] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.598076] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   20.598390] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   20.599420] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.626463] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.653529] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.653532] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   20.654627] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.681749] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.708818] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.708954] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   20.708960] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   20.709007] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   20.709013] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   20.709021] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   20.709029] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   20.709037] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   20.709045] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   20.709053] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   20.709061] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   20.709072] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   20.709075] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   20.709079] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.709082] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.709085] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   20.709088] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   20.709092] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   20.709095] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   20.709098] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   20.709102] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   20.709105] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   20.709108] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   20.709111] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   20.709114] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   20.709118] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   20.709121] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   20.709124] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   20.709127] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.709130] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.709134] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   20.709150] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.714846] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.714854] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   20.714872] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   20.714878] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   20.714889] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.715256] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.715263] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.715269] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.715274] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.715278] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.715285] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.715289] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.715295] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.715299] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.715304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.715312] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.715316] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.726616] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.726624] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.726629] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.738015] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.738027] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.738029] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   20.738341] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   20.739365] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.766402] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.766897] eth0: no IPv6 routers present
> [   20.793467] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.793474] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   20.794518] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.821591] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.848655] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.848751] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   20.848757] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   20.848816] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   20.848823] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   20.848834] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   20.848845] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   20.848856] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   20.848867] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   20.848877] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   20.848888] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   20.848899] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   20.848910] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   20.848921] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.848932] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.848942] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   20.848953] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   20.848964] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   20.848974] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   20.848985] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   20.848995] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   20.849006] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   20.849016] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   20.849026] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   20.849036] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   20.849046] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   20.849056] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   20.849066] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   20.849075] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.849085] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.849096] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   20.849137] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.851730] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.851739] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   20.851762] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   20.851770] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   20.851784] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.852298] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.852308] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.852317] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.852324] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.852330] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.852339] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.852345] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.852353] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.852359] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.852365] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.852378] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.852385] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.863708] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.863714] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.863716] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   20.874932] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   20.874952] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.874954] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   20.875267] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   20.876290] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.903290] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.930365] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.930372] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   20.931414] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.958447] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.985519] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   20.985648] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   20.985653] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   20.985702] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   20.985708] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   20.985716] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   20.985724] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   20.985732] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   20.985741] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   20.985749] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   20.985757] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   20.985765] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   20.985773] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   20.985781] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.985788] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   20.985796] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   20.985804] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   20.985812] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   20.985820] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   20.985828] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   20.985836] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   20.985843] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   20.985851] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   20.985859] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   20.985867] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   20.985874] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   20.985882] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   20.985890] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   20.985897] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.985905] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   20.985912] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   20.985957] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   20.989937] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.989944] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   20.989961] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   20.989966] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   20.989976] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   20.990293] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.990299] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.990306] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.990311] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.990316] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.990322] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   20.990327] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   20.990332] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   20.990337] [drm:intel_crt_detect], CRT not detected via hotplug
> [   20.990341] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   20.990349] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   20.990354] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   21.001694] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   21.001702] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   21.001707] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   21.013026] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   21.013037] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   21.013039] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   21.013350] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   21.014373] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.041365] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.068462] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.068468] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   21.069582] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.096651] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.123717] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   21.123844] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   21.123850] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   21.123895] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   21.123901] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   21.123909] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   21.123917] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   21.123926] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   21.123934] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   21.123941] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   21.123949] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   21.123957] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   21.123965] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   21.123973] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   21.123981] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   21.123989] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   21.123997] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   21.124005] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   21.124013] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   21.124020] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   21.124028] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   21.124036] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   21.124044] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   21.124052] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   21.124060] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   21.124067] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   21.124075] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   21.124083] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   21.124090] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   21.124098] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   21.124105] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   21.124134] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   21.131148] [drm:intel_crtc_cursor_set], 
> [   21.131153] [drm:intel_crtc_cursor_set], cursor off
> [   21.131163] [drm:intel_crtc_cursor_set], 
> [   21.131166] [drm:intel_crtc_cursor_set], cursor off
> [   21.131264] [drm:drm_mode_addfb], [FB:45]
> [   21.131340] [drm:drm_mode_setcrtc], [CRTC:3]
> [   21.131347] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
> [   21.131351] [drm:drm_crtc_helper_set_config], 
> [   21.131354] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:45] #connectors=1 (x y) (0 0)
> [   21.131371] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   21.131376] [drm:drm_crtc_helper_set_config], [CONNECTOR:18:DP-1] to [CRTC:4]
> [   21.160481] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   21.160489] [drm:intel_update_fbc], 
> [   21.160493] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   21.175100] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   21.214772] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.214885] [drm:drm_mode_setcrtc], [CRTC:4]
> [   21.214895] [drm:drm_mode_setcrtc], [CONNECTOR:18:DP-1]
> [   21.214899] [drm:drm_crtc_helper_set_config], 
> [   21.214902] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:45] #connectors=1 (x y) (0 0)
> [   21.214914] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   21.214919] [drm:drm_crtc_helper_set_config], [CONNECTOR:18:DP-1] to [CRTC:4]
> [   21.214925] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   21.214931] [drm:intel_update_fbc], 
> [   21.214933] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   21.223257] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   21.270804] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.282817] [drm:intel_crtc_cursor_set], 
> [   21.282827] [drm:intel_crtc_cursor_set], 
> [   21.283172] [drm:drm_mode_setcrtc], [CRTC:4]
> [   21.283181] [drm:drm_mode_setcrtc], [CONNECTOR:18:DP-1]
> [   21.283186] [drm:drm_crtc_helper_set_config], 
> [   21.283189] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:45] #connectors=1 (x y) (0 0)
> [   21.283199] [drm:drm_crtc_helper_set_config], modes are different, full mode set
> [   21.283203] [drm:drm_mode_debug_printmodeline], Modeline 44:"1280x800" 0 83500 1280 1352 1480 1680 800 803 809 831 0x0 0x9
> [   21.283211] [drm:drm_mode_debug_printmodeline], Modeline 24:"" 0 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x0 0x9
> [   21.283220] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   21.283226] [drm:drm_crtc_helper_set_config], [CONNECTOR:18:DP-1] to [CRTC:4]
> [   21.283231] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
> [   21.283235] [drm:drm_mode_debug_printmodeline], Modeline 24:"" 0 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x0 0x9
> [   21.283245] [drm:intel_dp_mode_fixup], Display port link bw 0a lane count 4 clock 270000
> [   21.283248] [drm:drm_crtc_helper_set_mode], [CRTC:4]
> [   21.283457] [drm:intel_dp_link_down], 
> [   21.362766] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.362875] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   21.362976] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   21.422744] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.526696] [drm:intel_wait_for_pipe_off], pipe_off wait timed out
> [   21.535054] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   21.535060] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   21.535065] [drm:intel_update_fbc], 
> [   21.535068] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   21.535079] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to EDID reported max of 10
> [   21.535083] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
> [   21.535088] [drm:ironlake_crtc_mode_set], Mode for pipe 1:
> [   21.535091] [drm:drm_mode_debug_printmodeline], Modeline 24:"" 0 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x0 0x9
> [   21.590673] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.590683] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   21.590689] [drm:intel_update_fbc], 
> [   21.590692] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   21.646646] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.646652] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   21.646657] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   21.646662] [drm:drm_crtc_helper_set_mode], [ENCODER:19:TMDS-19] set [MODE:24:]
> [   21.646668] [drm:intel_dp_mode_set], Enabling DP audio on pipe B
> [   21.646673] [drm:intel_write_eld], ELD on [CONNECTOR:18:DP-1], [ENCODER:19:TMDS-19]
> [   21.646678] [drm:ironlake_write_eld], ELD on pipe B
> [   21.646682] [drm:ironlake_write_eld], Audio directed to unknown port
> [   21.646685] [drm:ironlake_write_eld], ELD: DisplayPort detected
> [   21.646701] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   21.646705] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   21.702623] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.758599] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.758909] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   21.758912] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   21.759068] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   21.759071] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   21.759074] [drm:ironlake_fdi_link_train], FDI train done
> [   21.760282] [drm:intel_update_fbc], 
> [   21.760284] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   21.760608] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   21.760717] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   21.776917] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   21.814575] [drm:intel_wait_for_vblank], vblank wait timed out
> [   21.814786] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   21.815504] [drm:intel_dp_start_link_train], clock recovery OK
> [   21.816728] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
> [   21.816733] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:18:DP-1] set DPMS on
> [   22.058428] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   22.062414] HDMI: detected monitor DELL U3011 at connection type DisplayPort
> [   22.062421] HDMI: available speakers: FL/FR LFE FC RL/RR
> [   22.062431] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
> [   22.543743] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   22.543753] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   22.543779] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   22.543785] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   22.543796] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   22.544160] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   22.544167] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   22.544174] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   22.544179] [drm:intel_crt_detect], CRT not detected via hotplug
> [   22.544183] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   22.544190] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   22.544194] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   22.544199] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   22.544204] [drm:intel_crt_detect], CRT not detected via hotplug
> [   22.544208] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   22.544216] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   22.544221] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   22.555582] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   22.555591] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   22.555595] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   22.566990] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   22.567010] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   22.567012] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   22.567328] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   22.568352] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.595384] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.622375] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.622381] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   22.623492] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.650463] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.677517] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   22.677657] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   22.677663] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   22.677711] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   22.677716] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   22.677724] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   22.677733] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   22.677741] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   22.677749] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   22.677757] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   22.677765] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   22.677773] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   22.677781] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   22.677789] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   22.677797] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   22.677805] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   22.677813] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   22.677821] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   22.677828] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   22.677836] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   22.677844] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   22.677852] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   22.677860] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   22.677868] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   22.677875] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   22.677883] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   22.677891] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   22.677898] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   22.677906] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   22.677913] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   22.677921] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   22.677955] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.058654] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.058662] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   23.058684] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   23.058688] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   23.058697] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.059001] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.059006] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.059013] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.059016] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.059020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.059025] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.059028] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.059032] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.059035] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.059038] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.059046] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.059049] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.070483] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.070514] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.070519] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.082208] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.082284] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.082289] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   23.082607] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   23.083640] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.110632] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.137715] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.137727] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   23.138785] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.165770] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.192766] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.192815] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   23.192817] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   23.192844] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   23.192847] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   23.192851] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   23.192855] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   23.192858] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   23.192862] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   23.192866] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   23.192870] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   23.192873] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   23.192877] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   23.192881] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.192884] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.192888] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   23.192892] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   23.192895] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   23.192899] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   23.192902] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   23.192906] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   23.192909] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   23.192913] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   23.192916] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   23.192920] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   23.192923] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   23.192927] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   23.192930] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   23.192934] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.192937] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.192941] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   23.192986] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.274041] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.274049] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   23.274071] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   23.274076] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   23.274085] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.274413] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.274418] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.274424] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.274427] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.274431] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.274436] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.274439] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.274443] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.274446] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.274449] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.274456] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.274460] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.285984] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.286015] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.286019] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.297487] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.297553] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.297559] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   23.297878] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   23.298915] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.325928] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.353021] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.353031] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   23.354076] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.381150] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.408226] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.408296] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   23.408300] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   23.408342] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   23.408348] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   23.408355] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   23.408362] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   23.408368] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   23.408375] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   23.408382] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   23.408389] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   23.408396] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   23.408402] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   23.408409] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.408416] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.408422] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   23.408429] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   23.408435] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   23.408442] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   23.408449] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   23.408455] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   23.408462] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   23.408469] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   23.408475] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   23.408482] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   23.408488] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   23.408495] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   23.408501] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   23.408507] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.408514] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.408520] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   23.408573] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.463171] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.463179] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   23.463200] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   23.463204] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   23.463212] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.463491] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.463496] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.463502] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.463506] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.463509] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.463513] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.463515] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.463519] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.463521] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.463524] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.463535] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.463538] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.476291] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.476309] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.476314] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.488650] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.488700] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.488704] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   23.489021] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   23.490053] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.517075] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.544034] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.544041] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   23.545078] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.572024] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.599054] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.599157] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   23.599163] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   23.599213] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   23.599219] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   23.599227] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   23.599235] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   23.599243] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   23.599251] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   23.599259] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   23.599268] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   23.599276] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   23.599284] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   23.599292] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.599300] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.599308] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   23.599315] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   23.599323] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   23.599331] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   23.599339] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   23.599347] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   23.599355] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   23.599363] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   23.599371] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   23.599378] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   23.599386] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   23.599394] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   23.599401] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   23.599409] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.599417] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.599424] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   23.599483] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.728913] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.728925] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   23.728954] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   23.728962] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   23.728976] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   23.729449] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.729459] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.729469] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.729475] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.729481] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.729490] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   23.729496] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   23.729503] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   23.729509] [drm:intel_crt_detect], CRT not detected via hotplug
> [   23.729515] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   23.729528] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.729535] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.742084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.742111] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   23.742115] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   23.754009] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   23.754055] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   23.754058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   23.754394] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   23.755422] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.782572] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.809903] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.809909] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   23.810947] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.837998] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.865045] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   23.865093] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   23.865096] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   23.865126] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   23.865130] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   23.865135] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   23.865140] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   23.865145] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   23.865150] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   23.865155] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   23.865160] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   23.865165] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   23.865170] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   23.865175] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.865180] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   23.865186] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   23.865191] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   23.865196] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   23.865200] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   23.865203] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   23.865207] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   23.865211] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   23.865214] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   23.865218] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   23.865222] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   23.865226] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   23.865230] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   23.865234] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   23.865237] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.865241] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   23.865244] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   23.865292] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   25.004371] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   25.004377] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   25.004396] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   25.004399] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   25.004404] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   25.004590] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   25.004593] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   25.004597] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   25.004600] [drm:intel_crt_detect], CRT not detected via hotplug
> [   25.004602] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   25.004605] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   25.004607] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   25.004610] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   25.004612] [drm:intel_crt_detect], CRT not detected via hotplug
> [   25.004614] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   25.004619] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   25.004621] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   25.015873] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   25.015879] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   25.015881] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   25.027128] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   25.027152] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   25.027155] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   25.027471] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   25.028497] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.055443] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.082461] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.082468] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   25.083579] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.110624] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.137718] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   25.137857] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   25.137863] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   25.137911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   25.137918] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   25.137926] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   25.137934] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   25.137942] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   25.137950] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   25.137958] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   25.137966] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   25.137975] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   25.137982] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   25.137990] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   25.137998] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   25.138006] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   25.138014] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   25.138022] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   25.138030] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   25.138038] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   25.138046] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   25.138054] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   25.138061] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   25.138069] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   25.138077] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   25.138085] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   25.138092] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   25.138100] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   25.138108] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   25.138115] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   25.138123] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   25.138158] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   25.142367] [drm:intel_crtc_cursor_set], 
> [   25.142372] [drm:intel_crtc_cursor_set], cursor off
> [   25.142380] [drm:intel_crtc_cursor_set], 
> [   25.142383] [drm:intel_crtc_cursor_set], cursor off
> [   25.143999] [drm:intel_crtc_cursor_set], 
> [   25.144010] [drm:intel_crtc_cursor_set], 
> [   25.505638] Bluetooth: TIOCGSERIAL is not supported
> [   26.355386] Bluetooth: TIOCGSERIAL is not supported
> [   27.631335] wlan0: authenticate with 00:10:18:90:20:db (try 1)
> [   27.634230] wlan0: authenticated
> [   27.644078] wlan0: associate with 00:10:18:90:20:db (try 1)
> [   27.646334] wlan0: RX AssocResp from 00:10:18:90:20:db (capab=0x411 status=0 aid=8)
> [   27.646339] wlan0: associated
> [   27.646344] wlan0: moving STA 00:10:18:90:20:db to state 1
> [   27.646348] wlan0: moving STA 00:10:18:90:20:db to state 2
> [   27.652565] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   27.675690] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> [   27.683338] wlan0: moving STA 00:10:18:90:20:db to state 3
> [   30.419132] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   30.419142] [drm:intel_crt_detect], CRT not detected via hotplug
> [   30.419149] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
> [   30.436375] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
> [   30.436692] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   30.437721] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   30.462828] Bluetooth: TIOCGSERIAL is not supported
> [   30.464707] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   30.491744] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   30.491756] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   30.491763] [drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 1 to 1
> [   33.954586] [drm:intel_crtc_cursor_set], 
> [   33.954591] [drm:intel_crtc_cursor_set], cursor off
> [   33.954600] [drm:intel_crtc_cursor_set], 
> [   33.954604] [drm:intel_crtc_cursor_set], cursor off
> [   34.200934] [drm:intel_crtc_cursor_set], 
> [   34.200945] [drm:intel_crtc_cursor_set], 
> [   34.238996] [drm:intel_crtc_cursor_set], 
> [   34.239001] [drm:intel_crtc_cursor_set], cursor off
> [   34.239009] [drm:intel_crtc_cursor_set], 
> [   34.239012] [drm:intel_crtc_cursor_set], cursor off
> [   37.666239] PPP generic driver version 2.4.2
> [   37.719813] wlan0: no IPv6 routers present
> [   40.840629] PPP BSD Compression module registered
> [   40.846767] PPP Deflate Compression module registered
> 
> 
> * Continued the failed run (I've cut the duplicated part), power cycling
>   the screen (which ended up getting the screen to work). I did the
>   mistake of doing one more power cycle after the screen worked, so had
>   to do it a few more times. Therefore, you can only assume that the
>   last screen training of the "ok" run is a successful one. The training
>   run in the "failed" log above obviously failed. Because it worked once
>   more during my "ok" tests and I mistakenly power cycled it, we cannot
>   say whether the other training runs were ok or failed.
> 
> 
> [   49.555948] usb 1-1.5.3.1: USB disconnect, device number 8
> [   49.555953] usb 1-1.5.3.1.1: USB disconnect, device number 11
> [   50.284416] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
> [   50.285160] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
> [   50.288490] usb 1-1.5.3: clear tt 4 (00a0) error -71
> [   50.292523] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
> [   50.292606] usb 1-1.5.3: clear tt 3 (0090) error -71
> [   50.296634] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
> [   50.296778] usb 1-1.5.3: clear tt 4 (00a0) error -71
> [   50.300864] usb 1-1.5.3: clear tt 3 (0090) error -71
> [   50.300905] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
> [   50.304905] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
> [   50.304962] usb 1-1.5.3: clear tt 4 (00a0) error -71
> [   50.309015] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
> [   50.309121] usb 1-1.5.3: clear tt 3 (0090) error -71
> [   50.313133] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
> [   50.313210] usb 1-1.5.3: clear tt 4 (00a0) error -71
> [   50.317255] generic-usb 0003:046D:C317.0002: can't reset device, 0000:00:1a.0-1.5.3.4/input0, status -71
> [   50.317340] usb 1-1.5.3: clear tt 3 (0090) error -71
> [   50.321477] usb 1-1.5.3: clear tt 4 (00a0) error -71
> [   50.322342] usb 1-1.5.3: USB disconnect, device number 7
> [   50.322347] usb 1-1.5.3.3: USB disconnect, device number 9
> [   50.325448] generic-usb 0003:046D:C01E.0001: can't reset device, 0000:00:1a.0-1.5.3.3/input0, status -71
> [   50.325463] usb 1-1.5.3: clear tt 3 (0090) error -19
> [   50.325470] usb 1-1.5.3: clear tt 4 (00a0) error -19
> [   50.325794] generic-usb 0003:046D:C317.0003: can't reset device, 0000:00:1a.0-1.5.3.4/input1, status -71
> [   50.339049] usb 1-1.5.3.4: USB disconnect, device number 10
> [   51.041826] [drm:i915_hotplug_work_func], running encoder hotplug functions
> [   51.042353] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5015003e
> [   51.051102] [drm:intel_dp_check_link_status], TMDS-19: channel EQ not ok, retraining
> [   51.106195] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.106405] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.107124] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.107843] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.108562] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.109281] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.110000] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.110653] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.111372] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.112092] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.112811] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.113529] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.114249] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.114970] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.118370] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
> [   51.118377] ata2: irq_stat 0x00000040, connection status changed
> [   51.118382] ata2: SError: { DevExch }
> [   51.118395] ata2: hard resetting link
> [   51.170174] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.170385] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.171103] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.171820] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.172538] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.173257] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.173976] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.174697] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.175417] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.176137] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.176856] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.177575] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.178295] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.234145] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.234355] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.235073] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.235791] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.236510] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.237229] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.238090] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.238812] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.239533] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.240260] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.240982] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.241701] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.242386] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.298146] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.298356] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.299126] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.299847] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.300566] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.301286] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.302063] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.302785] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.303544] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.304266] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.304985] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.305704] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.306451] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.362047] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.362259] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.362979] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.363697] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.364415] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.365135] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.365855] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.366591] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.367312] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.368032] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.368752] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.369471] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.370191] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.426040] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.426250] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.426968] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.427687] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.428406] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.429124] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.429844] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.430513] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.431233] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.431952] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.432670] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.433389] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.434108] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.490021] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.490232] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.490951] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
> [   51.491668] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.492387] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.493106] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.493825] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.494513] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.495236] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.495956] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.496674] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   51.497394] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
> [   51.498173] [drm:intel_dp_start_link_train], too many full retries, give up
> [   51.498179] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
> [   51.498184] [drm:intel_dp_link_down], 
> [   51.577950] [drm:intel_wait_for_vblank], vblank wait timed out
> [   51.578056] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   51.578162] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   51.582045] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   51.582095] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   51.582221] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   51.582227] [drm:intel_crt_detect], CRT not detected via hotplug
> [   51.582232] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
> [   51.585971] HDMI: detected monitor DELL U3011 at connection type DisplayPort
> [   51.585977] HDMI: available speakers: FL/FR LFE FC RL/RR
> [   51.585984] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
> [   51.593606] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
> [   51.593922] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   51.594953] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   51.622120] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   51.649192] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   51.649199] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   51.649204] [drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 1 to 1
> [   52.673562] ata2: SATA link down (SStatus 0 SControl 300)
> [   52.689544] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen t4
> [   52.689550] ata2: irq_stat 0x00000040, connection status changed
> [   52.689554] ata2: SError: { DevExch }
> [   52.689564] ata2: limiting SATA link speed to 1.5 Gbps
> [   52.689568] ata2: hard resetting link
> [   53.269989] [drm:i915_hotplug_work_func], running encoder hotplug functions
> [   53.270919] [drm:intel_dp_check_link_status], TMDS-19: channel EQ not ok, retraining
> [   53.325288] [drm:intel_wait_for_vblank], vblank wait timed out
> [   53.325499] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   53.326217] [drm:intel_dp_start_link_train], clock recovery OK
> [   53.327450] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   53.327456] [drm:intel_crt_detect], CRT not detected via hotplug
> [   53.327460] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
> [   53.338935] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
> [   53.339252] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   53.340281] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   53.367271] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   53.394293] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   53.394300] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   53.394306] [drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 1 to 1
> [   53.733101] ata2: SATA link down (SStatus 0 SControl 310)
> [   53.749100] ata2: EH complete
> [   55.116739] usb 1-1.5.3: new high-speed USB device number 12 using ehci_hcd
> [   55.209087] usb 1-1.5.3: New USB device found, idVendor=0424, idProduct=2514
> [   55.209094] usb 1-1.5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [   55.209644] hub 1-1.5.3:1.0: USB hub found
> [   55.209747] hub 1-1.5.3:1.0: 4 ports detected
> [   55.480582] usb 1-1.5.3.1: new high-speed USB device number 13 using ehci_hcd
> [   55.572809] usb 1-1.5.3.1: New USB device found, idVendor=0424, idProduct=2640
> [   55.572814] usb 1-1.5.3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [   55.573200] hub 1-1.5.3.1:1.0: USB hub found
> [   55.573387] hub 1-1.5.3.1:1.0: 2 ports detected
> [   55.660511] usb 1-1.5.3.3: new low-speed USB device number 14 using ehci_hcd
> [   55.758107] usb 1-1.5.3.3: New USB device found, idVendor=046d, idProduct=c01e
> [   55.758113] usb 1-1.5.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   55.758118] usb 1-1.5.3.3: Product: USB-PS/2 Optical Mouse
> [   55.758121] usb 1-1.5.3.3: Manufacturer: Logitech
> [   55.762841] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.3/1-1.5.3.3:1.0/input/input16
> [   55.763203] generic-usb 0003:046D:C01E.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.5.3.3/input0
> [   55.848429] usb 1-1.5.3.4: new low-speed USB device number 15 using ehci_hcd
> [   55.962532] usb 1-1.5.3.4: New USB device found, idVendor=046d, idProduct=c317
> [   55.962538] usb 1-1.5.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   55.962543] usb 1-1.5.3.4: Product: USB Multimedia Keyboard
> [   55.962547] usb 1-1.5.3.4: Manufacturer: Logitech
> [   55.966038] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.0/input/input17
> [   55.966314] generic-usb 0003:046D:C317.0005: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input0
> [   55.973078] input: Logitech USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3/1-1.5.3.4/1-1.5.3.4:1.1/input/input18
> [   55.973417] generic-usb 0003:046D:C317.0006: input,hidraw2: USB HID v1.10 Device [Logitech USB Multimedia Keyboard] on usb-0000:00:1a.0-1.5.3.4/input1
> [   56.060169] usb 1-1.5.3.1.1: new high-speed USB device number 16 using ehci_hcd
> [   56.190892] usb 1-1.5.3.1.1: New USB device found, idVendor=0424, idProduct=4064
> [   56.190897] usb 1-1.5.3.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   56.190901] usb 1-1.5.3.1.1: Product: Ultra Fast Media Reader
> [   56.190904] usb 1-1.5.3.1.1: Manufacturer: Generic
> [   56.190906] usb 1-1.5.3.1.1: SerialNumber: T11000038423
> [   56.191386] scsi7 : usb-storage 1-1.5.3.1.1:1.0
> [   57.193102] scsi 7:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.90 PQ: 0 ANSI: 0
> [   57.201946] sd 7:0:0:0: [sdb] Attached SCSI removable disk
> [   57.305144] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   57.305151] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   57.305171] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   57.305174] [drm:drm_mode_debug_printmodeline], Modeline 21:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   57.305180] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   57.305398] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   57.305401] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   57.305405] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   57.305408] [drm:intel_crt_detect], CRT not detected via hotplug
> [   57.305410] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   57.305413] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   57.305415] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   57.305418] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   57.305421] [drm:intel_crt_detect], CRT not detected via hotplug
> [   57.305422] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   57.305428] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   57.305430] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   57.317218] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   57.317231] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   57.317234] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   57.328606] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   57.328652] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   57.328655] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
> [   57.328973] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   57.329996] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.357019] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.384163] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.384171] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   57.385286] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.412439] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.439280] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   57.439364] [drm:drm_edid_to_eld], ELD monitor DELL U3011
> [   57.439370] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
> [   57.439456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] probed modes :
> [   57.439465] [drm:drm_mode_debug_printmodeline], Modeline 9:"2560x1600" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
> [   57.439476] [drm:drm_mode_debug_printmodeline], Modeline 30:"1920x1440" 60 234000 1920 2048 2256 2600 1440 1441 1444 1500 0x40 0x6
> [   57.439488] [drm:drm_mode_debug_printmodeline], Modeline 29:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
> [   57.439499] [drm:drm_mode_debug_printmodeline], Modeline 53:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
> [   57.439511] [drm:drm_mode_debug_printmodeline], Modeline 39:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
> [   57.439522] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1080" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
> [   57.439534] [drm:drm_mode_debug_printmodeline], Modeline 52:"1920x1080" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
> [   57.439545] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
> [   57.439557] [drm:drm_mode_debug_printmodeline], Modeline 28:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
> [   57.439568] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   57.439578] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   57.439586] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
> [   57.439594] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   57.439602] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
> [   57.439610] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
> [   57.439618] [drm:drm_mode_debug_printmodeline], Modeline 50:"1440x576" 50 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x1a
> [   57.439626] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   57.439634] [drm:drm_mode_debug_printmodeline], Modeline 37:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   57.439642] [drm:drm_mode_debug_printmodeline], Modeline 47:"1440x480" 60 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x1a
> [   57.439650] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   57.439658] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   57.439665] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
> [   57.439673] [drm:drm_mode_debug_printmodeline], Modeline 43:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
> [   57.439681] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   57.439689] [drm:drm_mode_debug_printmodeline], Modeline 33:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   57.439696] [drm:drm_mode_debug_printmodeline], Modeline 46:"640x480" 60 25175 640 656 752 800 480 490 492 525 0x40 0xa
> [   57.439704] [drm:drm_mode_debug_printmodeline], Modeline 34:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   57.439742] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
> [   57.543151] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   57.819365] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
> [   57.822512] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   57.875342] [drm:intel_wait_for_vblank], vblank wait timed out
> [   57.907768] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   57.907774] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   57.907780] [drm:intel_update_fbc], 
> [   57.907782] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   57.908412] [drm:intel_opregion_gse_intr], non asle set request??
> [   57.908656] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   57.908662] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   57.909302] [drm:intel_dp_link_down], 
> [   57.987294] [drm:intel_wait_for_vblank], vblank wait timed out
> [   57.987421] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   57.987522] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   57.991265] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
> [   58.003926] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   58.047260] [drm:intel_wait_for_vblank], vblank wait timed out
> [   58.071661] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   58.071667] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   58.071672] [drm:intel_update_fbc], 
> [   58.071675] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   58.072169] [drm:intel_opregion_gse_intr], non asle set request??
> [   58.072412] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   58.072418] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   58.527272] [drm:intel_crtc_cursor_set], 
> [   58.527280] [drm:intel_crtc_cursor_set], 
> [   58.889010] [drm:intel_crtc_cursor_set], 
> [   58.889014] [drm:intel_crtc_cursor_set], cursor off
> [   58.889022] [drm:intel_crtc_cursor_set], 
> [   58.889024] [drm:intel_crtc_cursor_set], cursor off
> [   59.091462] [drm:drm_crtc_helper_set_mode], [CRTC:3]
> [   59.091477] [drm:ironlake_get_refclk], using SSC reference clock of 120 MHz
> [   59.091491] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
> [   59.091493] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
> [   59.091497] [drm:ironlake_crtc_mode_set], Mode for pipe 0:
> [   59.091500] [drm:drm_mode_debug_printmodeline], Modeline 20:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   59.146745] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.146788] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   59.146796] [drm:intel_update_fbc], 
> [   59.146799] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.202715] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.202725] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.202731] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.202740] [drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:20:1280x800]
> [   59.202747] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.202752] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.258732] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.314677] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.315025] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   59.315028] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   59.315187] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   59.315190] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   59.315193] [drm:ironlake_fdi_link_train], FDI train done
> [   59.316401] [drm:intel_update_fbc], 
> [   59.316404] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.322673] [drm:intel_panel_actually_set_backlight], set backlight PWM = 75
> [   59.322684] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   59.322694] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
> [   59.333148] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   59.378654] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.403042] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.403048] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.403053] [drm:intel_update_fbc], 
> [   59.403055] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.403065] [drm:intel_dp_mode_fixup], Display port link bw 0a lane count 4 clock 270000
> [   59.403070] [drm:drm_crtc_helper_set_mode], [CRTC:4]
> [   59.403292] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to EDID reported max of 10
> [   59.403297] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
> [   59.403301] [drm:ironlake_crtc_mode_set], Mode for pipe 1:
> [   59.403304] [drm:drm_mode_debug_printmodeline], Modeline 24:"" 0 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x0 0x9
> [   59.458616] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.458625] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   59.458631] [drm:intel_update_fbc], 
> [   59.458634] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.514570] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.514577] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.514581] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.514587] [drm:drm_crtc_helper_set_mode], [ENCODER:19:TMDS-19] set [MODE:24:]
> [   59.514593] [drm:intel_dp_mode_set], Enabling DP audio on pipe B
> [   59.514597] [drm:intel_write_eld], ELD on [CONNECTOR:18:DP-1], [ENCODER:19:TMDS-19]
> [   59.514602] [drm:ironlake_write_eld], ELD on pipe B
> [   59.514606] [drm:ironlake_write_eld], Audio directed to unknown port
> [   59.514609] [drm:ironlake_write_eld], ELD: DisplayPort detected
> [   59.514626] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.514630] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.570569] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.626545] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.626854] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   59.626857] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   59.627013] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   59.627016] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   59.627019] [drm:ironlake_fdi_link_train], FDI train done
> [   59.628226] [drm:intel_update_fbc], 
> [   59.628229] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.628571] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   59.628684] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   59.644870] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   59.682532] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.682747] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   59.683481] [drm:intel_dp_start_link_train], clock recovery OK
> [   59.684912] [drm:intel_dp_link_down], 
> [   59.762489] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.762603] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   59.762687] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   59.766499] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
> [   59.779128] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   59.822467] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.846849] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.846855] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.846860] [drm:intel_update_fbc], 
> [   59.846863] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.846926] [drm:ironlake_crtc_dpms], crtc 0/0 dpms on
> [   59.846931] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.846936] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.902475] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.926455] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   59.958461] [drm:intel_wait_for_vblank], vblank wait timed out
> [   59.958770] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   59.958773] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   59.958930] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   59.958933] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   59.958936] [drm:ironlake_fdi_link_train], FDI train done
> [   59.960144] [drm:intel_update_fbc], 
> [   59.960146] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   59.966410] [drm:intel_panel_actually_set_backlight], set backlight PWM = 75
> [   59.966957] [drm:intel_opregion_gse_intr], non asle set request??
> [   59.967232] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   59.967238] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3828
> [   59.967242] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   59.967584] [drm:ironlake_crtc_dpms], crtc 1/1 dpms on
> [   59.967590] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   59.967595] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   59.976904] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   60.022433] [drm:intel_wait_for_vblank], vblank wait timed out
> [   60.078405] [drm:intel_wait_for_vblank], vblank wait timed out
> [   60.078715] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   60.078719] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   60.078873] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   60.078876] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   60.078879] [drm:ironlake_fdi_link_train], FDI train done
> [   60.080088] [drm:intel_update_fbc], 
> [   60.080090] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   60.080435] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   60.080550] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   60.087296] HDMI: detected monitor DELL U3011 at connection type DisplayPort
> [   60.087302] HDMI: available speakers: FL/FR LFE FC RL/RR
> [   60.087309] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
> [   60.134382] [drm:intel_wait_for_vblank], vblank wait timed out
> [   60.134592] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   60.135311] [drm:intel_dp_start_link_train], clock recovery OK
> [   60.153038] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   65.808067] [drm:intel_crtc_cursor_set], 
> [   65.808077] [drm:intel_crtc_cursor_set], 
> [   67.331300] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
> [   67.331307] [drm:intel_crt_detect], CRT not detected via hotplug
> [   67.331312] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
> [   67.342724] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
> [   67.343040] [drm:intel_dp_detect], DPCD: 110a840101000100
> [   67.344090] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   67.371185] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   67.398209] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
> [   67.398215] [drm:drm_detect_monitor_audio], Monitor has basic audio support
> [   67.398219] [drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 1 to 1
> [   68.588285] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   68.866702] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
> [   68.867688] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   68.922658] [drm:intel_wait_for_vblank], vblank wait timed out
> [   68.955050] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   68.955057] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   68.955062] [drm:intel_update_fbc], 
> [   68.955065] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   68.955697] [drm:intel_opregion_gse_intr], non asle set request??
> [   68.955941] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   68.955947] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   68.956591] [drm:intel_dp_link_down], 
> [   69.034621] [drm:intel_wait_for_vblank], vblank wait timed out
> [   69.034733] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   69.034844] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   69.038622] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
> [   69.051276] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   69.094596] [drm:intel_wait_for_vblank], vblank wait timed out
> [   69.118997] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   69.119003] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   69.119008] [drm:intel_update_fbc], 
> [   69.119010] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   69.119512] [drm:intel_opregion_gse_intr], non asle set request??
> [   69.119754] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   69.119761] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   72.337717] [drm:drm_crtc_helper_set_mode], [CRTC:3]
> [   72.337738] [drm:ironlake_get_refclk], using SSC reference clock of 120 MHz
> [   72.337783] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
> [   72.337790] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
> [   72.337798] [drm:ironlake_crtc_mode_set], Mode for pipe 0:
> [   72.337803] [drm:drm_mode_debug_printmodeline], Modeline 20:"1280x800" 60 75160 1280 1328 1412 1522 800 803 809 823 0x48 0xa
> [   72.393144] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.393176] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   72.393183] [drm:intel_update_fbc], 
> [   72.393187] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   72.449119] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.449129] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   72.449135] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   72.449143] [drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:20:1280x800]
> [   72.449150] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   72.449155] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   72.505092] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.561081] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.561390] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   72.561394] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   72.561549] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   72.561552] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   72.561555] [drm:ironlake_fdi_link_train], FDI train done
> [   72.562763] [drm:intel_update_fbc], 
> [   72.562765] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   72.569061] [drm:intel_panel_actually_set_backlight], set backlight PWM = 75
> [   72.569073] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   72.577079] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
> [   72.579510] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   72.633065] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.665441] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   72.665447] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   72.665452] [drm:intel_update_fbc], 
> [   72.665455] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   72.665465] [drm:intel_dp_mode_fixup], Display port link bw 0a lane count 4 clock 270000
> [   72.665470] [drm:drm_crtc_helper_set_mode], [CRTC:4]
> [   72.665693] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to EDID reported max of 10
> [   72.665697] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
> [   72.665702] [drm:ironlake_crtc_mode_set], Mode for pipe 1:
> [   72.665705] [drm:drm_mode_debug_printmodeline], Modeline 24:"" 0 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x0 0x9
> [   72.721018] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.721028] [drm:ironlake_update_plane], Writing base 0276F000 00000000 0 0 10240
> [   72.721034] [drm:intel_update_fbc], 
> [   72.721036] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   72.776989] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.776995] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   72.777000] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   72.777005] [drm:drm_crtc_helper_set_mode], [ENCODER:19:TMDS-19] set [MODE:24:]
> [   72.777011] [drm:intel_dp_mode_set], Enabling DP audio on pipe B
> [   72.777016] [drm:intel_write_eld], ELD on [CONNECTOR:18:DP-1], [ENCODER:19:TMDS-19]
> [   72.777021] [drm:ironlake_write_eld], ELD on pipe B
> [   72.777025] [drm:ironlake_write_eld], Audio directed to unknown port
> [   72.777028] [drm:ironlake_write_eld], ELD: DisplayPort detected
> [   72.777044] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   72.777048] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   72.832978] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.888935] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.889245] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   72.889250] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   72.889406] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   72.889409] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   72.889413] [drm:ironlake_fdi_link_train], FDI train done
> [   72.890623] [drm:intel_update_fbc], 
> [   72.890626] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   72.890958] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   72.891081] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   72.907271] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   72.944915] [drm:intel_wait_for_vblank], vblank wait timed out
> [   72.945127] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   72.945845] [drm:intel_dp_start_link_train], clock recovery OK
> [   72.947282] [drm:intel_dp_link_down], 
> [   73.024872] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.024992] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
> [   73.025088] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   73.028898] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
> [   73.041511] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   73.084865] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.109255] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   73.109261] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   73.109266] [drm:intel_update_fbc], 
> [   73.109269] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   73.109379] [drm:ironlake_crtc_dpms], crtc 0/0 dpms on
> [   73.109386] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   73.109390] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   73.164876] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.188863] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
> [   73.220857] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.221168] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   73.221172] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   73.221327] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   73.221330] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   73.221333] [drm:ironlake_fdi_link_train], FDI train done
> [   73.222541] [drm:intel_update_fbc], 
> [   73.222544] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   73.228779] [drm:intel_panel_actually_set_backlight], set backlight PWM = 75
> [   73.229486] [drm:intel_opregion_gse_intr], non asle set request??
> [   73.229764] [drm:intel_panel_get_max_backlight], max backlight PWM = 3828
> [   73.230036] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3828
> [   73.230042] [drm:intel_opregion_gse_intr], PWM freq is not supported
> [   73.230139] [drm:ironlake_crtc_dpms], crtc 1/1 dpms on
> [   73.230145] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 6, cursor: 6
> [   73.230151] [drm:ironlake_update_wm], FIFO watermarks For pipe B - plane 14, cursor: 6
> [   73.239288] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   73.284826] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.340801] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.341110] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x100
> [   73.341114] [drm:ironlake_fdi_link_train], FDI train 1 done.
> [   73.341269] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
> [   73.341272] [drm:ironlake_fdi_link_train], FDI train 2 done.
> [   73.341275] [drm:ironlake_fdi_link_train], FDI train done
> [   73.342484] [drm:intel_update_fbc], 
> [   73.342487] [drm:intel_update_fbc], more than one pipe active, disabling compression
> [   73.342845] HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   73.342956] HDMI status: Codec=3 Pin=5 Presence_Detect=1 ELD_Valid=1
> [   73.348625] HDMI: detected monitor DELL U3011 at connection type DisplayPort
> [   73.348630] HDMI: available speakers: FL/FR LFE FC RL/RR
> [   73.348638] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 96000 176400 192000 384000, bits = 16 20 24
> [   73.396781] [drm:intel_wait_for_vblank], vblank wait timed out
> [   73.396990] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
> [   73.397710] [drm:intel_dp_start_link_train], clock recovery OK
> [   73.415437] [drm:intel_prepare_page_flip], preparing flip with no unpin work?
> [   82.859908] [drm:intel_crtc_cursor_set], 
> [   82.859914] [drm:intel_crtc_cursor_set], cursor off
> [   82.859922] [drm:intel_crtc_cursor_set], 
> [   82.859926] [drm:intel_crtc_cursor_set], cursor off
> [   82.938689] [drm:intel_crtc_cursor_set], 
> [   82.938695] [drm:intel_crtc_cursor_set], 
> [   84.685117] [drm:intel_crtc_cursor_set], 
> [   84.685122] [drm:intel_crtc_cursor_set], cursor off
> [   85.188870] [drm:intel_crtc_cursor_set], 
> [   89.469809] [drm:intel_crtc_cursor_set], 
> [   89.469813] [drm:intel_crtc_cursor_set], cursor off
> [   89.469820] [drm:intel_crtc_cursor_set], 
> [   89.469823] [drm:intel_crtc_cursor_set], cursor off
> [   91.266627] [drm:intel_crtc_cursor_set], 
> [   91.266635] [drm:intel_crtc_cursor_set], 
> [   91.388621] [drm:intel_crtc_cursor_set], 
> [   91.388625] [drm:intel_crtc_cursor_set], cursor off
> [   91.388632] [drm:intel_crtc_cursor_set], 
> [   91.388634] [drm:intel_crtc_cursor_set], cursor off
> [   91.634540] [drm:intel_crtc_cursor_set], 
> [   91.634548] [drm:intel_crtc_cursor_set], 
> [   91.868579] [drm:intel_crtc_cursor_set], 
> [   91.868584] [drm:intel_crtc_cursor_set], cursor off
> [   91.868590] [drm:intel_crtc_cursor_set], 
> [   91.868593] [drm:intel_crtc_cursor_set], cursor off
> 
> Let me know if I can provide more info,
> 
> Thanks!
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
