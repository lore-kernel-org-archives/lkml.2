Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1HCTmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1HCTmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:42:35 -0400
Date: Wed, 3 Aug 2011 21:39:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803193906.GA2921@redhat.com>
References: <20110803140456.GA14393@redhat.com> <20110803182417.GA2510@albatros> <20110803182826.GB2865@albatros> <20110803192138.GB31267@redhat.com> <20110803193457.GA6734@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803193457.GA6734@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Vasiliy Kulikov wrote:
>
> On Wed, Aug 03, 2011 at 21:21 +0200, Oleg Nesterov wrote:
> > > we should check .in_use once again after
> > > down_write().
> >
> > Why?
>
> https://lkml.org/lkml/2011/8/3/277
>
> "No, as I said in the comment above, other task may be holding the mutex and
> deleting the last shm segment.

This is obvious,

> "Should" == additional check might speed the things, so it worth checking.

and this is not.

I was confused, the changelog looks as if we _have to_ recheck
or something bad can happen.

But as I said, the patch looks correct anyway. I am not
sure the 2nd optimization really makes sense (this is very
unlikely case) but it doesn't hurt.

Oleg.

