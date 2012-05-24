Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab2EXQ1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:27:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:60825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360Ab2EXQ1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:27:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148001369"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chen Gong <gong.chen@linux.intel.com>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Topic: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Index: AQHNOIwYcjpXeEEfSUqwVYn22Q7zo5bXnJGA///5EsCAAJq/AP//onrQgAFcxQD///HsgA==
Date: Thu, 24 May 2012 16:27:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F37C0@ORSMSX104.amr.corp.intel.com>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205241033460.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205241033460.3231@ionos>
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

> So can you please explain how this is better than having this strict
> per cpu and avoid all the mess which comes with that patch? The
> approach of letting global state be modified in a random manner is
> just doomed.

Well doomed sounds bad :-) ... and I think I now agree that we should
get rid of global state and have polling vs. CMCI mode be per-cpu. It
means that it will take fractionally longer to react to a storm, but
on the plus side we'll naturally set storm mode on just the cpus
that are seeing it on a multi-socket system without having to check
topology data ... which should be better for the case where a noisy
source of CMCI is plaguing one socket, while other sockets have some
much lower rate of CMCI that we'd still like to log.

Thanks for the review.

-Tony
