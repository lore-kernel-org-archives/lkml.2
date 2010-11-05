Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0KETuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:50:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42045 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0KETuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DGUbdx9D1bYtlOLD58lhNFTZTkY3fBNx8pHoc/LCFh9FHMi2B5fQr7XtJA0rAgy5bz
         39j6v813yaAOpU7427tVa/8FoW+7UJmJrh+pAR7gkKpJoj6f9py8MEsztKk6P7/Z0ybR
         tepcdQ7CIbPOGB9mVwZwoxclGVC1QfuXKAyJ0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
Date: Fri, 5 Nov 2010 20:49:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201011041706.59046.maciej.rutecki@gmail.com> <1288916854.2234.275.camel@rui>
In-Reply-To: <1288916854.2234.275.camel@rui>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011052049.55500.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 5 listopada 2010 o 01:27:34 Zhang Rui wrote:
> On Fri, 2010-11-05 at 00:06 +0800, Maciej Rutecki wrote:
> > 1.
> > Last known good kernel: 2.6.36
> > Bad kernel: 2.6.37-rc1
> > ===============================
> > 
> > 2. Problem:
> > When I resume computer from s2ram/s2disk and current CPU temp is below
> > lowest trip point, and -- from unknown reason -- fan start in maximum
> > speed it doesn't turn off (it should).
> 
> could you please attach the output of "grep . /sys/class/thermal/*/*"
> when this happens?
>

Thanks for the answer.

maciek@gumis:~$ grep . /sys/class/thermal/*/*
/sys/class/thermal/cooling_device0/cur_state:0
/sys/class/thermal/cooling_device0/max_state:10
/sys/class/thermal/cooling_device0/type:LCD
/sys/class/thermal/cooling_device1/cur_state:0
/sys/class/thermal/cooling_device1/max_state:10
/sys/class/thermal/cooling_device1/type:Processor
/sys/class/thermal/cooling_device2/cur_state:0
/sys/class/thermal/cooling_device2/max_state:10
/sys/class/thermal/cooling_device2/type:Processor
/sys/class/thermal/cooling_device3/cur_state:1
/sys/class/thermal/cooling_device3/max_state:1
/sys/class/thermal/cooling_device3/type:Fan
/sys/class/thermal/cooling_device4/cur_state:1
/sys/class/thermal/cooling_device4/max_state:1
/sys/class/thermal/cooling_device4/type:Fan
/sys/class/thermal/cooling_device5/cur_state:1
/sys/class/thermal/cooling_device5/max_state:1
/sys/class/thermal/cooling_device5/type:Fan
/sys/class/thermal/cooling_device6/cur_state:1
/sys/class/thermal/cooling_device6/max_state:1
/sys/class/thermal/cooling_device6/type:Fan
/sys/class/thermal/thermal_zone0/cdev0_trip_point:1
/sys/class/thermal/thermal_zone0/cdev1_trip_point:2
/sys/class/thermal/thermal_zone0/cdev2_trip_point:3
/sys/class/thermal/thermal_zone0/cdev3_trip_point:4
/sys/class/thermal/thermal_zone0/mode:enabled
/sys/class/thermal/thermal_zone0/passive:0
/sys/class/thermal/thermal_zone0/temp:27000
/sys/class/thermal/thermal_zone0/trip_point_0_temp:256000
/sys/class/thermal/thermal_zone0/trip_point_0_type:critical
/sys/class/thermal/thermal_zone0/trip_point_1_temp:78000
/sys/class/thermal/thermal_zone0/trip_point_1_type:active
/sys/class/thermal/thermal_zone0/trip_point_2_temp:70000
/sys/class/thermal/thermal_zone0/trip_point_2_type:active
/sys/class/thermal/thermal_zone0/trip_point_3_temp:60000
/sys/class/thermal/thermal_zone0/trip_point_3_type:active
/sys/class/thermal/thermal_zone0/trip_point_4_temp:50000
/sys/class/thermal/thermal_zone0/trip_point_4_type:active
/sys/class/thermal/thermal_zone0/type:acpitz
/sys/class/thermal/thermal_zone1/cdev0_trip_point:1
/sys/class/thermal/thermal_zone1/cdev1_trip_point:1
/sys/class/thermal/thermal_zone1/mode:enabled
/sys/class/thermal/thermal_zone1/temp:29000
/sys/class/thermal/thermal_zone1/trip_point_0_temp:90000
/sys/class/thermal/thermal_zone1/trip_point_0_type:critical
/sys/class/thermal/thermal_zone1/trip_point_1_temp:87000
/sys/class/thermal/thermal_zone1/trip_point_1_type:passive
/sys/class/thermal/thermal_zone1/type:acpitz
/sys/class/thermal/thermal_zone2/mode:enabled
/sys/class/thermal/thermal_zone2/passive:0
/sys/class/thermal/thermal_zone2/temp:23000
/sys/class/thermal/thermal_zone2/trip_point_0_temp:105000
/sys/class/thermal/thermal_zone2/trip_point_0_type:critical
/sys/class/thermal/thermal_zone2/type:acpitz
/sys/class/thermal/thermal_zone3/cdev0_trip_point:1
/sys/class/thermal/thermal_zone3/cdev1_trip_point:1
/sys/class/thermal/thermal_zone3/mode:enabled
/sys/class/thermal/thermal_zone3/temp:20000
/sys/class/thermal/thermal_zone3/trip_point_0_temp:90000
/sys/class/thermal/thermal_zone3/trip_point_0_type:critical
/sys/class/thermal/thermal_zone3/trip_point_1_temp:60000
/sys/class/thermal/thermal_zone3/trip_point_1_type:passive
/sys/class/thermal/thermal_zone3/type:acpitz
/sys/class/thermal/thermal_zone4/mode:enabled
/sys/class/thermal/thermal_zone4/passive:0
/sys/class/thermal/thermal_zone4/temp:100000
/sys/class/thermal/thermal_zone4/trip_point_0_temp:110000
/sys/class/thermal/thermal_zone4/trip_point_0_type:critical
/sys/class/thermal/thermal_zone4/type:acpitz

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
