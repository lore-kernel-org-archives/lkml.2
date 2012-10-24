Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab2JXVCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:02:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2JXVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:02:29 -0400
Date: Wed, 24 Oct 2012 14:02:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [RESEND][PATCH] gen_init_cpio: avoid stack overflow when
 expanding
Message-Id: <20121024140227.299041a9.akpm@linux-foundation.org>
In-Reply-To: <20121024205756.GA12419@www.outflux.net>
References: <20121024205756.GA12419@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 13:57:56 -0700
Kees Cook <keescook@chromium.org> wrote:

> Fix possible overflow of the buffer used for expanding environment
> variables when building file list.
> 
> $ cat usr/crash.list
> file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
> $ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
> *** buffer overflow detected ***: ./usr/gen_init_cpio terminated
> 
> This also replaces the space-indenting with tabs.
> 
> Patch based on existing fix extracted from grsecurity.
> 
> ...
>
> Cc: stable@vger.kernel.org

Why did you feel we need to backport this to -stable?
