Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HCTch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:32:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab1HCTcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:32:32 -0400
Date: Wed, 3 Aug 2011 21:29:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803192930.GA320@redhat.com>
References: <20110803140456.GA14393@redhat.com> <20110803182417.GA2510@albatros> <20110803182826.GB2865@albatros> <CAOLZvyFQPCsU7bnyv=iyz3FSBF72iYiLGKarvCfq6Z=2i_bOVw@mail.gmail.com> <20110803191639.GA6306@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110803191639.GA6306@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Vasiliy Kulikov wrote:
>
> On Wed, Aug 03, 2011 at 21:08 +0200, Manuel Lauss wrote:
> > > +
> > >        /* Destroy all already created segments, but not mapped yet */
> > >        down_write(&shm_ids(ns).rw_mutex);
> > >        if (shm_ids(ns).in_use)
> >
> > This check here is now unnecessary, yes?
>
> No, as I said in the comment above, other task may be holding the mutex and
> deleting the last shm segment.  So, current task will see in_use == 1
> before down_write(), but == 0 after it.

And? Why we can not do idr_for_each() in this (unikely) case?

> > And this also fixes the oops.
>
> Yes, but it only hides the real problem - tasks' dependency on initialized
> init_*_ns.

This is true, but your patch has the same dependency, but pretends
it doesn't ;) and it complicates the code.

Oleg.

