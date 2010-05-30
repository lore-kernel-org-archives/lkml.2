Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0E3Xtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 19:49:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37947 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0E3Xtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 19:49:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 May 2010 08:45:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Greg Thelen <gthelen@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
Message-Id: <20100531084529.2b1f0d25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com>
References: <1275059781-9831-1-git-send-email-gthelen@google.com>
	<AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 15:25:08 -0700
Paul Menage <menage@google.com> wrote:

> On Fri, May 28, 2010 at 8:16 AM, Greg Thelen <gthelen@google.com> wrote:
> >
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
> Good catch, thanks.
> 
Nice Catch.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But, who breaks this ? Do we need backport this against old kernels ?

2.6.33 has this.
> 3959         depth = css_depth(parent_css) + 1;
> 3960         parent_id = parent_css->id;
> 3961 
> 3962         child_id = get_new_cssid(ss, depth);


Thanks,
-Kame


> Paul
> 
> > ---
> >  kernel/cgroup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 422cb19..3ac6f5b 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -4598,7 +4598,7 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
> >        parent_css = parent->subsys[subsys_id];
> >        child_css = child->subsys[subsys_id];
> >        parent_id = parent_css->id;
> > -       depth = parent_id->depth;
> > +       depth = parent_id->depth + 1;
> >
> >        child_id = get_new_cssid(ss, depth);
> >        if (IS_ERR(child_id))
> > --
> > 1.7.0.1
> >
> >
> 

