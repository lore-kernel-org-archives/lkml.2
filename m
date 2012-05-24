Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2EXTO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:14:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37895 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab2EXTO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:14:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120524120727.6eab2f97.akpm@linux-foundation.org>
References: <1337884054.3292.22.camel@lappy> <20120524120727.6eab2f97.akpm@linux-foundation.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 24 May 2012 21:14:05 +0200
Message-ID: <CA+1xoqcbZWLpvHkOsZY7rijsaryFDvh=pqq=QyDDgo_NfPyCpA@mail.gmail.com>
Subject: Re: mm: kernel BUG at mm/memory.c:1230
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro <viro@zeniv.linux.org.uk>, oleg@redhat.com,
        "a.p.zijlstra" <a.p.zijlstra@chello.nl>, mingo <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 9:07 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 24 May 2012 20:27:34 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
>
>> Hi all,
>>
>> During fuzzing with trinity inside a KVM tools guest, using latest linux-next, I've stumbled on the following:
>>
>> [ 2043.098949] ------------[ cut here ]------------
>> [ 2043.099014] kernel BUG at mm/memory.c:1230!
>
> That's
>
>        VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
>
> in zap_pmd_range()?

Yup.

> The assertion was added in Jan 2011 by 14d1a55cd26f1860 ("thp: add
> debug checks for mapcount related invariants").  AFAICT it's just wrong
> on the exit path.  Unclear why it's triggering now...

I'm not sure if that's indeed the issue or not, but note that this is
the first time I've managed to trigger that with the fuzzer, and it's
not that easy to reproduce. Which is a bit odd for code that was there
for 4 months...
