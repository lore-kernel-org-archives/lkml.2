Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2EVNVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:21:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62223 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2EVNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:21:11 -0400
Date: Tue, 22 May 2012 06:19:38 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 03/14] pstore/ram_core: Do not reset restored zone's
 position and size
Message-ID: <20120522131938.GA26111@lizard>
References: <20120518222314.GA9425@lizard>
 <20120518222426.GC23089@lizard>
 <CAMbhsRRTFY-U7e4ifoDKjgy9mQj+p79aa52U=PoOmwBxjpLXNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRRTFY-U7e4ifoDKjgy9mQj+p79aa52U=PoOmwBxjpLXNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:42:03PM -0700, Colin Cross wrote:
[...]
> This causes an interesting behavior change in the console logging.
> Before this change, the console log would show only the messages from
> the last reboot.  After this change, the console log will have logs
> from multiple boots appended to each other.

Heh. A nice feature, but frankly speaking, that wasn't my intent to
introduce it. :-)

I will document the new behaviour in the patch description.

> I can think of some
> places where that could very handy, so I'm not against the change, but
> as is it makes reading the logs much harder - the first oops you see
> while skimming the log may not be from the last reboot.
> 
> One possibility would be to insert an obvious (and script parseable)
> header during probe to separate the boots.

Yep, we have it already, i.e. linux_banner. This script should be
reliable enough:

	tac ramoops-console | sed '/^Linux version.*(.*@.*)/ q' | tac

> Another option would be to
> expand the ringbuffer metadata to contain duplicate start and size
> fields that only cover the most recent reboot, and export two files,
> console-ramoops that contains the last log, and console-all-ramoops
> that contains all the logs.

This seems like an overkill. :-)

> Or you could just zap the console buffer
> at boot to keep the old behavior.

Well, I actually like the new behaviour, so assuming that we're all
happy with the new feature, there's no need to zap it at boot. Or
we can at least make it configurable...

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
