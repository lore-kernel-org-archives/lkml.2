Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2FYSSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:18:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:50230 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2FYSSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:18:50 -0400
Message-ID: <4FE8AAFC.1080306@windriver.com>
Date: Mon, 25 Jun 2012 14:16:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Daniel Santos <daniel.santos@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        <linux-doc@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 6/13] bug.h: Replace __linktime_error with __compiletime_error
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <1340424048-7759-7-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1340424048-7759-7-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-06-23 12:00 AM, Daniel Santos wrote:
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index aaac4bb..298a916 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
>  #define BUILD_BUG()						\
>  	do {							\
>  		extern void __build_bug_failed(void)		\
> -			__linktime_error("BUILD_BUG failed");	\
> +			__compiletime_error("BUILD_BUG failed");\

At a quick glance of the bug.h parts, I would think you need
this commit _before_ #5 (that deleted __linktime_error) otherwise
you'll have introduced a bisection build failure.  Or, alternatively
you could combine #5 and #6 since they are clearly related, and
their separation is more of a per-file CVS mentality than it is of
any existence of distinct and separate/unrelated changesets.

P.

>  		__build_bug_failed();				\
>  	} while (0)
>  
