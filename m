Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965902Ab2B2SMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:12:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:33381 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964975Ab2B2SMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:12:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="71914859"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZTmLGAgACV04CAAB/YAP//0NAwgACSmoD//3p+kA==
Date: Wed, 29 Feb 2012 18:11:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040219@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F040162@ORSMSX104.amr.corp.intel.com>
 <4F4E67C3.9030000@redhat.com>
In-Reply-To: <4F4E67C3.9030000@redhat.com>
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

> That probably means that the needed cpu family/model info is not (or may not) be
> stored at the MCE structure.

mcelog can run as a daemon, or one-off to process reports from earlier (or
even from other systems). It picks up cpu/family from /proc/cpuinfo - but can
also take a command line argument. These get checked against the cpuid
field in the structure that is read from /dev/mcelog (or decoded from a
console log with the --ascii option).

In some cases the checks may be redundant (e.g. running in daemon mode,
there is no way that /dev/mcelog will not have a cpuid that matches the
cpu that you are running on!) But better to have too many checks than too
few.

-Tony
