Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab2B2Q6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:58:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:1343 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977Ab2B2Q6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:58:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112841789"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZUW7aAgAAO6gCAAAUXgIAACkUA//+aNaA=
Date: Wed, 29 Feb 2012 16:58:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab>
 <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab>
In-Reply-To: <20120229144054.GH21224@aftab>
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

> - severity: No real need for it. If the error is severe enough, the
> kernel handles automatically, i.e. memory poisoning and recovery. In all
> the other cases it is not severe enough.

We'll never see fatal errors via the perf/tracepoint (no way the RAS daemon
will run to pull them). But we will see both corrected error chatter and
recovered uncorrectable errors. I would be able to tell these apart.
Corrected errors in small doses are normal and don't require any
action beyond logging so you can see whether there are enough to cross
a threshold and cause alarm. Recovered uncorrectable errors are going
to be much rarer, and I think deserve closer scrutiny - even when there
is just one of them.
If you drop the severity field, is there some other way to make this
distinction?

> - silkscreen_label: <sarcasm> yeah, I'm getting a, say, a Data
> Cache error during an L1 linefill from L2, what the f*ck does the
> silkscreen label mean for such an error?! Well, nobody knows wtf it
> means!</sarcasm>

Cache error should point to a cpu socket - I'd like to have a silk
screen label for that (are they numbered "0, 1, 2 ..." on the motherboard
or "1, 2, 3 ..."?)  No idea where we'd get that information from. dmidecode
shows "Socket Designation: CPU 1" (and "2") for my current Sandy Bridge
system. I'd have to pull the system apart to see if those are helpful
in identifying which physical cpu is which.

-Tony
