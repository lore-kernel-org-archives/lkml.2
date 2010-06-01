Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0FAPsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:48:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab0FAPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:48:17 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lee@firstfloor.org,
       Schermerh@firstfloor.org
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
From: Andi Kleen <andi@firstfloor.org>
References: <20100601073343.GQ9453@laptop>
Date: Tue, 01 Jun 2010 17:48:10 +0200
In-Reply-To: <20100601073343.GQ9453@laptop> (Nick Piggin's message of "Tue\, 1 Jun 2010 17\:33\:43 +1000")
Message-ID: <87wruiycsl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> This isn't really a new problem, and I don't know how important it is,
> but I recently came across it again when doing some aim7 testing with
> huge numbers of tasks.

Seems reasonable. Of course you need to at least 
save/restore the old CPU policy, and use a subset of it.

Another approach would be to migrate this on touch, but that is probably
slightly more difficult. The advantage would be that on multiple
migrations it would follow. And it would be a bit slower for
the initial case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
