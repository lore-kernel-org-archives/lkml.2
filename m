Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab1FQWZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:25:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:62828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1FQWZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:25:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,383,1304319600"; 
   d="scan'208";a="19646209"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 17 Jun 2011 15:25:51 -0700
Subject: RE: [PATCH 4/8] x86, mce: rename bootparam parser
Thread-Topic: [PATCH 4/8] x86, mce: rename bootparam parser
Thread-Index: AcwtBRxvCeswgRFNRH+butTteNCuiwAN4mCA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E8E3054B@orsmsx505.amr.corp.intel.com>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB13E2.4080909@jp.fujitsu.com> <20110617154143.GC20010@aftab>
In-Reply-To: <20110617154143.GC20010@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and leave this like this. "nomce" is the same as "mce=off" and frankly,
> I'd like to remove this redundancy, thus no need to do the code
> relocation. In addition, I don't think there are lots of systems running
> with "nomce" so I really think we should drop it.
>
> So Ingo, hpa, what is the proper way to remove early setup params? Maybe
> through Documentation/feature-removal-schedule.txt?

Though it seems odd to me that anyone would want to turn mce off,
the fact that we have two ways to do so would indicate that people
do (or at least did) want to do this.

It seems like we'd need a long "deprecated" period (till all the
major OSVs turn out a new release) to remove this without surprises.
If the "nomce" option just disappears, then people using it will
not realize that their boot time argument was ignored (until they
see a reported error).

-Tony

