Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab0J0P1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:27:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab0J0P1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com> <1288158182-1753-1-git-send-email-brgerst@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Oct 2010 08:19:50 -0700
Message-ID: <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com>
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
To: Brian Gerst <brgerst@gmail.com>
Cc: tj@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:43 PM, Brian Gerst <brgerst@gmail.com> wrote:
> The percpu allocator cannot handle alignments larger than one page.
> Allocate the irq stacks seperately, and only keep the pointers as
> percpu data.

Ok, so I definitely want this (although it sounds like it would be
good to do the allocation numa-aware - possibly a separate issue).

However, I also want to remove all the crap that got added for the
multi-page percpu support. It was ugly, and apparently never really
worked. All the PER_CPU_MULTIPAGE_ALIGNED crud just needs to go away.

Ingo, can you take care of this all, or should I just take the patch
and remove the multipage stuff manually?

                                  Linus
