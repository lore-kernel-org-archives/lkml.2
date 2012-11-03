Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2KCLvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:51:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52796 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2KCLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:51:36 -0400
Date: Sat, 3 Nov 2012 15:51:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] proc: add "Seccomp" to status
Message-ID: <20121103115129.GA4508@cachalot>
References: <20121101183516.GA18332@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101183516.GA18332@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 11:35 -0700, Kees Cook wrote:
> @@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  	render_cap_t(m, "CapBnd:\t", &cap_bset);
>  }
>  
> +static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
> +{
> +#ifdef CONFIG_SECCOMP
> +	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
> +#endif

Hmm, probably it's better to always show this line, not only on
SECCOMP'ed kernel?  If it is disabled just print "0".  It will simplify
parsing of /proc/pid/status.

> +}
> +
>  static inline void task_context_switch_counts(struct seq_file *m,
>  						struct task_struct *p)
>  {

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
