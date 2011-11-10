Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab1KJOct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:32:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1KJOcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:32:48 -0500
Date: Thu, 10 Nov 2011 08:32:43 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        serge@hallyn.com, oleg@redhat.com
Subject: Re: [MAILER-DAEMON@mail.linuxfoundation.org: Undelivered Mail
 Returned to Sender]
Message-ID: <20111110143243.GB7727@sergelap>
References: <20111109190829.GA26067@sergelap>
 <CAKiorj6LYYC+rZG5CRKahYuzyXdnGpQJgd4QQUQ9YhHpTV7s=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiorj6LYYC+rZG5CRKahYuzyXdnGpQJgd4QQUQ9YhHpTV7s=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> > Would you prefer something like:
> >
> > +#ifdef CONFIG_USER_NS
> > +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
> > +{
> > +       if (current_user_ns() == task_cred_xxx(t, user_ns))
> > +               return;
> > +
> > +       if (SI_FROMKERNEL(info))
> > +               return;
> > +
> > +       info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> > +                                       current_cred(), info->si_uid);
> > +}
> > +#else
> > +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
> > +{
> > +               return;
> > +}
> > +#endif
> >
> > ?  It's less sneaky at least.
> 
> Very much.  The current version looks like a bug.

Thanks, I'll switch to that and hopefully resend the set soon.

-serge
