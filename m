Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3ACAJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:09:07 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:47840 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3ACAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <1357145418.5429.17.camel@mesosphere.localdomain>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
Date: Wed, 2 Jan 2013 16:09:04 -0800
Message-ID: <CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
From: Michel Lespinasse <walken@google.com>
To: Roman Dubtsov <dubtsov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 8:50 AM, Roman Dubtsov <dubtsov@gmail.com> wrote:
> Concurrent mmap() calls from the same process are serialized via downing
> mm->mmap_sem for write. This means that operations like populating the
> pages which do not alter vmas are also performed serially. Anecdotal
> data from two machines I have access to is that populating pages by
> touching them in a loop outside of mmap() improves performance of the
> synthetic micro-benchmark by ~40% in the worst case. A crude patch that
> modifies vm_mmap_pgoff() to call make_pages_present() outside of
> do_mmap_pgoff() after upping the semaphore when MAP_POPULATE is present
> brings identical performance improvement.
>
> Is there an interest in fixing this or concurrent mmaps() from the same
> process are too much of a corner case to worry about it?

Funny this comes up again. I actually have a patch series that is
supposed to do that:
[PATCH 0/9] Avoid populating unbounded num of ptes with mmap_sem held

However, the patches are still pending, didn't get much review
(probably not enough for Andrew to take them at this point), and I
think everyone forgot about them during the winter break.

Care to have a look at that thread and see if it works for you ?

(caveat: you will possibly also need "[PATCH 10/9] mm: make
do_mmap_pgoff return populate as a size in bytes, not as a bool" to
make the series actually work for you)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
