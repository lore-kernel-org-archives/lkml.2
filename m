Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0KHG6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:58:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:28392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab0KHG6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:58:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="345791602"
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
From: Zhang Rui <rui.zhang@intel.com>
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <201011052049.55500.maciej.rutecki@gmail.com>
References: <201011041706.59046.maciej.rutecki@gmail.com>
	 <1288916854.2234.275.camel@rui>
	 <201011052049.55500.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 14:58:52 +0800
Message-ID: <1289199532.8148.57.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO, the only one that may cause this regression is commit
c57b62f5b1e6dd69ff8c96f6db7f86ea31c0e21f
some app may enable polling via procfs and update the thermal zone
status.

could you please attach the output of "grep . /proc/acpi/thermal/*/*" in
2.6.36 kernel?

thanks,
rui

On Sat, 2010-11-06 at 03:49 +0800, Maciej Rutecki wrote:
> On piątek, 5 listopada 2010 o 01:27:34 Zhang Rui wrote:
> > On Fri, 2010-11-05 at 00:06 +0800, Maciej Rutecki wrote:
> > > 1.
> > > Last known good kernel: 2.6.36
> > > Bad kernel: 2.6.37-rc1
> > > ===============================
> > > 
> > > 2. Problem:
> > > When I resume computer from s2ram/s2disk and current CPU temp is below
> > > lowest trip point, and -- from unknown reason -- fan start in maximum
> > > speed it doesn't turn off (it should).
> > 
> > could you please attach the output of "grep . /sys/class/thermal/*/*"
> > when this happens?
> >
> 
> Thanks for the answer.
> 
> maciek@gumis:~$ grep . /sys/class/thermal/*/*
> /sys/class/thermal/cooling_device0/cur_state:0
> /sys/class/thermal/cooling_device0/max_state:10
> /sys/class/thermal/cooling_device0/type:LCD
> /sys/class/thermal/cooling_device1/cur_state:0
> /sys/class/thermal/cooling_device1/max_state:10
> /sys/class/thermal/cooling_device1/type:Processor
> /sys/class/thermal/cooling_device2/cur_state:0
> /sys/class/thermal/cooling_device2/max_state:10
> /sys/class/thermal/cooling_device2/type:Processor
> /sys/class/thermal/cooling_device3/cur_state:1
> /sys/class/thermal/cooling_device3/max_state:1
> /sys/class/thermal/cooling_device3/type:Fan
> /sys/class/thermal/cooling_device4/cur_state:1
> /sys/class/thermal/cooling_device4/max_state:1
> /sys/class/thermal/cooling_device4/type:Fan
> /sys/class/thermal/cooling_device5/cur_state:1
> /sys/class/thermal/cooling_device5/max_state:1
> /sys/class/thermal/cooling_device5/type:Fan
> /sys/class/thermal/cooling_device6/cur_state:1
> /sys/class/thermal/cooling_device6/max_state:1
> /sys/class/thermal/cooling_device6/type:Fan
> /sys/class/thermal/thermal_zone0/cdev0_trip_point:1
> /sys/class/thermal/thermal_zone0/cdev1_trip_point:2
> /sys/class/thermal/thermal_zone0/cdev2_trip_point:3
> /sys/class/thermal/thermal_zone0/cdev3_trip_point:4
> /sys/class/thermal/thermal_zone0/mode:enabled
> /sys/class/thermal/thermal_zone0/passive:0
> /sys/class/thermal/thermal_zone0/temp:27000
> /sys/class/thermal/thermal_zone0/trip_point_0_temp:256000
> /sys/class/thermal/thermal_zone0/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone0/trip_point_1_temp:78000
> /sys/class/thermal/thermal_zone0/trip_point_1_type:active
> /sys/class/thermal/thermal_zone0/trip_point_2_temp:70000
> /sys/class/thermal/thermal_zone0/trip_point_2_type:active
> /sys/class/thermal/thermal_zone0/trip_point_3_temp:60000
> /sys/class/thermal/thermal_zone0/trip_point_3_type:active
> /sys/class/thermal/thermal_zone0/trip_point_4_temp:50000
> /sys/class/thermal/thermal_zone0/trip_point_4_type:active
> /sys/class/thermal/thermal_zone0/type:acpitz
> /sys/class/thermal/thermal_zone1/cdev0_trip_point:1
> /sys/class/thermal/thermal_zone1/cdev1_trip_point:1
> /sys/class/thermal/thermal_zone1/mode:enabled
> /sys/class/thermal/thermal_zone1/temp:29000
> /sys/class/thermal/thermal_zone1/trip_point_0_temp:90000
> /sys/class/thermal/thermal_zone1/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone1/trip_point_1_temp:87000
> /sys/class/thermal/thermal_zone1/trip_point_1_type:passive
> /sys/class/thermal/thermal_zone1/type:acpitz
> /sys/class/thermal/thermal_zone2/mode:enabled
> /sys/class/thermal/thermal_zone2/passive:0
> /sys/class/thermal/thermal_zone2/temp:23000
> /sys/class/thermal/thermal_zone2/trip_point_0_temp:105000
> /sys/class/thermal/thermal_zone2/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone2/type:acpitz
> /sys/class/thermal/thermal_zone3/cdev0_trip_point:1
> /sys/class/thermal/thermal_zone3/cdev1_trip_point:1
> /sys/class/thermal/thermal_zone3/mode:enabled
> /sys/class/thermal/thermal_zone3/temp:20000
> /sys/class/thermal/thermal_zone3/trip_point_0_temp:90000
> /sys/class/thermal/thermal_zone3/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone3/trip_point_1_temp:60000
> /sys/class/thermal/thermal_zone3/trip_point_1_type:passive
> /sys/class/thermal/thermal_zone3/type:acpitz
> /sys/class/thermal/thermal_zone4/mode:enabled
> /sys/class/thermal/thermal_zone4/passive:0
> /sys/class/thermal/thermal_zone4/temp:100000
> /sys/class/thermal/thermal_zone4/trip_point_0_temp:110000
> /sys/class/thermal/thermal_zone4/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone4/type:acpitz
> 
> Regards
> -- 
> Maciej Rutecki
> http://www.maciek.unixy.pl


