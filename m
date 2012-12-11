Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2LKSUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:20:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56648 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab2LKSUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:20:35 -0500
Message-ID: <1355249884.2356.108.camel@falcor>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Date: Tue, 11 Dec 2012 13:18:04 -0500
In-Reply-To: <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	 <1355234914.2356.85.camel@falcor>
	 <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121118-9360-0000-0000-00000DD06DA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 08:59 -0800, Linus Torvalds wrote:
> On Tue, Dec 11, 2012 at 6:08 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2012-12-11 at 14:51 +0200, Kasatkin, Dmitry wrote:
> >> >>
> >> >> Two months ago I was asking about it on mailing lists.
> >> >> Suggestion was not to use s_flags, but e.g. s_feature_flags.
> 
> Quite frankly, this seems stupid.
> 
> Without really knowing the problem space, the sane thing to do would
> seem to be inode->i_flags. At which point it's
> 
>  (a) faster to test (no need to dereference inode->i_sb)
> 
>  (b) matches what the integrity layer does with S_IMA (well, there the
> logic is reversed: S_IMA means that it has a integrity structure
> associated with it)
> 
>  (c) allows you to mark individual inodes as "no checking".

The appraisal policy is based on the object metadata, such as the uid,
so the result is static and can be cached.  The measurement policy, on
the other hand, is normally based on the subject (eg. who is
reading/executing) the file.  Knowledge of whether the file has been
measured is cached in the iint, but unlike the appraisal policy, not
whether it needs to be measured.  Having the flag on a per inode basis,
doesn't really help.

thanks,

Mimi

