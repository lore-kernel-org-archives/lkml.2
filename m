Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2BXTNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:13:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2BXTNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:13:52 -0500
Date: Fri, 24 Feb 2012 20:06:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] signalfd/epoll fixes
Message-ID: <20120224190651.GA22287@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Linus Torvalds wrote:
>
> On Thu, Feb 23, 2012 at 7:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Or we can rely on the fact that sighand_cachep is SLAB_DESTROY_BY_RCU,
> > and assume that ->whead is always rcu-protected if it can go away.
> >
> > In this case we don't need 3/4 (although it makes sense to add the
> > fat comment), and 4/4 can be simplified, see below.
>
> Ok.
>
> Can you also get rid of 1/4, because quite frankly, adding that
> BUG_ON() is just annoying. Either the thing gets fixed or not, but at
> no point is it ok to say "ok, I'm going to fix it, but before I do
> I'll just make it much worse".

OK. Please see v2.

Other changes:

	- some comments

	- now that we rely on rcu, ep_poll_callback() can do
	  remove_wait_queue() outsife of ep->lock



Davide, I see the new email, but it is too late for me to reply
today. Anyway, I think it makes sense to make the "simple" fix
before anything else. IOW, I'd suggest these changes for now in
any case (unless, of course, you see some problems).

Oleg.

