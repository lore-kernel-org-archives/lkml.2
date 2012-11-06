Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2KFWiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:38:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2KFWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:38:21 -0500
Date: Tue, 6 Nov 2012 14:38:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 07/16] mm: fix cache coloring on x86_64 architecture
Message-Id: <20121106143819.4309031c.akpm@linux-foundation.org>
In-Reply-To: <1352155633-8648-8-git-send-email-walken@google.com>
References: <1352155633-8648-1-git-send-email-walken@google.com>
	<1352155633-8648-8-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Nov 2012 14:47:04 -0800
Michel Lespinasse <walken@google.com> wrote:

> Fix the x86-64 cache alignment code to take pgoff into account.
> Use the x86 and MIPS cache alignment code as the basis for a generic
> cache alignment function.
> 
> The old x86 code will always align the mmap to aliasing boundaries,
> even if the program mmaps the file with a non-zero pgoff.
> 
> If program A mmaps the file with pgoff 0, and program B mmaps the
> file with pgoff 1. The old code would align the mmaps, resulting in
> misaligned pages:
> 
> A:  0123
> B:  123
> 
> After this patch, they are aligned so the pages line up:
> 
> A: 0123
> B:  123

We have a bit of a history of fiddling with coloring and finding that
the changes made at best no improvement.  Or at least, that's my
perhaps faulty memory of it.

This one needs pretty careful testing, please.
