Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2FOWhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:37:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:33543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2FOWhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="180756958"
From: "Luck, Tony" <tony.luck@intel.com>
To: Colin Cross <ccross@android.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
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
Thread-Index: AQHNSxnUyTWscCuSSEGw988jRX6OJpb758LAgAB6cQD//4uj0IAAeJUA//+LT0CAAHhtAP//jN0g
Date: Fri, 15 Jun 2012 22:37:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19320CFB@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	<1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	<3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	<1339797308.25903.8.camel@gandalf.stny.rr.com>
	<3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
	<1339798214.25903.17.camel@gandalf.stny.rr.com>
	<3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
 <CAMbhsRTGs8G2Fnvy4jcN=kvuM+gA+Md4UuxOZOQYvASjsNOUBQ@mail.gmail.com>
In-Reply-To: <CAMbhsRTGs8G2Fnvy4jcN=kvuM+gA+Md4UuxOZOQYvASjsNOUBQ@mail.gmail.com>
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

> The decode also converts PCs to symbols, so for all the data to be
> useful you have to boot the exact same kernel

With the same modules loaded at the same addresses (if your traces
are going to include paths through loaded modules).

Perhaps include a hash of the kernel symbol table so the decoder
can tell whether it has any hope of making sense of the trace?
[Compute the hash at boot and when modules are loaded/unloaded,
then store in a header section of the binary ftrace record]

-Tony

