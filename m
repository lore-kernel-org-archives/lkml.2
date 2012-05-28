Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2E1MAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:00:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51332 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2E1MAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205261317310.2488@eggly.anvils>
References: <1337884054.3292.22.camel@lappy>
	<20120524120727.6eab2f97.akpm@linux-foundation.org>
	<CA+1xoqcbZWLpvHkOsZY7rijsaryFDvh=pqq=QyDDgo_NfPyCpA@mail.gmail.com>
	<alpine.LSU.2.00.1205261317310.2488@eggly.anvils>
Date: Mon, 28 May 2012 20:00:48 +0800
Message-ID: <CAJd=RBCQxfzCQ_v3C+yR1yH0=uCvLvd3rDK-TDJf0MwM7OYyaQ@mail.gmail.com>
Subject: Re: mm: kernel BUG at mm/memory.c:1230
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        viro <viro@zeniv.linux.org.uk>, oleg@redhat.com,
        "a.p.zijlstra" <a.p.zijlstra@chello.nl>, mingo <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        l@jasper.es
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh

On Sun, May 27, 2012 at 4:26 AM, Hugh Dickins <hughd@google.com> wrote:
>
> Whereas in exiting, rwsem is not locked, but we're going linearly upwards,
> and whenever we walk into a pmd_trans_huge area, both addr and next should
> be hpage aligned: the vma bounds are unsuited to THP if they're unaligned.
>
Take a look at the dependence of huge page size on PAE,

             [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
             https://lkml.org/lkml/2012/5/28/39

and hope that is helpful.
-hd
