Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1HCTlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:41:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45783 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1HCTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:41:26 -0400
Date: Wed, 3 Aug 2011 23:41:21 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803194121.GA6960@albatros>
References: <20110803140456.GA14393@redhat.com>
 <20110803182417.GA2510@albatros>
 <20110803182826.GB2865@albatros>
 <CAOLZvyFQPCsU7bnyv=iyz3FSBF72iYiLGKarvCfq6Z=2i_bOVw@mail.gmail.com>
 <20110803191639.GA6306@albatros>
 <20110803192930.GA320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110803192930.GA320@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 21:29 +0200, Oleg Nesterov wrote:
> On 08/03, Vasiliy Kulikov wrote:
> >
> > On Wed, Aug 03, 2011 at 21:08 +0200, Manuel Lauss wrote:
> > > > +
> > > >        /* Destroy all already created segments, but not mapped yet */
> > > >        down_write(&shm_ids(ns).rw_mutex);
> > > >        if (shm_ids(ns).in_use)
> > >
> > > This check here is now unnecessary, yes?
> >
> > No, as I said in the comment above, other task may be holding the mutex and
> > deleting the last shm segment.  So, current task will see in_use == 1
> > before down_write(), but == 0 after it.
> 
> And? Why we can not do idr_for_each() in this (unikely) case?

Because it's pointless.  idr_for_each() would not find any used segment.

> > > And this also fixes the oops.
> >
> > Yes, but it only hides the real problem - tasks' dependency on initialized
> > init_*_ns.
> 
> This is true, but your patch has the same dependency, but pretends
> it doesn't ;) and it complicates the code.

I didn't say that .in_use check fixes the oops.  The description says
nothing about it.  It does an optimization, which is said in the
description.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
