Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575Ab2EWRB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:01:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:57974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2EWRB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:01:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156211798"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>
CC: "bp@amd64.org" <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Topic: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Index: AQHNOIwYcjpXeEEfSUqwVYn22Q7zo5bXnJGA///5EsA=
Date: Wed, 23 May 2012 17:01:54 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205230859190.3231@ionos>
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

> What's the point of doing this work? Why can't we just do that on the
> CPU which got hit by the MCE storm and leave the others alone? They
> either detect it themself or are just not affected. 

CMCI gets broadcast to all threads on a socket. So
if one cpu has a problem, many cpus have a problem :-(
Some machine check banks are local to a thread/core,
so we need to make sure that the CMCI gets taken by
someone who can actually see the bank with the problem.
The others are collateral damage - but this means there
is even more reason to do something about a CMCI storm
as the effects are not localized.

> What's wrong with doing that strictly per cpu and avoid the whole
> global state horror?

Is that less of a horror? We'd have some cpus polling and some
taking CMCI (in somewhat arbitrary and ever changing combinations).
I'm not sure which is less bad.

-Tony
