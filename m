Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2KLLzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:55:22 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56936 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2KLLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:55:17 -0500
MIME-Version: 1.0
In-Reply-To: <509D0F86.30607@gmail.com>
References: <1352155633-8648-1-git-send-email-walken@google.com>
	<1352155633-8648-4-git-send-email-walken@google.com>
	<509D0F86.30607@gmail.com>
Date: Mon, 12 Nov 2012 03:55:16 -0800
Message-ID: <CANN689E4jXT-VA3j54h_MBgCCc9YK0o_E7PY326NnvdiHmAgFQ@mail.gmail.com>
Subject: Re: [PATCH 03/16] mm: check rb_subtree_gap correctness
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 6:13 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> While fuzzing with trinity inside a KVM tools (lkvm) guest, using today's -next
> kernel, I'm getting these:
>
> [  117.007714] free gap 7fba0dd1c000, correct 7fba0dcfb000
> [  117.019773] map_count 750 rb -1
> [  117.028362] ------------[ cut here ]------------
> [  117.029813] kernel BUG at mm/mmap.c:439!
>
> Note that they are very easy to reproduce.

Thanks for the report. I had trouble reproducing this on Friday, but
after Hugh came up with an easy test case I think I have it figured
out. I sent out a proposed fix as "[PATCH 0/3] fix missing
rb_subtree_gap updates on vma insert/erase". Let's follow up the
discussion there if necessary.

Cheers,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
