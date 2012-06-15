Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2FOWJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:09:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55408 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:09:42 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	<1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	<3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	<1339797308.25903.8.camel@gandalf.stny.rr.com>
	<3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
Date: Fri, 15 Jun 2012 15:09:41 -0700
X-Google-Sender-Auth: HeWEHPWaysCAg3kssBwpcJKgpMY
Message-ID: <CAMbhsRR14=AHRaU3_f8E+6jOEqVs_wxSFUJsknsO4_udK7TANQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] pstore: Add persistent function tracing
From: Colin Cross <ccross@android.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 3:00 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> With function tracing the impact to performance is tremendous. Just
>> recording two long words is a 130% hit to performance. Now multiply that
>> to recording strings.
>
> If pstore is writing to a flash based backend - then there will be many
> milli-seconds of delay. I think the time taken to convert from binary to
> ascii would be insignificant.

Function tracing into flash would be silly, adding milliseconds of
overhead to every function call is enormous.  The normal use case for
this is tracing to persistent ram, and even the difference between 2
and 3 words in the binary format was noticeable.  Converting to ascii
would expand 2 words to at least 20 words, making the entire feature
useless.
