Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2FOWT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:19:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:7078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121Ab2FOWT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="153971069"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        "arve@android.com" <arve@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: [PATCH 3/6] pstore: Add persistent function tracing
Thread-Topic: [PATCH 3/6] pstore: Add persistent function tracing
Thread-Index: AQHNSxnUyTWscCuSSEGw988jRX6OJpb758LAgAB6cQD//4uj0IAAeJUA//+LT0A=
Date: Fri, 15 Jun 2012 22:19:54 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	 <1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	 <1339797308.25903.8.camel@gandalf.stny.rr.com>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
 <1339798214.25903.17.camel@gandalf.stny.rr.com>
In-Reply-To: <1339798214.25903.17.camel@gandalf.stny.rr.com>
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

> milli-seconds for recording? This would cripple the kernel. On slow
> machines, incorporating lockdep into function tracing (and other debug
> options) causes the system to live lock. Tracing the timer interrupt
> took so long that by the time it finished, the next timer triggered
> again.

Ah - I think I misunderstood how this works ... I thought the function
trace was taken at some point in the crash/shutdown path.  Now I see
that it is being generated repeatedly as the kernel runs ... with the
idea that if a hang happens, you can see the last call trace that was
successful.

Ok then - clearly this is only useful with a ram backend for pstore.

Binary makes sense too - but I'll stick with my comment that a different
kernel must be able to do the decode. Or we need to spell out clearly
that you must have the same, or compatible kernel booted to make any
sense of the saved ftrace record.

-Tony
