Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0JERjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0JERjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:39:15 -0400
Message-ID: <4CAB628D.3030205@redhat.com>
Date: Tue, 05 Oct 2010 13:38:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
References: <1286265215-9025-1-git-send-email-walken@google.com> <1286265215-9025-3-git-send-email-walken@google.com>
In-Reply-To: <1286265215-9025-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:53 AM, Michel Lespinasse wrote:
> This change reduces mmap_sem hold times that are caused by waiting for
> disk transfers when accessing file mapped VMAs. It introduces the
> VM_FAULT_ALLOW_RETRY flag, which indicates that the call site wants
> mmap_sem to be released if blocking on a pending disk transfer.
> In that case, filemap_fault() returns the VM_FAULT_RETRY status bit
> and do_page_fault() will then re-acquire mmap_sem and retry the page fault.
> It is expected that the retry will hit the same page which will now be
> cached, and thus it will complete with a low mmap_sem hold time.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

Looks like it should be relatively easy to do something
similar in do_swap_page also.
