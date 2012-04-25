Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2DYSop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab2DYSon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:44:43 -0400
Message-ID: <4F984611.8040802@redhat.com>
Date: Wed, 25 Apr 2012 15:44:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com> <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com> <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com> <4F96E1EB.1030407@redhat.com> <20120425171904.GM18882@aftab.osrc.amd.com> <4F9838BB.5010209@redhat.com> <3908561D78D1C84285E8C5FCA982C28F170F3DA7@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170F3DA7@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-04-2012 15:32, Luck, Tony escreveu:
>> See the driver: the only useful information provided by the MCA log is
>> that an error happened, their physical address, and the type of the 
>> error. Unlikely the Nehalem MCA, the MCE_MISC registers won't point to the
>> DIMM in the error.
> 
> There's a bit more information in the MCA log than just the physical address:
> 
> The cpu number that finds the data in its bank will provide socket information.
> [/proc/cpuinfo maps logical cpu numbers to "physical id"]

Yes, but this seems to be different than the CPU that actually has the memory
controller. The MCA registers have a bit to mark if the the error is at the
same CPU or on another one. So, when there's just 2 CPU (sockets), this could
be used, but, for more than 2 CPUs, this field is useless.

So, I opted to not trust on it.

> Low order bits of the MCi_STATUS register will give the channel. See the SDM.

On all tests I did, the channel information reported via MCi_status didn't
match the channel reported via the decoding logic. Maybe this might be due
to some bug on the pre-release CPUs I used so far.

> So the only missing information from the MCA log is which DIMM within
> the channel.  I.e. we can pin the fault to a group of either two or
> three DIMMs depending on how many DIMMS/channel the motherboard supports.
> 
> If you only have one DIMM per channel populated than socket/channel is
> sufficient to identify the DIMM.
> 
> [We also don't have any intra-DIMM information for those customers who
> would like to diagnose the device on the DIMM, or which bits within
> the cache line had the error]
> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

