Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2K2U71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:59:27 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52734 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2K2U7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:59:24 -0500
Date: Thu, 29 Nov 2012 12:59:20 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129205920.GL15094@google.com>
References: <20121129185720.GE15094@google.com>
 <20121129185953.GW16230@one.firstfloor.org>
 <20121129191214.GG15094@google.com>
 <20121129192003.GX16230@one.firstfloor.org>
 <20121129192925.GH15094@google.com>
 <20121129193452.GI19042@kvack.org>
 <20121129202231.GJ15094@google.com>
 <m2fw3sf8eu.fsf@firstfloor.org>
 <20121129204531.GK15094@google.com>
 <20121129205447.GY16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129205447.GY16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:54:47PM +0100, Andi Kleen wrote:
> > > The regular atomic_t is limited in ways that you are not.
> > > See my original mail.
> > 
> > I don't follow, can you explain?
> 
> For most cases the reference count is tied to some object, which are
> naturally limited by memory size or other physical resources.
> 
> But in the assymetric CPU case with your ref count no such limiter
> exists.

It's got exactly the same limit as the old code which used the atomic_t
- we're limited by the number of threads that can be issuing aio
syscalls at a time.

The assymetry you're talking about _doesn't matter_, individual cpu
counters wrapping does not affect what the counters all sum to when we
go to tear down.

A coworker at lunch actually pointed out to me that the reason this is
true is just that modular arithmatic is still associative with addition
and subtraction.
