Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1BVLvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:51:09 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58868 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034Ab1BVLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:51:08 -0500
Date: Tue, 22 Feb 2011 13:51:03 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: Bug on Latitude E6410 battery
Message-ID: <20110222115103.GB16596@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110222114710.GA16596@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222114710.GA16596@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Tue, Feb 22, 2011 at 01:47:10PM +0200, Felipe Balbi wrote:
> there's some sort of weird bug on Latitude's battery as it shows 5600
> hours of battery time when it's discharging (gnome-power_manager says
> that), here are all files' contents from /sys/class/power_supply/BAT0/:
> 
> alarm:			0
> charge_full:		5276000
> charge_full_design:	5600000
> charge_now:		5230000
> current_now:		1606000
> cycle_count:		0
> manufacturer:		Samsung SDI
> model_name:		DELL H139107
> present:		1
> serial_number:		1422
> status:			Discharging
> technology:		Li-ion
> type:			Battery
> uevent:			POWER_SUPPLY_NAME=BAT0
> 			POWER_SUPPLY_STATUS=Discharging
> 			POWER_SUPPLY_PRESENT=1
> 			POWER_SUPPLY_TECHNOLOGY=Li-ion
> 			POWER_SUPPLY_CYCLE_COUNT=0
> 			POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11100000
> 			POWER_SUPPLY_VOLTAGE_NOW=12683000
> 			POWER_SUPPLY_CURRENT_NOW=1606000
> 			POWER_SUPPLY_CHARGE_FULL_DESIGN=5600000
> 			POWER_SUPPLY_CHARGE_FULL=5276000
> 			POWER_SUPPLY_CHARGE_NOW=5230000
> 			POWER_SUPPLY_MODEL_NAME=DELL H139107
> 			POWER_SUPPLY_MANUFACTURER=Samsung SDI
> 			POWER_SUPPLY_SERIAL_NUMBER=1422
> voltage_min_design:	11100000
> voltage_now:		12683000
> 
> BTW, I'm using 2.6.38-rc5

Now I just saw that it's maybe a race. Sometimes is shows correctly
(3 hours and something) and sometimes it shows wrong value (over 5000
hours).

It looks like the notification that I get when I remove the cable, shows
the wrong value and if after the notification vanishes, I put my mouse
pointer over the battery icon, then I get correctly value.

Maybe a bug on gnome-power-manager.

-- 
balbi
