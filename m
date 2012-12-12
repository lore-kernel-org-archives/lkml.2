Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2LLGBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:01:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62796 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2LLGBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:01:09 -0500
MIME-Version: 1.0
In-Reply-To: <50BCA2E4.8050600@suse.cz>
References: <50B52E17.8020205@suse.cz>
	<1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
	<50BCA2E4.8050600@suse.cz>
Date: Wed, 12 Dec 2012 13:36:36 +0800
Message-ID: <CAA_GA1dZm7LYe46vdurFf8avbSViPeT2jC_L0A3Oejg97RsmBA@mail.gmail.com>
Subject: Re: [PATCH 0/2] kernel BUG at mm/huge_memory.c:212!
From: Bob Liu <lliubbo@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:02 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 11/30/2012 04:03 PM, Kirill A. Shutemov wrote:
>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>
>> Hi Jiri,
>>
>> Sorry for late answer. It took time to reproduce and debug the issue.
>>
>> Could you test two patches below by thread. I expect it to fix both
>> issues: put_huge_zero_page() and Bad rss-counter state.
>
> Hi, yes, since applying the patches on the last Thu, it didn't recur.
>
>> Kirill A. Shutemov (2):
>>   thp: fix anononymous page accounting in fallback path for COW of HZP
>>   thp: avoid race on multiple parallel page faults to the same page
>>
>>  mm/huge_memory.c | 30 +++++++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 5 deletions(-)
>

I still saw this bug on 3.7.0-rc8, but it's hard to reproduce it.
It appears only once.

-- 
Regards,
--Bob
