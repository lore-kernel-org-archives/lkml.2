Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0F1PDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:03:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab0F1PDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <1277736661.3561.110.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
	<20100624172334.ca7e9bef.isloginov@gmail.com>
	<1277715689.1875.1104.camel@laptop>
	<1277725997.3561.6.camel@laptop>
	<20100628141927.GA9306@elte.hu>
	<1277736661.3561.110.camel@laptop>
Date: Mon, 28 Jun 2010 08:03:27 -0700
Message-ID: <AANLkTimM1IHPQY-Scjh7D4hCcPeJIemf6fpzn6lqBrn0@mail.gmail.com>
Subject: Re: [PATCH] init: Fix race between init and kthreadd -v3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ilya Loginov <isloginov@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 7:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>  static int __init kernel_init(void * unused)
>  {
> +       /*
> +        * Wait until kthreadd is all set-up.
> +        */
> +       wait_for_completion(&kthreadd_done);
>        lock_kernel();

Ack. Looks sane.

                  Linus
