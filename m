Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0DLTwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0DLTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:52:35 -0400
Date: Mon, 12 Apr 2010 21:50:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Message-ID: <20100412195042.GA14108@redhat.com>
References: <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com> <20100323105707.GA8634@redhat.com> <20100409195936.44663BD18@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409195936.44663BD18@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Roland McGrath wrote:
>
> > Yes. From the changelog:
> >
> > 	Of course, this means we read pending/blocked/etc nonatomically,
> > 	but I hope this is OK for fs/proc.
> >
> > But I don't think the returned data could be "really" inconsistent
> > from the /bin/ps pov. Yes, it is possible that, say, some signal is
> > seen as both pending and ignored without ->siglock. Or we can report
> > user->sigpending != 0 while pending/shpending are empty.
> >
> > But this looks harmless to me. We never guaranteed /proc/pid/status
> > can't report the "intermediate" state, and I don't think we can
> > confuse the user-space.
> >
> > Do you agree? Or do you think this can make problems ?
>
> I'm not so sure.  Operations like sigprocmask and sigaction really have
> always been entirely atomic from the userland perspective before.  Now it
> becomes possible to read from /proc e.g. a blocked set that never existed
> as such (one word updated by sigprocmask but not yet the next word).

Yes, /proc/pid/status can report the intermediate state, I even sent
the updated changelog to document this.

But if you are not sure this is OK, I am worried. Do you think we should
drop this patch? If yes, I won't argue.

Oleg.

