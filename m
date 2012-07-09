Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2GIXrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:47:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44988 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2GIXrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:47:02 -0400
Date: Mon, 9 Jul 2012 16:44:58 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 4/7] tracing/function: Introduce persistent trace option
Message-ID: <20120709234457.GA25140@lizard>
References: <20120626232210.GA11549@lizard>
 <1340753009-12483-4-git-send-email-anton.vorontsov@linaro.org>
 <1340800812.16702.3.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340800812.16702.3.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:40:12AM -0400, Steven Rostedt wrote:
> On Tue, 2012-06-26 at 16:23 -0700, Anton Vorontsov wrote:
> > @@ -219,6 +232,8 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
> >  
> >  		return 0;
> >  	}
> > +	if (bit == TRACE_FUNC_OPT_PSTORE)
> > +		return 0;
> 
> Perhaps this should be a switch() statement, or at least put a
>  } else if () {
> 
> As it can't be bit == TRACE_FUNC_OPT_STACK and bit ==
> TRACE_FUNC_OPT_PSTORE.

Yup, thanks for the idea. I'll start using 'else if' at first, and then
will convert it to a switch statement via a separate patch, that way I'll
not clobber the functional patch with cosmetic changes.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
