Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0F2Rwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:52:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab0F2Rwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100629174122.GN28364@laptop>
References: <20100624030212.676457061@suse.de>
	<20100624030725.885831564@suse.de>
	<20100629130214.GA21410@infradead.org>
	<20100629145617.GG28364@laptop>
	<AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
	<20100629174122.GN28364@laptop>
Date: Tue, 29 Jun 2010 10:52:03 -0700
Message-ID: <AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:41 AM, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Jun 29, 2010 at 10:35:47AM -0700, Linus Torvalds wrote:
>>
>> I'll apply it. We have a couple of oopses listed for the superblock
>> iterator, and I haven't heard from Al. And the patch looks obviously
>> fine, whether it's actually the cause of some of the bugs or not.
>
> OK. I only have managed to get it into an infininte loop but I think
> it would be surely possible to oops it because the next pointer can
> be uninitialised memory at that point.

Look for "2.6.35-rc3 oops trying to suspend" on lkml, for example. No
guarantee that it's the same thing, but it's "iterate_supers()"
getting an oops when it does "down_read(&sb->s_umount)". Which really
looks suspiciously like "sb" just being totally bogus, most likely
because of this same issue.

So I dunno, but I asked Al to look at it, and haven't heard back.

Regardless, I think your patch is the right thing to do (modulo any
syntactic issues - and I think your final version was the best of the
lot).

                    Linus
