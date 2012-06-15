Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab2FOWXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:23:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35102 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab2FOWXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
References: <20120615170659.GA4060@lizard>
	<1339780111-12075-3-git-send-email-anton.vorontsov@linaro.org>
	<3908561D78D1C84285E8C5FCA982C28F1931FC30@ORSMSX104.amr.corp.intel.com>
	<1339797308.25903.8.camel@gandalf.stny.rr.com>
	<3908561D78D1C84285E8C5FCA982C28F1931FC85@ORSMSX104.amr.corp.intel.com>
	<1339798214.25903.17.camel@gandalf.stny.rr.com>
	<3908561D78D1C84285E8C5FCA982C28F19320CC9@ORSMSX104.amr.corp.intel.com>
Date: Fri, 15 Jun 2012 15:23:36 -0700
X-Google-Sender-Auth: CoKz16fWrQGmmJg9-jWJSLCIHO0
Message-ID: <CAMbhsRTGs8G2Fnvy4jcN=kvuM+gA+Md4UuxOZOQYvASjsNOUBQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 3:19 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> milli-seconds for recording? This would cripple the kernel. On slow
>> machines, incorporating lockdep into function tracing (and other debug
>> options) causes the system to live lock. Tracing the timer interrupt
>> took so long that by the time it finished, the next timer triggered
>> again.
>
> Ah - I think I misunderstood how this works ... I thought the function
> trace was taken at some point in the crash/shutdown path.  Now I see
> that it is being generated repeatedly as the kernel runs ... with the
> idea that if a hang happens, you can see the last call trace that was
> successful.
>
> Ok then - clearly this is only useful with a ram backend for pstore.
>
> Binary makes sense too - but I'll stick with my comment that a different
> kernel must be able to do the decode. Or we need to spell out clearly
> that you must have the same, or compatible kernel booted to make any
> sense of the saved ftrace record.

The decode also converts PCs to symbols, so for all the data to be
useful you have to boot the exact same kernel.  You could
theoretically boot a different kernel with a compatible format, but
you would have to manually extract the PCs from the dump and addr2line
them against the correct vmlinux, which is probably more trouble than
it's worth.  Also, the binary data is stored inside a pstore_ram
ringbuffer that may change formats between kernels.  I would suggest
documenting that this is only supposed to work booting back to the
same kernel.
