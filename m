Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3ACFxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:53:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3ACFxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:53:17 -0500
Message-ID: <50E51C0B.1040205@redhat.com>
Date: Thu, 03 Jan 2013 00:50:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] mm: directly use __mlock_vma_pages_range() in find_extend_vma()
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-9-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-9-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> In find_extend_vma(), we don't need mlock_vma_pages_range() to verify the
> vma type - we know we're working with a stack. So, we can call directly
> into __mlock_vma_pages_range(), and remove the last make_pages_present()
> call site.
>
> Note that we don't use mm_populate() here, so we can't release the mmap_sem
> while allocating new stack pages. This is deemed acceptable, because the
> stack vmas grow by a bounded number of pages at a time, and these are
> anon pages so we don't have to read from disk to populate them.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
