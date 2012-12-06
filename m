Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946734Ab2LFSlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:41:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35280 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946405Ab2LFSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:41:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121206183259.GA591@polaris.bitmath.org>
References: <20121206091744.GA1397@polaris.bitmath.org> <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de> <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
 <20121206175451.GC17258@suse.de> <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
 <20121206183259.GA591@polaris.bitmath.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Dec 2012 10:41:14 -0800
X-Google-Sender-Auth: p3Jpp9v6ClWtejObkzHRZWLOgzA
Message-ID: <CA+55aFzievpA_b5p-bXwW11a89eC-ucpzKUuSqb2PNQOLrqaPg@mail.gmail.com>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 10:32 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>> Henrik, does that - corrected - patch (*instead* of the previous one,
>> not in addition to) also fix your issue?
>
> Yes - I can no longer trigger the failpath, so it seems to work. Mel,
> enjoy the rest of the talk. ;-)
>
> Generally, I am a bit surprised that noone hit this before, given that
> it was quite easy to trigger. I will check 3.6 as well.

Actually, looking at it some more, I think that two-liner patch had
*ANOTHER* bug.

Because the other line seems buggy as well.

Instead of

        end_pfn = ALIGN(pfn + pageblock_nr_pages, pageblock_nr_pages);

I think it should be

        end_pfn = ALIGN(pfn+1, pageblock_nr_pages);

instead. ALIGN() already aligns upwards (but the "+1" is needed in
case pfn is already at a pageblock_nr_pages boundary, at which point
ALIGN() would have just returned that same boundary.

Hmm? Mel, please confirm. And Henrik, it might be good to test that
doubly-fixed patch. Because reading the patch and trying to fix bugs
in it that way is *not* the same as actually verifying it ;)

                 Linus
