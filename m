Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2LDOLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:11:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:14391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2LDOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:11:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="228767384"
Message-ID: <1354630272.2480.4.camel@rzhang1-mobl4>
Subject: Re: regression in linux 3.7 - fan speed at 100% after
 suspend/resume at 100%
From: Zhang Rui <rui.zhang@intel.com>
To: Roberto Oppedisano <roberto.oppedisano@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        eduardo.valentin@ti.com
Date: Tue, 04 Dec 2012 22:11:12 +0800
In-Reply-To: <50BDF345.60804@gmail.com>
References: <50BDF345.60804@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Roberto,

please attach the acpidump output.

On Tue, 2012-12-04 at 13:57 +0100, Roberto Oppedisano wrote:
> Hello,
>      with recent kernels after a suspend/resume cycle on my laptop (HP 
> 6730b) the fans stays at full speed.
does the fan keep running at full speed after resume?

please attach the output of "grep . /sys/class/thermal/*/*" before
suspend and when the fan is running at full speed.
please attach the same stuff in a good kernel.


thanks,
rui


> I've bisected down to this commit:
> 
> ce119f83257aae29b84a5bfad0669e8348437b18 is the first bad commit
> commit ce119f83257aae29b84a5bfad0669e8348437b18
> Author: Zhang Rui <rui.zhang@intel.com>
> Date:   Wed Jun 27 14:13:04 2012 +0800
> 
>      Thermal: Introduce simple arbitrator for setting device cooling state
> 
>      This fixes the problem that a cooling device may be referenced by
>      by multiple trip points in multiple thermal zones.
> 
>      With this patch, we have two stages for updating a thermal zone,
>      1. check if a thermal_instance needs to be updated or not
>      2. update the cooling device, based on the target cooling state
>         of all its instances.
> 
>      Note that, currently, the cooling device is set to the deepest
>      cooling state required.
> 
>      Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>      Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
>      Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
> :040000 040000 8469b057ee5b33bdb264624db35c951d0ecdb66b 
> d7288437cff3c7437e59144c46c04c78669a597b M      drivers
> :040000 040000 397296161d55c825f07501470130928d226497cc 
> f715fd1770dd33fd333c5fa339e740537b2a916f M      include
> 
> I tried to revert it but there are rejects so I cold not try current 
> kernel with simply this commit removed.
> 
> As a side note when the fan is at full speed a see an anomaly on thermal 
> indicator #4
> 
> $ grep 0 /sys/devices/virtual/thermal/thermal_zone*/temp
> /sys/devices/virtual/thermal/thermal_zone0/temp:59000
> /sys/devices/virtual/thermal/thermal_zone1/temp:63000
> /sys/devices/virtual/thermal/thermal_zone2/temp:48000
> /sys/devices/virtual/thermal/thermal_zone3/temp:27900
> /sys/devices/virtual/thermal/thermal_zone4/temp:100000
> 
> while the others seem to report normal value. Attached the output of 
> dmesg on this laptop.
> 
> More info/testing on request.
> 
> Kind regards
> R


