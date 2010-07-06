Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0GFKih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:38:37 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:59202 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab0GFKif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:38:35 -0400
X-AuditID: 12074422-b7b0eae000000a2e-1a-4c3307aa6065
Subject: Re: [patch 29/52] fs: icache lock i_count
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100706043439.GH11732@laptop>
Date: Tue, 6 Jul 2010 06:38:28 -0400
Cc: Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <48F48148-9909-47D0-A850-04B22403C006@mit.edu>
References: <20100624030212.676457061@suse.de> <20100624030730.245992858@suse.de> <20100630072702.GF24712@dastard> <20100630120502.GB21358@laptop> <20100702190355.2b3fe6d2.akpm@linux-foundation.org> <20100703034123.GE11732@laptop> <20100702213149.f0ca2f72.akpm@linux-foundation.org> <20100703050652.GF11732@laptop> <20100705224106.GZ24712@dastard> <20100706043439.GH11732@laptop>
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6, 2010, at 12:34 AM, Nick Piggin wrote:
> On Tue, Jul 06, 2010 at 08:41:06AM +1000, Dave Chinner wrote:
>> 
>> 
>> I don't disagree with this approach - I object to the fact that you
>> repurpose an existing lock and change it's locking rules to "rule
>> the inode". We don't have any one lock that "rules the inode",
>> anyway, so adding a new "i_list_lock" for the new VFS level locking
>> strategies makes it a lot more self-contained. Fundamentally I'm
>> less concerned about the additional memory usage than I am about
>> having landmines planted around i_lock...
> 
> If some filesystem introduces a lock ordering problem from not
> reading the newly added documentation, lockdep should catch it pretty
> quick.

I assume you mean inline documentation in the source, because I
quickly scanned the source and couldn't find any significant changes
to any files in Documentation.

It would be nice if the new state of affairs is documented in a single file,
so that people who want to understand this new locking system don't
have to go crawling through the code, or searching mailing list archives
to figure out what's going on.

A lot of the text in this mail thread, including your discussion of the new
locking hierarchy, and why things are the way they are, would be good
fodder for a new documentation file.   And if you don't want to rename
i_lock, because no better name can be found, we should at least
document that starting as of 2.6.35/36 the meaning of i_lock changed.

-- Ted

