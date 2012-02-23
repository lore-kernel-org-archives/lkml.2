Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2BWWRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:17:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59975 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2BWWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:17:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.137.165 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223154438.GA4354@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com>
 <20120223154438.GA4354@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 14:17:03 -0800
X-Google-Sender-Auth: 0u5k3V0qkq3_WfVX6lrWRFLmMV8
Message-ID: <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
Subject: Re: [PATCH 4/4] epoll: ep_unregister_pollwait() can use the freed pwq->whead
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 7:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Or we can rely on the fact that sighand_cachep is SLAB_DESTROY_BY_RCU,
> and assume that ->whead is always rcu-protected if it can go away.
>
> In this case we don't need 3/4 (although it makes sense to add the
> fat comment), and 4/4 can be simplified, see below.

Ok.

Can you also get rid of 1/4, because quite frankly, adding that
BUG_ON() is just annoying. Either the thing gets fixed or not, but at
no point is it ok to say "ok, I'm going to fix it, but before I do
I'll just make it much worse".

Hmm?
               Linus
