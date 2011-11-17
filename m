Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1KQQHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:07:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab1KQQHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:07:33 -0500
Date: Thu, 17 Nov 2011 17:02:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111117160249.GA14002@redhat.com>
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC52FBF.1010407@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Pavel Emelyanov wrote:
>
> On 11/17/2011 07:49 PM, Oleg Nesterov wrote:
> >
> > But. Speaking of API, it differs a bit compared to the previous version...
> >
> >> The API will be used like in the code below
> >>
> >> 	/* restore new pid namespace with an init in it */
> >> 	pid = clone(CLONE_NEWPID);
> >
> > Yes, CLONE_NEWPID | CLONE_CHILD_USEPIDS is not possible.
>
> It should be.

Yes, I was wrong, sorry. I misread the ->child_reaper == NULL in 3/3.

We simply ignore child_tidptr[0] in this case. This should work.

Oleg.

