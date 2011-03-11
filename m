Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1CKQYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:24:19 -0500
Received: from www.tglx.de ([62.245.132.106]:37305 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1CKQYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:24:15 -0500
Date: Fri, 11 Mar 2011 17:23:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Alexander Shishkin <virtuoso@slind.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes.patch
 added to -mm tree
In-Reply-To: <20110311135023.GA23552@redhat.com>
Message-ID: <alpine.LFD.2.00.1103111722521.2787@localhost6.localdomain6>
References: <20110311135023.GA23552@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Oleg Nesterov wrote:

> > @@ -218,10 +266,12 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
> >  	 * it to the new values.
> >  	 */
> >  	for (;;) {
> > +		spin_lock(&notifiers_lock);
> >  		spin_lock_irq(&ctx->wqh.lock);
> > -		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> > +		if (!list_empty(&notifiers_list) || hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> >  			break;
> 
> Confused. Why do we check the global notifiers_list?
> 
> IOW. Suppose that this list is not empty and timerfd_settime() is called
> without TFD_NOTIFY_CLOCK_SET. Now we are going to reprogramm the timer
> without stopping it?
> 
> And. What if timerfd_settime(TFD_NOTIFY_CLOCK_SET, utmr => NULL) is called
> twice? timerfd_setup() blindly does list_add(), and we corrupt the list, no?

And why is this hack in -mm at all ?

Thanks,

	tglx
