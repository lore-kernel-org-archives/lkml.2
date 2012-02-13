Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2BMV3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:29:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:6598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2BMV3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:29:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124945340"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
Thread-Topic: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
Thread-Index: AQHM54c9gOEbbYOPEUuKBhS7xv0rF5Y2pkOAgAA19wCAAtjhgIAAVIKAgAFSxfA=
Date: Mon, 13 Feb 2012 21:29:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03B1C9@ORSMSX104.amr.corp.intel.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
 <20120210132633.GA16783@aftab> <4F35484E.7030807@redhat.com>
 <20120212120827.GA32467@aftab> <4F37F29F.2040002@redhat.com>
In-Reply-To: <4F37F29F.2040002@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For CE, it is able to detect what dimm has problem, but, when lockstep is
> enabled, an Uncorrected Error would point to the two channels at the affected
> branch. Also, when memory mirror is enabled, there are 4 DIMMs associated to the
> same 128-bit memory address. Any one of those memories could be affected by
> the error. Only the Sandy Bridge driver handles memory mirror, and I'll need
> to add some extra logic to the location detect algorithm, in order to work
> with it (it is currently on my TODO list).

This looks like a hard problem to solve. In mirror mode memory writes go to
both sides, reads come from the master. To determine the location of the error
you'd need to know which set was the master at the time the error was detected.
Note that can change (and since we know we just had an error it might have been
switched because of the error we just saw). We don't have any visibility from
the OS as to what the BIOS is doing with mirrors.

-Tony
