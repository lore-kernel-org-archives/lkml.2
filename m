Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab2BQHH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:07:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:5108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab2BQHHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:07:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="111311006"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "Lin, Ming M" <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Thread-Topic: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Thread-Index: AQHM6i+B2PgdCa63bk+eUxfLOi0T+ZY6xxQAgAC7uACAAPTnAIACJBMAgACE0wCAAY0vIA==
Date: Fri, 17 Feb 2012 07:05:55 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926305BFDC@SHSMSX101.ccr.corp.intel.com>
References: <1329376686.28581.15.camel@rui.sh.intel.com>
 <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, alan,

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, February 16, 2012 11:14 PM
> To: Zhang, Rui
> Cc: Rafael J. Wysocki; Lin, Ming M; Jeff Garzik; Tejun Heo; Len Brown;
> linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-pm@vger.kernel.org
> Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power
> Resource
> Importance: High
> 
> On Thu, 16 Feb 2012, Zhang Rui wrote:
> 
> > > I'm not exactly sure what you're trying to achieve and what you
> mean by
> > > "resume a device directly"?  Do you want to run the device's resume
> > > callback at the time when another device is being resumed?
> > >
> > I mean, wakeup event is sent to ATA port, but our goal is to resume
> > ZPODD after receiving this wakeup event.
> > Ideally, it is ACPI that resumes ATA port. And then, the ATA port
> > runtime resumes ZPODD. But this does not look good to runtime resume
> a
> > child device in the parent's .runtime_resume callback.
> > So I introduced these two APIs so that an runtime_resume request can
> be
> > sent to ZPODD directly and the runtime PM core can resume all the
> > parents of ZPODD automatically.
> 
> It's not clear what you're trying to achieve.


> Do you basically want
> the ZPODD always to be suspended and resumed along with the ATA port,

No. ZPODD suspends itself, which put ZPODD to a SCSI low power state (NOT power off/D3_COLD).
And then it is the "Runtime PM core" that suspends ATA port after ZPODD being suspended.
And the .runtime_suspend callback for ATA port actually turns off the ZPODD power.

During resume, ATA port is resumed first because of the ACPI wakeup event. 
But in fact, this wakeup event should be read as "ZPODD remote wakeup signal", thus runtime resume request is sent to ZPODD, done by Patch 3/6.

> or should it be possible to suspend the ZPODD while the port remains
> running?
> 
Sure, but the power is still on at this time.

Thanks,
rui
