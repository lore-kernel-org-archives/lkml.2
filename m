Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1G1PBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab1G1PBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:01:13 -0400
Date: Thu, 28 Jul 2011 16:58:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110728145802.GA11329@redhat.com>
References: <20110727163159.GA23785@redhat.com> <CA+55aFy83CAZ+AVZNtYZc=NnOzaxsQxksuspqBHGVwLx4hvMCg@mail.gmail.com> <20110728135958.GA9069@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728135958.GA9069@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Oleg Nesterov wrote:
>
> On 07/27, Linus Torvalds wrote:
> >
> > I *suspect* that the killable() thing could be done more nicely by
> > moving the vfork_completion into the parent instead, and maybe the
> > vfork cleanup could just use
> > "complete(&task->parent->vfork_completion);" instead
>
> I thought about moving the "vfork_done" thing (in some form) from
> child to parent. So far I do not see a clean solution.

Just in case...

We can also do

	- struct completion *vfork_done;
	+ struct completion vfork_done;

in struct task_struct. This can really simplify these changes.
But we still need to get/put the child, and this bloats task_struct.

Oleg.

