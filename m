Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2EKIie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:38:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42499 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2EKIi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:38:26 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-53-4faccfffd675
Message-ID: <4FACD00D.4060003@kernel.org>
Date: Fri, 11 May 2012 17:38:37 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils> <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com>
In-Reply-To: <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:30 PM, Sasha Levin wrote:

> On Fri, May 11, 2012 at 10:00 AM, Hugh Dickins <hughd@google.com> wrote:
>> Commit 93278814d359 "mm: fix division by 0 in percpu_pagelist_fraction()"
>> mistakenly initialized percpu_pagelist_fraction to the sysctl's minimum 8,
>> which leaves 1/8th of memory on percpu lists (on each cpu??); but most of
>> us expect it to be left unset at 0 (and it's not then used as a divisor).
> 
> I'm a bit confused about this, does it mean that once you set
> percpu_pagelist_fraction to a value above the minimum, you can no
> longer set it back to being 0?


Unfortunately, Yes. :(
It's rather awkward and need fix.


-- 
Kind regards,
Minchan Kim
