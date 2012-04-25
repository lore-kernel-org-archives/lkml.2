Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2DYRzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:55:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:28575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2DYRzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158285105"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: RE: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Topic: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Thread-Index: AQHNHA2e4drkei19OkSnQ3ASg+FwI5apMDmAgAALcwCAAQ8KgIAAEmmAgAATNgCAAASGAIAABdUAgAAOWYCAACKNgIAAEACAgAGQrgD//5KrQA==
Date: Wed, 25 Apr 2012 17:55:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170F3D5B@ORSMSX104.amr.corp.intel.com>
References: <20120423174955.GH6147@aftab.osrc.amd.com>
 <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com>
 <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com>
 <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com>
 <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com>
 <4F96E1EB.1030407@redhat.com> <20120425171904.GM18882@aftab.osrc.amd.com>
In-Reply-To: <20120425171904.GM18882@aftab.osrc.amd.com>
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

> And now the question is, when you get a DRAM ECC, how does the hardware
> point to the DIMM in error, does it give you a (channel, slot) tuple
> or a virtual address which you have to un-interleave? From MCA, you're
> getting a virtual address in MC4_ADDR so how do you compute this one
> back to a DIMM?

Right now we have the EDAC driver doing a reverse translation from the
physical address it finds in MC5_ADDR using the SAD/TAD/... register
information to get to a DIMM address.

Some of the same information does get reported by BIOS via HEST to
the ghes driver ... but Linux currently isn't looking at it (this
was the code path to get physical address on Nehalem/Westmere
generations where the h/w didn't always provide a valid address)
See apei_mce_report_mem_error() in mce-apei.c ... the error record
passed in may have a bunch more fields valid which would help in
identifying the DIMM.

-Tony
