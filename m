Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3ADU6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:58:20 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54107 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3ADU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <20130104201516.GA24228@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-4-git-send-email-yinghai@kernel.org>
	<20130104201516.GA24228@x1.alien8.de>
Date: Fri, 4 Jan 2013 12:58:15 -0800
X-Google-Sender-Auth: Y59uSN93n9iLio7AjjqvI3I4RRk
Message-ID: <CAE9FiQWvp7UPY7f33B9cG05S4ALCN-ezMi2N=-z++9w-Dp_+ZQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
>  /*
> - * set_real_mode_permissions() gets called very early, to guarantee the
> - * availability of low memory.  This is before the proper kernel page
> - * tables are set up, so we cannot set page permissions in that
> - * function.  Thus, we use an arch_initcall instead.
> + * This function gets called very early to guarantee the availability
> + * of low memory. This is even before the proper kernel page tables are
> + * set up, so we cannot set page permissions in that function. However,
> + * trampoline code will be executed by APs so we need it to be marked
> + * executable at pre-SMP time, thus run it as a early_initcall().
>   */

more than that, that set_real_mode_permissions reference is wrong,
actually it is set_real_mode.

 /*
- * set_real_mode_permissions() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
+ * set_real_mode() gets called very early, to guarantee the
+ * availability of low memory. This is before the proper kernel page
  * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
+ * function. Also trampoline code will be executed by APs so we
+ * need to mark it executable at do_pre_smp_initcalls() at least,
+ * thus run it as a early_initcall().
  */
