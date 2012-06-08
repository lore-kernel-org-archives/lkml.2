Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227Ab2FHCM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:12:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52663 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab2FHCM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:12:58 -0400
Date: Thu, 7 Jun 2012 19:11:16 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH 2/5] pstore: Introduce write_buf backend callback
Message-ID: <20120608021115.GA29005@lizard>
References: <20120526133412.GA18001@lizard>
 <1338039549-24498-2-git-send-email-anton.vorontsov@linaro.org>
 <CAGXu5jL0E7ybLPvhFdwNxiHSa==QJr+fX45A-T8Ug7iXLhtW_A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F192F5FC4@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F5FC4@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:00:16PM +0000, Luck, Tony wrote:
> > Hrm, I thought the point of having pstore.buf pre-mapped was to allow
> > Oopses to be able to write directly to it without needing to hit any
> > additional kernel code. Maybe I'm misunderstanding this change,
> > though. I'd like to see Tony's opinion on it.
> 
> Yes - the ERST backend needs to have a bunch of header ugliness (with
> special UUIDs) at the front of the buffer that is stored to non-volatile
> storage. So it allocates its own buffer with all that junk, and then
> passes the address of the plain data portion of the buffer on to the
> pstore layer.
> 
> As we add more backends, it might be that this is only applicable to
> ERST, and so it might make sense to have it copy the data from some
> other buffer into its specially crafted one.  But we should not lose
> the "no allocations" property ... everything needed should be pre-allocated
> so we don't have to try to allocate any memory during a panic.

Yep, and everything is still pre-allocated.

The only change is that we can pass different buffers, and in tracing
case it is allocated on the stack (we can't use pstore.buf for tracing
as it would require grabbing pstore_lock, which we can't do -- the
locking operations are traced too, so it would recurse).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
