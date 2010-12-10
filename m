Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0LJE2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:28:01 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34216 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab0LJE17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:27:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPI5AU15Lcht/2dsb2JhbACjf3m/aoVKBA
Date: Fri, 10 Dec 2010 15:27:52 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101210042752.GA3144@amd>
References: <20101209070938.GA3949@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209070938.GA3949@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 06:09:38PM +1100, Nick Piggin wrote:
> So replace it with an open-coded byte comparison. This increases code
> size by 24 bytes in the critical __d_lookup_rcu function, but the

Actually, if the loop assumes len is non zero (which is the case for
dentry compare), then the bloat is only 8 bytes, so not a problem.

Also got numbers versus vanilla kernel, out of interest.

> speedup is huge, averaging 10 runs of each:
> 
> git diff st   user   sys   elapsed  CPU
  vanilla       1.19   3.21  4.47      98.0
> before        1.15   2.57  3.82      97.1
> after         1.14   2.35  3.61      96.8
> 
> git diff mt   user   sys   elapsed  CPU
  vanilla       1.57  45.75  3.60    1312
> before        1.27   3.85  1.46     349
> after         1.26   3.54  1.43     333
> 

Single thread elapsed time improvment vanilla vs vfs 19.23%. Not quite
as big as the AMD fam10h speedup, that's probably because Westmere does
atomics so damn quickly.

Multi thread numbers are no surprise.

