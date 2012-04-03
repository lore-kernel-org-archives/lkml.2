Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2DCIMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:12:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55834 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2DCIMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:12:52 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/6] vfs: reorganize do_lookup
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
	<1332759264-23533-6-git-send-email-miklos@szeredi.hu>
	<20120330190526.GA29050@ZenIV.linux.org.uk>
Date: Tue, 03 Apr 2012 10:13:18 +0200
In-Reply-To: <20120330190526.GA29050@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 30 Mar 2012 20:05:26 +0100")
Message-ID: <87hax1s069.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Mar 26, 2012 at 12:54:23PM +0200, Miklos Szeredi wrote:
>> This also eliminates the weird retry loop, that could, in theory, retry the
>> cached lookup any number of times (very unlikely scenario: needs two parallel
>> do_lookups and d_revalidate always returning zero).
>
> That really needs to be carved into much smaller pieces - the sucker is
> convoluted as hell and there's a lot of codepaths in there with nearly
> zero test coverage.  I've split it up into provably equivalent
> transformations, leading more or less to the state where yours ends up.
> I _think_ I've reconstructed the sequence of changes more or less
> close to what you were doing there, but the next time you have to do
> something of that kind, do not collapse that into a single patch.  It's
> really easier to review step by step...

Okay, but actually what I was doing there is looking at what the code
actually does and realizing that it's equivalent to __lookup_hash(), so
for me it was a single (albeit complex) single step.

But I'll try to keep reviewability in mind.

The do_last() reorganization in the atomic-open series needs to be split
up, I realize.  Do you have any other high level comments about that
series?

Thanks,
Miklos
