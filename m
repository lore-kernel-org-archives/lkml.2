Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0HYAZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:25:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39668 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab0HYAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:25:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 09:20:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:09:25 -0700
Paul Menage <menage@google.com> wrote:

> On Fri, Aug 20, 2010 at 2:58 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > CC'ed to Paul Menage and Li Zefan.
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > When cgroup subsystem use ID (ss->use_id==1), each css's ID is assigned
> > after successful call of ->create(). css_ID is tightly coupled with
> > css struct itself but it is allocated by ->create() call, IOW,
> > per-subsystem special allocations.
> >
> > To know css_id before creation, this patch adds id_attached() callback.
> > after css_ID allocation. This will be used by memory cgroup's quick lookup
> > routine.
> >
> > Maybe you can think of other implementations as
> >        - pass ID to ->create()
> >        or
> >        - add post_create()
> >        etc...
> > But when considering dirtiness of codes, this straightforward patch seems
> > good to me. If someone wants post_create(), this patch can be replaced.
> 
> I think I'd prefer the approach where any necessary css_ids are
> allocated prior to calling any create methods (which gives the
> additional advantage of removing the need to roll back partial
> creation of a cgroup in the event of alloc_css_id() failing) and then
> passed in to the create() method. The main cgroups framework would
> still be responsible for actually filling the css->id field with the
> allocated id.
> 

Hmm, sure. I'll change the ->create() interface.  O.K. ?

Thanks,
-Kame

