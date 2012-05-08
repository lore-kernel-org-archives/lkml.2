Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2EHNXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:23:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34233 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2EHNXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:23:19 -0400
Message-ID: <1336483374.16236.38.camel@twins>
Subject: Re: [PATCH] UBI: Replace yield() with cond_resched()
From: Peter Zijlstra <peterz@infradead.org>
To: dedekind1@gmail.com
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 15:22:54 +0200
In-Reply-To: <1336483427.23308.37.camel@sauron.fi.intel.com>
References: <1336465602-12627-1-git-send-email-richard@nod.at>
	 <1336467723.23308.23.camel@sauron.fi.intel.com> <4FA8FC83.7000503@nod.at>
	 <1336483427.23308.37.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 16:23 +0300, Artem Bityutskiy wrote:
> On Tue, 2012-05-08 at 12:59 +0200, Richard Weinberger wrote:
> > > The purpose was different. If we have I/O error, we hope it is a
> > > transient failure. E.g., the HW is temporary unavailable because of an
> > > internal issue. And with yield() we hoped to schedule away for longer
> > > time than usual and let other processes which may affect that HW go
> > > forward and do something.
> > 
> > Okay, yield() is clearly the wrong choice here.
> > cond_resched() is better.
> 
> I do not think it is better. Yes, for I/O I'd suggest
> msleep_interruptible(200) instead.

At least document the intent of that random sleep. Otherwise we'll be
having this same discussion again in a few years or so ;-)
