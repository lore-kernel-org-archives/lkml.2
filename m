Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2FOWKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:10:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:10:16 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MgfmKKM-MiAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pvuyzcT5f7YbdC04ncIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339798214.25903.17.camel@gandalf.stny.rr.com>
Subject: RE: [PATCH 3/6] pstore: Add persistent function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
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
Date: Fri, 15 Jun 2012 18:10:14 -0400
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	 <1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	 <1339797308.25903.8.camel@gandalf.stny.rr.com>
	 <3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 22:00 +0000, Luck, Tony wrote:
> > With function tracing the impact to performance is tremendous. Just
> > recording two long words is a 130% hit to performance. Now multiply that
> > to recording strings.
> 
> If pstore is writing to a flash based backend - then there will be many
> milli-seconds of delay. I think the time taken to convert from binary to
> ascii would be insignificant.

milli-seconds for recording? This would cripple the kernel. On slow
machines, incorporating lockdep into function tracing (and other debug
options) causes the system to live lock. Tracing the timer interrupt
took so long that by the time it finished, the next timer triggered
again.

Heck, today you can pretty much live lock most machines if you enabled
the option 'func_stack_trace' while function tracing without filtering.
You may be able to get your system back again, but it usually takes
several seconds to acknowledge each key stroke (if you're lucky, but we
all know *you* are ;-)


If we are talking about milli-seconds to record. Then this is a no go,
as it wont be worth adding. I'm thinking their buffering system is much
faster than that today, as they have shown examples already.

-- Steve


