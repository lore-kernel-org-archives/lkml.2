Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0GARgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:36:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55271 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0GARgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:36:47 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
References: <20100624030212.676457061@suse.de>
	<20100630113054.GL24712@dastard> <20100630124049.GH21358@laptop>
	<20100701035657.GU24712@dastard>
Date: Thu, 01 Jul 2010 19:36:45 +0200
In-Reply-To: <20100701035657.GU24712@dastard> (Dave Chinner's message of "Thu,
	1 Jul 2010 13:56:57 +1000")
Message-ID: <87lj9vyuhe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
>
> I'm not denying it that we need to do work here - I'm questioning
> the "change everything at once" approach this patch set takes.
> You've started from the assumption that everything the dcache_lock
> and inode_lock protect are a problem and goes from there.

Global code locks in a core subsystem are definitely a problem.

In many ways they're as bad a a BKL. There will be always
workloads where they hurt. They are bad coding style.
They just have to go.

I don't understand how anyone can even defend them.

Especially bad are code locks that protect lots of different
things. Those are not only bad for scalability, but also 
bad for maintainability, because few people can really
understand them even. With smaller well defined locks
that's usually easier.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
