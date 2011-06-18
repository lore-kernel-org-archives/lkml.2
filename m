Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1FRVzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:55:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741Ab1FRVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:55:39 -0400
Date: Sat, 18 Jun 2011 14:55:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/12] mm: let swap use exceptional entries
Message-Id: <20110618145546.12e175bf.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1106140342330.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140342330.29206@sister.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 03:43:47 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> In an i386 kernel this limits its information (type and page offset)
> to 30 bits: given 32 "types" of swapfile and 4kB pagesize, that's
> a maximum swapfile size of 128GB.  Which is less than the 512GB we
> previously allowed with X86_PAE (where the swap entry can occupy the
> entire upper 32 bits of a pte_t), but not a new limitation on 32-bit
> without PAE; and there's not a new limitation on 64-bit (where swap
> filesize is already limited to 16TB by a 32-bit page offset).

hm.

>  Thirty
> areas of 128GB is probably still enough swap for a 64GB 32-bit machine.

What if it was only one area?  128GB is close enough to 64GB (or, more
realistically, 32GB) to be significant.  For the people out there who
are using a single 200GB swap partition and actually needed that much,
what happens?  swapon fails?

