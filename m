Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2ECGa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:30:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61245 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2ECGa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205022241560.18540@cobra.newdream.net>
References: <1335932890-25294-1-git-send-email-minchan@kernel.org>
	<20120502124610.175e099c.akpm@linux-foundation.org>
	<4FA1D93C.9000306@kernel.org>
	<Pine.LNX.4.64.1205022241560.18540@cobra.newdream.net>
Date: Thu, 3 May 2012 16:30:56 +1000
Message-ID: <CAPa8GCCzyB7iSX+wTzsqfe7GHvfWT2wT4aQgK30ycRnkc_BNAQ@mail.gmail.com>
Subject: Re: [PATCH] vmalloc: add warning in __vmalloc
From: Nick Piggin <npiggin@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com,
        rientjes@google.com, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2012 15:46, Sage Weil <sage@newdream.net> wrote:
> On Thu, 3 May 2012, Minchan Kim wrote:
>> On 05/03/2012 04:46 AM, Andrew Morton wrote:
>> > Well.  What are we actually doing here?  Causing the kernel to spew a
>> > warning due to known-buggy callsites, so that users will report the
>> > warnings, eventually goading maintainers into fixing their stuff.
>> >
>> > This isn't very efficient :(
>>
>>
>> Yes. I hope maintainers fix it before merging this.
>>
>> >
>> > It would be better to fix that stuff first, then add the warning to
>> > prevent reoccurrences.  Yes, maintainers are very naughty and probably
>> > do need cattle prods^W^W warnings to motivate them to fix stuff, but we
>> > should first make an effort to get these things fixed without
>> > irritating and alarming our users.
>> >
>> > Where are these offending callsites?
>
> Okay, maybe this is a stupid question, but: if an fs can't call vmalloc
> with GFP_NOFS without risking deadlock, calling with GFP_KERNEL instead
> doesn't fix anything (besides being more honest).  This really means that
> vmalloc is effectively off-limits for file systems in any
> writeback-related path, right?

Anywhere it cannot reenter the filesystem, yes. GFP_NOFS is effectively
GFP_KERNEL when calling vmalloc.

Note that in writeback paths, a "good citizen" filesystem should not require
any allocations, or at least it should be able to tolerate allocation failures.
So fixing that would be a good idea anyway.
