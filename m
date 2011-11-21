Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1KUB6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:58:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:48060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab1KUB6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78185641"
Date: Mon, 21 Nov 2011 09:58:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio
 driver
Message-ID: <20111121015809.GA25148@localhost>
References: <20111116132004.299754849@intel.com>
 <20111116132221.374839261@intel.com>
 <20111116133548.GA23804@localhost>
 <20111118093740.GA2799@localhost>
 <86aa7tmigr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86aa7tmigr.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 01:46:44AM +0800, Keith Packard wrote:
> On Fri, 18 Nov 2011 17:37:40 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > However when in X, ->mode_set won't be called at all.  Only
> > ->get_modes and ->detect are called...
> 
> The desktop software will call mode_set when it configures the
> monitor. Otherwise, it's not being used (and so shouldn't have audio
> routed to it by default).

Keith, I experimented playing HDMI audio in X, and during the time
unplug and plug the monitor. The HDMI audio/graphics all continue to
work when plugged in the monitor again. Here is the dmesg showed for
the plug event, no ->mode_set is called at all...

[ 1296.469103] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[ 1296.475442] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[ 1296.483649] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x83f40000, result 1
[ 1296.493417] [drm:intel_crt_detect], CRT detected via hotplug
[ 1296.562579] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[ 1296.564700] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
[ 1296.567609] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x48 0xa
[ 1296.572112] [drm:drm_mode_debug_printmodeline], Modeline 23:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[ 1296.576561] [drm:drm_mode_debug_printmodeline], Modeline 25:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[ 1296.579109] [drm:drm_mode_debug_printmodeline], Modeline 19:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[ 1296.581403] [drm:drm_mode_debug_printmodeline], Modeline 20:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[ 1296.584027] [drm:drm_mode_debug_printmodeline], Modeline 21:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[ 1296.587294] [drm:drm_mode_debug_printmodeline], Modeline 22:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[ 1296.589849] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[ 1296.593635] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[ 1296.595157] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:HDMI-A-1]
[ 1296.608219] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:HDMI-A-1] disconnected
[ 1296.610732] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[ 1296.611939] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:HDMI-A-1]
[ 1296.624882] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:HDMI-A-1] disconnected
[ 1296.627445] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[ 1296.628814] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-2]
[ 1296.750591] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[ 1296.873062] [drm:drm_edid_to_eld], ELD monitor SONY TV
[ 1296.874819] HDMI: DVI dual 0, max TMDS clock 5, latency present 0 0, video latency 0 81, audio latency 114 208
[ 1296.877018] [drm:drm_edid_to_eld], ELD size 8, SAD count 1
[ 1296.878468] [drm:drm_mode_debug_printmodeline], Modeline 45:"1920x1080i" 0 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
[ 1296.880862] [drm:drm_mode_prune_invalid], Not using 1920x1080i mode 7
[ 1296.882454] [drm:drm_mode_debug_printmodeline], Modeline 44:"1920x1080i" 0 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
[ 1296.885996] [drm:drm_mode_prune_invalid], Not using 1920x1080i mode 7
[ 1296.887573] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-2] probed modes :
[ 1296.889507] [drm:drm_mode_debug_printmodeline], Modeline 37:"1920x1080" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x48 0x5
[ 1296.892084] [drm:drm_mode_debug_printmodeline], Modeline 43:"1280x720" 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
[ 1296.894657] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[ 1296.897053] [drm:drm_mode_debug_printmodeline], Modeline 32:"720x576" 50 27000 720 732 796 864 576 581 586 625 0x40 0xa
[ 1296.899603] [drm:drm_mode_debug_printmodeline], Modeline 29:"720x480" 60 27000 720 736 798 858 480 489 495 525 0x40 0xa
[ 1296.901979] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[ 1296.906084] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[ 1296.907545] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[ 1296.909659] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.913429] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.917418] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.920908] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1296.922663] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] disconnected
[ 1296.924543] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[ 1296.925793] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[ 1296.927920] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.931393] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.935459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.939854] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1296.942038] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] disconnected
[ 1296.944160] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[ 1296.946124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-2]
[ 1296.948244] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.952332] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.956331] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.959803] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1296.961384] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-2] disconnected
[ 1296.963332] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[ 1296.965527] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-2]
[ 1296.968584] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.972279] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.976273] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1296.980756] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1296.982903] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-2] disconnected
[ 1306.496011] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0x83f40000, result 1
[ 1306.506271] [drm:intel_crt_detect], CRT detected via hotplug
[ 1306.512689] [drm:output_poll_execute], [CONNECTOR:5:VGA-1] status updated from 1 to 1
[ 1306.533016] [drm:output_poll_execute], [CONNECTOR:8:HDMI-A-1] status updated from 2 to 2
[ 1306.663751] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[ 1306.666181] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-2] status updated from 1 to 1
[ 1306.669486] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.673966] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.677959] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.681436] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1306.682760] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 2 to 2
[ 1306.684946] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.688926] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.692914] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[ 1306.696399] [drm:intel_dp_detect], DPCD: 0000000000000000
[ 1306.698091] [drm:output_poll_execute], [CONNECTOR:15:DP-2] status updated from 2 to 2

Thanks,
Fengguang
