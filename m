Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1KUXKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:10:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40891 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1KUXKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:10:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDP_z68Ewvw_O_dMxOnE0=weXqt+1FQy85_n76HAEdFHg@mail.gmail.com>
References: <CAJd=RBDP_z68Ewvw_O_dMxOnE0=weXqt+1FQy85_n76HAEdFHg@mail.gmail.com>
Date: Mon, 21 Nov 2011 15:10:39 -0800
Message-ID: <CANN689EDDy9PTSvt10Gk3jiW-QjQpsZmCnrqoTwmPecEQYT2Ew@mail.gmail.com>
Subject: Re: [PATCH] ksm: use FAULT_FLAG_ALLOW_RETRY in breaking COW
From: Michel Lespinasse <walken@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 3:50 AM, Hillf Danton <dhillf@gmail.com> wrote:
> The flag, FAULT_FLAG_ALLOW_RETRY, was introduced by the patch,
>
>        mm: retry page fault when blocking on disk transfer
>        commit: d065bd810b6deb67d4897a14bfe21f8eb526ba99
>
> for reducing mmap_sem hold times that are caused by waiting for disk
> transfers when accessing file mapped VMAs.
>
> To break COW, handle_mm_fault() is repeated with mmap_sem held, where
> the introduced flag could be used again.
>
> The straight way is to add changes in break_ksm(), but the function could be
> under write-mode mmap_sem, so it has to be dupilcated.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

I have to concur with Hugh here - FAULT_FLAG_ALLOW_RETRY was
introduced to avoid holding mmap_sem while we block on a disk read,
but you shouldn't hit this case in the break COW case, so there seems
to be little point in adding the flag there.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
