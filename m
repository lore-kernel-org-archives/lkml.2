Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab1D0Qyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:54:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64793 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1D0Qyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:54:38 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
In-reply-to: <1303923000.2583.8.camel@mulgrave.site>
References: <1303920553.2583.7.camel@mulgrave.site> <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
Date: Wed, 27 Apr 2011 12:54:26 -0400
Message-Id: <1303923177-sup-2603@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DB84A4B.002C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from James Bottomley's message of 2011-04-27 12:50:00 -0400:
> On Wed, 2011-04-27 at 12:33 -0400, Chris Mason wrote:
> > Probably easier to debug with a sysrq-l and sysrq-w. 
> 
> Yes, just enabling them for the repro ... I didn't echo 1
> > /proc/sys/kernel/sysrq first time around
> 
> >  If you get stuck
> > on the filesystem, it is probably waiting on ram, which it probably
> > can't get because kswapd is spinning.  Eventually everyone backs up
> > waiting for the transaction that never ends.  If we're really lucky it
> > is just GFP_KERNEL where it should NOFS.
> > 
> > Since you're often stuck in different spots inside shrink_slab, we're
> > probably not stuck on a lock.  But, trying with lock debugging, lockdep
> > enabled and preempt on is a good idea to rule out locking mistakes.
> > 
> > Does the fedora debug kernel enable preempt?
> 
> No ... I've taken the Fedora 15 kernel config directly from their
> install CD for this (with a bit of munging to get it to work on -rc4)

Ok, I'd try turning it on so we catch the sleeping with a spinlock held
case better.

-chris
