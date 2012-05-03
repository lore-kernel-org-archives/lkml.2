Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2ECHOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:14:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57013 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2ECHOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <1336029206.13013.11.camel@sauron.fi.intel.com>
References: <1335932890-25294-1-git-send-email-minchan@kernel.org>
	<20120502124610.175e099c.akpm@linux-foundation.org>
	<4FA1D93C.9000306@kernel.org>
	<Pine.LNX.4.64.1205022241560.18540@cobra.newdream.net>
	<CAPa8GCCzyB7iSX+wTzsqfe7GHvfWT2wT4aQgK30ycRnkc_BNAQ@mail.gmail.com>
	<1336029206.13013.11.camel@sauron.fi.intel.com>
Date: Thu, 3 May 2012 17:14:16 +1000
Message-ID: <CAPa8GCDzgbQ5T-4eR942KswxXwRE69rwV2CKgho6LOV-us5RDw@mail.gmail.com>
Subject: Re: [PATCH] vmalloc: add warning in __vmalloc
From: Nick Piggin <npiggin@gmail.com>
To: dedekind1@gmail.com
Cc: Sage Weil <sage@newdream.net>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com,
        rientjes@google.com, Neil Brown <neilb@suse.de>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2012 17:13, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Thu, 2012-05-03 at 16:30 +1000, Nick Piggin wrote:
>> Note that in writeback paths, a "good citizen" filesystem should not require
>> any allocations, or at least it should be able to tolerate allocation failures.
>> So fixing that would be a good idea anyway.
>
> This is a good point, but UBIFS kmallocs(GFP_NOFS) when doing I/O
> because it needs to compress/decompress. But I agree that if kmalloc
> fails, we should have a fall-back reserve buffer protected by a mutex
> for memory pressure situations.

AKA, a mempool :)
