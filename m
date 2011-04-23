Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1DWSVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1DWSVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:21:22 -0400
Date: Sat, 23 Apr 2011 20:20:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/7] signal: cleanup sys_rt_sigprocmask()
Message-ID: <20110423182031.GB1472@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134700.GI15951@redhat.com> <20110422153027.12d16b7e@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422153027.12d16b7e@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Matt Fleming wrote:
>
> On Mon, 18 Apr 2011 15:47:00 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > -	/* XXX: Don't preclude handling different sized sigset_t's.  */
> > +	/* Don't preclude handling different sized sigset_t's. */
> >  	if (sigsetsize != sizeof(sigset_t))
> > -		goto out;
> > +		return -EINVAL;
>
> I don't think it's correct to remove the 'XXX'. The comment is
> currently saying "We don't handle different sized sigset_t's, but we
> should", whereas removing the 'XXX' says to me that we _DO_ handle
> different sized sigset_t's.

Hmm. I think you are right. I simply didn't know what "preclude" means
and thus misunderstood the comment.

> If you don't like the 'XXX' you could
> always swap it for a 'TODO'?

I think we should just remove this comment. It is confusing. This check
is trivial and does not need any explanation. The comment (and the code)
is very old, it predates the git history. I do not think this API will be
changed, unlikely we need to handle the different sized sigset_t's.

What do you think?

> Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks!

Oleg.

