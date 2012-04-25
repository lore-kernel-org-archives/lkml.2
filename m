Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2DYScZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:32:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:52531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab2DYScX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135301476"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: RE: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Topic: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Index: AQHNHA2e4drkei19OkSnQ3ASg+FwI5apMDmAgAALcwCAAQ8KgIAAEmmAgAATNgCAAASGAIAABdUAgAAOWYCAACKNgIAAEACAgAGQrgCAAAf8gP//k8Wg
Date: Wed, 25 Apr 2012 18:32:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170F3DA7@ORSMSX104.amr.corp.intel.com>
References: <20120423174955.GH6147@aftab.osrc.amd.com>
 <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com>
 <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com>
 <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com>
 <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com>
 <4F96E1EB.1030407@redhat.com> <20120425171904.GM18882@aftab.osrc.amd.com>
 <4F9838BB.5010209@redhat.com>
In-Reply-To: <4F9838BB.5010209@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See the driver: the only useful information provided by the MCA log is
> that an error happened, their physical address, and the type of the 
> error. Unlikely the Nehalem MCA, the MCE_MISC registers won't point to the
> DIMM in the error.

There's a bit more information in the MCA log than just the physical address:

The cpu number that finds the data in its bank will provide socket information.
[/proc/cpuinfo maps logical cpu numbers to "physical id"]

Low order bits of the MCi_STATUS register will give the channel. See the SDM.

So the only missing information from the MCA log is which DIMM within
the channel.  I.e. we can pin the fault to a group of either two or
three DIMMs depending on how many DIMMS/channel the motherboard supports.

If you only have one DIMM per channel populated than socket/channel is
sufficient to identify the DIMM.

[We also don't have any intra-DIMM information for those customers who
would like to diagnose the device on the DIMM, or which bits within
the cache line had the error]

-Tony
