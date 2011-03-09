Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1CIGGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:06:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56601 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1CIGGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:06:41 -0500
Date: Wed, 9 Mar 2011 06:06:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Roland McGrath <roland@redhat.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: use mm_struct to resolve gate vma's in
 __get_user_pages
Message-ID: <20110309060617.GB22723@ZenIV.linux.org.uk>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
 <1299631343-4499-2-git-send-email-wilsons@start.ca>
 <20110309141208.03F7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309141208.03F7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 02:19:30PM +0900, KOSAKI Motohiro wrote:

> Hmm..
> Is this works? In exec() case task has two mm, old and new-borned. tsk has
> no enough information to detect gate area if 64bit process exec 32bit process
> or oppsite case. On Linux, 32bit and 64bit processes have perfectly different
> process vma layout.
> 
> Am I missing something?

Patch series refered to in [0/6] ;-)  FWIW, that would probably be better
off as one mail thread - would be easier to find.

What happens is that mm_struct gets marked as 32bit/64bit at execve time
(on x86, everything else doesn't care), so this stuff becomes possible
to calculate by mm_struct alone.
