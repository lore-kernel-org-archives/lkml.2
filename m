Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1CEUxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:53:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab1CEUx3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <20110305203140.GD7546@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com>
 <20110303114952.B94B.A69D9226@jp.fujitsu.com> <20110303154706.GA22560@redhat.com>
 <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com>
 <20110305203040.GA7546@redhat.com> <20110305203140.GD7546@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Mar 2011 12:52:34 -0800
Message-ID: <AANLkTi=mce6tzg=vwf45XUQoADA=YbP2QJ2_tpg=QgQE@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] exec: unify do_execve/compat_do_execve code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, everything looks fine to me.

Except looking at this, I don't think this part:

On Sat, Mar 5, 2011 at 12:31 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
>  struct user_arg_ptr {
> -       const char __user *const __user *native;
> +#ifdef CONFIG_COMPAT
> +       bool is_compat;
> +#endif
> +       union {
> +               const char __user *const __user *native;
> +               compat_uptr_t __user *compat;
> +       } ptr;
>  };

will necessarily even compile on an architecture that doesn't have any
'compat' support.

Do we even define 'compat_uptr_t' for that case? I don't think so.

So I suspect you need two of those annoying #ifdef's. Or we need to
have some way to guarantee that 'compat_uptr_t' exists.

                           Linus
