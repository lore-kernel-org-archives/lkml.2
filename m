Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2GKPat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:30:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39156 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755359Ab2GKPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:30:48 -0400
Message-ID: <1342020647.13724.71.camel@joe2Laptop>
Subject: Re: pr_cat() + CATSTR(name, size)?
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 08:30:47 -0700
In-Reply-To: <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
References: <1342002808.810.12.camel@mop>
	 <1342018897.13724.61.camel@joe2Laptop>
	 <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:14 +0200, Kay Sievers wrote:
> On Wed, Jul 11, 2012 at 5:01 PM, Joe Perches <joe@perches.com> wrote:
[]
> There are _many_ cases the console lock is held, and we don't print
> stuff immediately out to the console, and we never ensured that in the
> past. There was never a guarantee that stuff ended up on the console,
> kmsg was always and needs to be a store+forward model.

I'm less concerned with kmsg than you.
I think it's more a nicety than anything.

> > It would require all sites with continuation lines
> > be modified.  Because it requires in-situ code
> > modifications, I'd prefer a cookie based approach.
> 
> Well, it would be mostly for the dev_printk() stuff, which should
> ideally never be merged with stuff that could go wrong.

Perhaps that's ideal, but not practical.
printk continuations are more prevalent.

> > I think it's more flexible, allows the cookie to be
> > passed into extending functions and doesn't demand
> > (much) extra stack.
> >
> > Something like:
> > https://lkml.org/lkml/2012/4/3/231
> > https://lkml.org/lkml/2011/11/14/349
> 
> Hmm, how do we manage memory allocations here? We can get around that
> somehow? It's something the common printk() must really avoid.

Well, I think the malloc costs are pretty low
and could devolve pretty easily when OOM.

cookie=NULL, directly emit.

Anyway, interesting idea, keep at it, see what
comes out of it.

cheers, Joe

