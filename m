Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2LSOg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:36:27 -0500
Received: from mx02.infracom.it ([62.196.48.11]:33582 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2LSOgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:36:21 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 09:36:20 EST
Message-ID: <50D1CF9D.2090709@infracom.it>
Date: Wed, 19 Dec 2012 15:30:53 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <eduardo.valentin@ti.com>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
References: <50BDF345.60804@gmail.com> <1354630272.2480.4.camel@rzhang1-mobl4> <50BEF830.6020206@gmail.com>
In-Reply-To: <50BEF830.6020206@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     any news about this issue ? I'm still seeing the problem with the 
released 3.7 (and also with 3.7.1).
Let me know if you need more info or testing.

Kind regards
R

Il 05/12/2012 08:30, Roberto Oppedisano ha scritto:
> Hello Rui
>
> Il 04/12/2012 15:11, Zhang Rui ha scritto:
>> Hi, Roberto,
>>
>> please attach the acpidump output.
>
> attached.
>
>> On Tue, 2012-12-04 at 13:57 +0100, Roberto Oppedisano wrote:
>>> Hello,
>>>       with recent kernels after a suspend/resume cycle on my laptop (HP
>>> 6730b) the fans stays at full speed.
>> does the fan keep running at full speed after resume?
>
> yes, the fan never stops and runs always at full speed.
>
>
>> please attach the output of "grep . /sys/class/thermal/*/*" before
>> suspend and when the fan is running at full speed.
>> please attach the same stuff in a good kernel.
>
> See attached files.
> 3.6.9 is the good kernel where the fan behaves correctly.
> 3.7.0+git is the bad one.
>
> Kind regards
> R
>
>>
>>
>> thanks,
>> rui
>>
>>
>>> I've bisected down to this commit:
>>>
>>> ce119f83257aae29b84a5bfad0669e8348437b18 is the first bad commit
>>> commit ce119f83257aae29b84a5bfad0669e8348437b18
>>> Author: Zhang Rui <rui.zhang@intel.com>
>>> Date:   Wed Jun 27 14:13:04 2012 +0800
>>>
>>>       Thermal: Introduce simple arbitrator for setting device 
>>> cooling state
>>>
>>>       This fixes the problem that a cooling device may be referenced by
>>>       by multiple trip points in multiple thermal zones.
>>>
>>>       With this patch, we have two stages for updating a thermal zone,
>>>       1. check if a thermal_instance needs to be updated or not
>>>       2. update the cooling device, based on the target cooling state
>>>          of all its instances.
>>>
>>>       Note that, currently, the cooling device is set to the deepest
>>>       cooling state required.
>>>
>>>       Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>>>       Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>       Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>
>>> :040000 040000 8469b057ee5b33bdb264624db35c951d0ecdb66b
>>> d7288437cff3c7437e59144c46c04c78669a597b M      drivers
>>> :040000 040000 397296161d55c825f07501470130928d226497cc
>>> f715fd1770dd33fd333c5fa339e740537b2a916f M      include
>>>
>>> I tried to revert it but there are rejects so I cold not try current
>>> kernel with simply this commit removed.
>>>
>>> As a side note when the fan is at full speed a see an anomaly on 
>>> thermal
>>> indicator #4
>>>
>>> $ grep 0 /sys/devices/virtual/thermal/thermal_zone*/temp
>>> /sys/devices/virtual/thermal/thermal_zone0/temp:59000
>>> /sys/devices/virtual/thermal/thermal_zone1/temp:63000
>>> /sys/devices/virtual/thermal/thermal_zone2/temp:48000
>>> /sys/devices/virtual/thermal/thermal_zone3/temp:27900
>>> /sys/devices/virtual/thermal/thermal_zone4/temp:100000
>>>
>>> while the others seem to report normal value. Attached the output of
>>> dmesg on this laptop.
>>>
>>> More info/testing on request.
>>>
>>> Kind regards
>>> R
>>
>>
>


-- 
Roberto Oppedisano
Infracom Italia S.p.A.
Ingegneria d'offerta
Tel. +39 0459692691
Mob. +39 3487419534

