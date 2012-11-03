Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2KCQHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:07:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64768 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab2KCQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121103115129.GA4508@cachalot>
References: <20121101183516.GA18332@www.outflux.net>
	<20121103115129.GA4508@cachalot>
Date: Sat, 3 Nov 2012 09:07:49 -0700
X-Google-Sender-Auth: 0NifLt01aOAcxhpk9Z4d0H6FtqU
Message-ID: <CAGXu5j+MmOfh2xSg6vzaK8RWYr_+tDnT=95VAKSm_4GKM0zm6A@mail.gmail.com>
Subject: Re: [PATCH v2] proc: add "Seccomp" to status
From: Kees Cook <keescook@chromium.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 4:51 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Thu, Nov 01, 2012 at 11:35 -0700, Kees Cook wrote:
>> @@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>>       render_cap_t(m, "CapBnd:\t", &cap_bset);
>>  }
>>
>> +static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
>> +{
>> +#ifdef CONFIG_SECCOMP
>> +     seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
>> +#endif
>
> Hmm, probably it's better to always show this line, not only on
> SECCOMP'ed kernel?  If it is disabled just print "0".  It will simplify
> parsing of /proc/pid/status.

I disagree -- if the line is missing it means the kernel doesn't
support it, which is a different state from seccomp being inactive in
the process.

And since other things when not built into the kernel are similarly
missing from status, this is the consistent behavior for such
situations.

-Kees

-- 
Kees Cook
Chrome OS Security
