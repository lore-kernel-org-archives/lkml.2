Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2E2SAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:00:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:33003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab2E2SAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145883895"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Steven Rostedt <rostedt@goodmis.org>,
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
Subject: RE: [PATCH 2/5] pstore: Introduce write_buf backend callback
Thread-Topic: [PATCH 2/5] pstore: Introduce write_buf backend callback
Thread-Index: AQHNO0U5XSurDYwhFEKM6MvB2BU9WZbhbxiA//+idTA=
Date: Tue, 29 May 2012 18:00:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F5FC4@ORSMSX104.amr.corp.intel.com>
References: <20120526133412.GA18001@lizard>
	<1338039549-24498-2-git-send-email-anton.vorontsov@linaro.org>
 <CAGXu5jL0E7ybLPvhFdwNxiHSa==QJr+fX45A-T8Ug7iXLhtW_A@mail.gmail.com>
In-Reply-To: <CAGXu5jL0E7ybLPvhFdwNxiHSa==QJr+fX45A-T8Ug7iXLhtW_A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hrm, I thought the point of having pstore.buf pre-mapped was to allow
> Oopses to be able to write directly to it without needing to hit any
> additional kernel code. Maybe I'm misunderstanding this change,
> though. I'd like to see Tony's opinion on it.

Yes - the ERST backend needs to have a bunch of header ugliness (with
special UUIDs) at the front of the buffer that is stored to non-volatile
storage. So it allocates its own buffer with all that junk, and then
passes the address of the plain data portion of the buffer on to the
pstore layer.

As we add more backends, it might be that this is only applicable to
ERST, and so it might make sense to have it copy the data from some
other buffer into its specially crafted one.  But we should not lose
the "no allocations" property ... everything needed should be pre-allocated
so we don't have to try to allocate any memory during a panic.

-Tony
