Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347Ab1EAUJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1EAUJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:09:16 -0400
Date: Sun, 1 May 2011 22:07:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] signal: sys_sigprocmask() needs
	retarget_shared_pending()
Message-ID: <20110501200738.GA13831@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426195002.GF8520@redhat.com> <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Linus Torvalds wrote:
>
> > +               sigemptyset(&new_full_set);
> > +               if (how == SIG_SETMASK)
> > +                       new_full_set = current->blocked;
> > +               new_full_set.sig[0] = new_set;
>
> Ugh. This is just ugly.

OK, please find v2. It doesn't use sigprocmask() helper().

Hopefully this is the last "nontrivial" conversion, everything else
looks simple.

Oleg.

