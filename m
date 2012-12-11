Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2LKTAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:00:06 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47783 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab2LKTAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:00:04 -0500
Message-ID: <1355252392.2356.131.camel@falcor>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Date: Tue, 11 Dec 2012 13:59:52 -0500
In-Reply-To: <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	 <1355234914.2356.85.camel@falcor>
	 <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	 <1355249884.2356.108.camel@falcor>
	 <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121118-5806-0000-0000-00001CD90421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 13:35 -0500, Eric Paris wrote:
> On Tue, Dec 11, 2012 at 1:18 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > The appraisal policy is based on the object metadata, such as the uid,
> > so the result is static and can be cached.  The measurement policy, on
> > the other hand, is normally based on the subject (eg. who is
> > reading/executing) the file.  Knowledge of whether the file has been
> > measured is cached in the iint, but unlike the appraisal policy, not
> > whether it needs to be measured.  Having the flag on a per inode basis,
> > doesn't really help.
> 
> Can you try again?  Even I can't parse this.  Not sure what to tell
> you to try again, maybe give us a summary at a high level again and
> then why this patch is specifically necessary?

sigh. The IMA policy contains rules for the original IMA measurement,
hash auditing, and now for IMA appraisal.  These policies overlap with
each other, but are not the same.

Although the policy doesn't change, the rules can be dependent on the
calling process.  For example, the original default 'ima_tcb' policy is
based, not on the file owner, but on the uid reading/executing the file.
The 'ima_tcb' policy measures all files read/executed by root.  So we
cache whether the file has been measured, not if the file needs to be
measured, because depending on the caller, that changes.  Bottom line,
we can't say definitively whether or not a file needs to be measured for
any caller.

Dmitry's patch addresses the issue of eliminating an entire filesystem
from being appraised, measured, or audited.

I hope this clarifies the issues a bit better.

Mimi

 

