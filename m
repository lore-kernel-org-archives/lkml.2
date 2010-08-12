Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab0HLVWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:22:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab0HLVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:22:44 -0400
Date: Thu, 12 Aug 2010 14:22:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <arighi@develer.com>
Cc: Stefani Seibold <stefani@seibold.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kfifo: add kfifo_skip() testcase
Message-Id: <20100812142211.59e24462.akpm@linux-foundation.org>
In-Reply-To: <1281627158-9461-2-git-send-email-arighi@develer.com>
References: <1281627158-9461-1-git-send-email-arighi@develer.com>
	<1281627158-9461-2-git-send-email-arighi@develer.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 17:32:38 +0200
Andrea Righi <arighi@develer.com> wrote:

> Add a testcase for kfifo_skip() to the byte stream fifo example.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  samples/kfifo/bytestream-example.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
> index 642eef3..2e3a7a8 100644
> --- a/samples/kfifo/bytestream-example.c
> +++ b/samples/kfifo/bytestream-example.c
> @@ -73,6 +73,10 @@ static int __init testfunc(void)
>  	ret = kfifo_in(&test, buf, ret);
>  	printk(KERN_INFO "ret: %d\n", ret);
>  
> +	/* skip first element of the fifo */
> +	printk(KERN_INFO "skip 1st element\n");
> +	kfifo_skip(&test);
> +
>  	/* put values into the fifo until is full */
>  	for (i = 20; kfifo_put(&test, &i); i++)
>  		;

hm, that's not a very good test harness.  A better one would check that
the resulting kfifo actually contains the expected items in the
expected order.  AFACIT this will "pass" even if kfifo_skip() is a
no-op, or execs nethack or something.

Oh well, it's more than we usually get.
