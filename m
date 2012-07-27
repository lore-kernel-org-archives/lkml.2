Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2G0Tav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:30:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37148 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2G0Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120726142514.GA32158@lizard>
References: <20120726142514.GA32158@lizard>
Date: Fri, 27 Jul 2012 12:30:49 -0700
Message-ID: <CAMbhsRSM3QwwVfUMBWq1bDJxHX+Ox2CQtbvJVmemuMWjxfmDoQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
From: Colin Cross <ccross@google.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 7:25 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Hi all,
>
> Here is a patchset that implements "kiosk" mode for KDB debugger. The
> mode provides reduced set of features, so that it is no longer possible
> to leak sensitive data via the debugger, and not possible to change
> program flow in a predefined manner.
>
> The are two use-cases for the mode, one is evil, but another is quite
> legitimate.
>
> The evil use case is used by some (ahem) phone manufaturers that want
> to have a debuging facilities on a production device, but still don't
> want you to use the debugger to gain root access. I don't like locked
> phones, and I would not touch this/get my hands dirty by implementing
> the feature just for this evil (IMHO) use case.

The point of the reduced feature set in FIQ debugger is not to prevent
you from accessing your own phone, it designed to prevent others from
trivially rooting your phone and reading your data.  Both locked and
unlocked phones run FIQ debugger.  Would you carry a phone with
personal data on it and KGDB enabled on the serial console?

An alternate option would be to allow userspace to write a password
hash to a sysfs file, and require the password to be entered over the
serial console to unlock KGDB or enable unsafe KGDB commands.

> But there is another non-evil use case: limitting access to public
> devices, i.e. "kiosks", ATMs (is that too much?) or just public
> computers w/ guest access. I can imagine that an administrator would
> want to setup a kernel so that upon an oops (or a sysrq event) the
> kernel would enter KDB, but at the same time, he would not want to
> leak sensitive data from the PC by means of the debugger.
>
> There are seven patches, the first five of them are just cleanups and
> preparations. I believe these five patches are good even if not
> considering the kiosk mode. And the rest of patches actually implement
> the mode -- it is pretty straightforward.
>
> Note that we might impelement the same mode for KGDB stub, but so far
> we don't bother.
>
> Thanks!
>
> --
>  include/linux/kdb.h            |   16 ++--
>  kernel/debug/kdb/kdb_bp.c      |   35 ++++----
>  kernel/debug/kdb/kdb_main.c    |  183 +++++++++++++++++++++-------------------
>  kernel/debug/kdb/kdb_private.h |    3 +-
>  kernel/trace/trace_kdb.c       |    4 +-
>  5 files changed, 126 insertions(+), 115 deletions(-)
>
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
