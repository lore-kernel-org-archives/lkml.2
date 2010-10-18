Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0JRQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:16:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35492 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0JRQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:16:57 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	<1286515292-15882-12-git-send-email-david@fromorbit.com>
	<20101008185409.GA29251@infradead.org> <20101016075703.GO19147@amd>
	<20101016161642.GC16861@infradead.org> <20101016171213.GC3240@amd>
	<20101017004610.GB29677@dastard> <20101017022539.GA3317@amd>
Date: Mon, 18 Oct 2010 18:16:50 +0200
In-Reply-To: <20101017022539.GA3317@amd> (Nick Piggin's message of "Sun, 17
	Oct 2010 13:25:39 +1100")
Message-ID: <87iq0za32l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@kernel.dk> writes:
>
>> Providing
>> locking wrappers that are exactly what users need so they don't have
>> to care about it is, IMO, the right thing to do.
>
> Hiding the type of lock, and hiding the fact that it sets the low bit?
> I don't agree. We don't have synchronization in our data structures,
> where possible, because it is just restrictive or goes wrong when people
> don't think enough about the locking.

I fully agree. The old skb lists in networking made this mistake
long ago and it was a big problem, until people essentially stopped 
using it (always using __ variants) and it was eventually removed.

Magic locking in data structures is usually a bad idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
