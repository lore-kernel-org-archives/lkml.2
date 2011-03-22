Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CVFRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:17:21 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:43752 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1CVFRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:17:20 -0400
Date: Tue, 22 Mar 2011 01:15:53 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8 4/3] cgroups: use flex_array in attach_proc
Message-ID: <20110322051553.GB11447@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
 <20110216192200.GA11980@ghc17.ghc.andrew.cmu.edu>
 <AANLkTinKTqBnjLKkv93UxyWoPL-2vyXP=LUvRz8JTC2K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinKTqBnjLKkv93UxyWoPL-2vyXP=LUvRz8JTC2K@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1200_1299 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, ECARD_KNOWN_DOMAINS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 09:48:09AM -0800, Paul Menage wrote:
> On Wed, Feb 16, 2011 at 11:22 AM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> > Convert cgroup_attach_proc to use flex_array.
> >
> > From: Ben Blum <bblum@andrew.cmu.edu>
> >
> > The cgroup_attach_proc implementation requires a pre-allocated array to store
> > task pointers to atomically move a thread-group, but asking for a monolithic
> > array with kmalloc() may be unreliable for very large groups. Using flex_array
> > provides the same functionality with less risk of failure.
> >
> > This is a post-patch for cgroup-procs-write.patch.
> >
> > Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> Looks fine from a correctness point of view, but I'd be inclined to
> reduce the verbosity - rather than
> 
> tsk = flex_array_get_ptr(group, i);
> BUG_ON(tsk == NULL);
> retval = ss->can_attach_task(cgrp, tsk);
> 
> I'd just have
> 
> retval = ss->can_attach_task(cgrp, flex_array_get_ptr(group, i));
> 
> I don't think you need to be so defensive about flex_array's behaviour.
> 
> Paul
> 

hmm, in this case that change would make it cross 80 columns (and I
liked consistency). ;)

I've removed the BUG_ONs, though.

-- Ben
