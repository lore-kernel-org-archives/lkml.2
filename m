Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1DWR76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1DWR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:59:57 -0400
Date: Sat, 23 Apr 2011 19:59:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] do_sigtimedwait() needs retarget_shared_pending()
Message-ID: <20110423175901.GA484@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Linus Torvalds wrote:
>
> In that case, this series looks fairly ok to me. I'm still unsure
> whether it's _required_,

Indeed! It is a bit annoying, I am not sure too. This "problem" is
very, very, old. And nobody complained so far. Except, this _might_
explain the hang reported by Nikita.

OTOH. Probably set_current_blocked() makes sense anyway, it would be
nice to require that nobody can play with ->blocked directly. We can
reconsider retarget_shared_pendind() or simply kill it if it adds the
noticeable overhead in practice.

So, I'll assume we need this changes. Correctness is always good. All
further changes should be simple and straightforward, I am going to
trim CC. Except sys_rt_sigtimedwait() is nasty, we need another helper
for simplicity.

If nobody objects, I'll send at lot of other "needs set_current_blocked"
simple patches to Andrew.

Oleg.

