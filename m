Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1LUQpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:45:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36530 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1LUQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:45:05 -0500
Date: Wed, 21 Dec 2011 08:44:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
 and memory barrier usage
Message-ID: <20111221164459.GA9213@google.com>
References: <20111220221818.GJ10752@google.com>
 <20111221145556.GA25657@redhat.com>
 <20111221163715.GS10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221163715.GS10752@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooh, missed something.

On Wed, Dec 21, 2011 at 08:37:15AM -0800, Tejun Heo wrote:
> Yes, that's another way to put it.  It's much easier to understand if
> you draw a graph with time on x axis and curr_nr on y and mark which
> curr_nr values are guaranteed to be visible to whom.  If at any point
> of time, a freeing task sees curr_nr == min_nr, it's guaranteed that
> either it's staying that way or, if not, someone else will see the
> newly decremented value.

And there will be enough "someone elses" to restore curr_nr == min_nr.

Thanks.

-- 
tejun
