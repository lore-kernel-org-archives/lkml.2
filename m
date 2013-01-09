Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3AICjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:39:00 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44739 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AICi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <1357697739.4838.30.camel@pasglop>
References: <1357694895-520-1-git-send-email-walken@google.com>
	<1357694895-520-8-git-send-email-walken@google.com>
	<1357697739.4838.30.camel@pasglop>
Date: Tue, 8 Jan 2013 18:38:56 -0800
Message-ID: <CANN689EJV_7Q7J4j1ttDxZuqbwD53PAuCHb5DhiE-AVbmNSR7Q@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm: use vm_unmapped_area() on powerpc architecture
From: Michel Lespinasse <walken@google.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rik van Riel <riel@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 6:15 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2013-01-08 at 17:28 -0800, Michel Lespinasse wrote:
>> Update the powerpc slice_get_unmapped_area function to make use of
>> vm_unmapped_area() instead of implementing a brute force search.
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>>
>> ---
>>  arch/powerpc/mm/slice.c |  128 +++++++++++++++++++++++++++++-----------------
>>  1 files changed, 81 insertions(+), 47 deletions(-)
>
> That doesn't look good ... the resulting code is longer than the
> original, which makes me wonder how it is an improvement...

Well no fair, the previous patch (for powerpc as well) has 22
insertions and 93 deletions :)

The benefit is that the new code has lower algorithmic complexity, it
replaces a per-vma loop with O(N) complexity with an outer loop that
finds contiguous slice blocks and passes them to vm_unmapped_area()
which is only O(log N) complexity. So the new code will be faster for
workloads which use lots of vmas.

That said, I do agree that the code that looks for contiguous
available slices looks kinda ugly - just not sure how to make it look
nicer though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
