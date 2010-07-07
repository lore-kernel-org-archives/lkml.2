Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0GGW0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:26:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089Ab0GGW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:26:47 -0400
Date: Wed, 7 Jul 2010 15:26:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix uninitialized variable warning in do_one_initcall
Message-Id: <20100707152640.586442f3.akpm@linux-foundation.org>
In-Reply-To: <1278199588-3273-1-git-send-email-kjwinchester@gmail.com>
References: <1278199588-3273-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Jul 2010 20:26:28 -0300
Kevin Winchester <kjwinchester@gmail.com> wrote:

> The warning is corrected by extracting the debug path out into
> its own function.  This does en up duplicating one line of code
> between the debug and regular code paths (i.e. the actual call
> of the initcall function), but it seems worthwhile for the
> cleaner build.
> 

I assume the warning was for `calltime'?  Maybe other things?  Please,
remove all doubt and always quote the compiler output in the changelog.

Also please mention the compiler version - it looks like this is a new
warning.  It's not a false positive either - the compiler doesn't know
that initcall_debug's value never changes.

The patch doesn't apply to linux-next because someone went on a great
tromp through do_one_initcall() so could you please redo the patch
against linux-next?

I suggest that you not inline do_one_initcall_debug() - the compiler
will do that anwyay.

And if you're feeling keen, please do a separate patch which marks
do_one_initcall() and do_one_initcall_debug() with __init_or_module -
we don't need to leave that code in memory after bootup if
CONFIG_MODULES=n.

Thanks.

