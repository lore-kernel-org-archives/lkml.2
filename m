Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0DMUDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab0DMUDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:03:15 -0400
Date: Tue, 13 Apr 2010 22:00:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Message-ID: <20100413200034.GA20744@redhat.com>
References: <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com> <20100323105707.GA8634@redhat.com> <20100409195936.44663BD18@magilla.sf.frob.com> <20100412195042.GA14108@redhat.com> <20100413063013.A0759B06B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413063013.A0759B06B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. Andrew, please drop

	proc-make-collect_sigign_sigcatch-rcu-safe.patch
	proc-make-task_sig-lockless.patch

On 04/12, Roland McGrath wrote:
>
> > Yes, /proc/pid/status can report the intermediate state, I even sent
> > the updated changelog to document this.
> >
> > But if you are not sure this is OK, I am worried. Do you think we should
> > drop this patch? If yes, I won't argue.
>
> I'm not dead-set against it, but I am hesitant.  My inclination is not to
> remove any previous userland atomicity guarantees with regard to observable
> signal state in any form.

OK. Not that I really understand why do we need atomicity, but OK.

I was going to remove ->siglock from /fs/proc/ completely (except
do_io_accounting), but given that nobody replied to do_task_stat patches
this will not happen soon.

> At least, don't do that in part of a whole
> cleanup flurry where it is intermixed with lots of changes that really are
> pure cleanup with absolutely no userland-observable change.

OK. Anyway, these changes are simple, we can reconsider them later.

Oleg.

