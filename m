Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0LCWk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:40:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33326 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0LCWk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:40:57 -0500
Subject: Re: [PATCH 6/6] x86 rwsem: more precise rwsem_is_contended()
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1291335412-16231-7-git-send-email-walken@google.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	 <1291335412-16231-7-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 23:41:10 +0100
Message-ID: <1291416070.2032.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 16:16 -0800, Michel Lespinasse wrote:
> We would like rwsem_is_contended() to return true only once a contending
> writer has had a chance to insert itself onto the rwsem wait queue.
> To that end, we need to differenciate between active and queued writers.

So you're only considering writer-writer contention? Not writer-reader
and reader-writer contention?

I'd argue rwsem_is_contended() should return true if there is _any_
blocked task, be it a read or a writer.

If you want something else call it something else, like
rwsem_is_write_contended() (there's a pending writer), or
rwsem_is_read_contended() (there's a pending reader).


