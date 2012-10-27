Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2J0SsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:48:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab2J0SsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:48:06 -0400
Date: Sat, 27 Oct 2012 11:48:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Minyard <cminyard@mvista.com>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] Remove uninitialized_var()
Message-Id: <20121027114836.e9a6a922.akpm@linux-foundation.org>
In-Reply-To: <20121027131203.GA27313@gmail.com>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
	<1350420820-7156-5-git-send-email-minyard@acm.org>
	<20121022164902.9b204646.akpm@linux-foundation.org>
	<508AE611.3020504@mvista.com>
	<CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com>
	<20121027131203.GA27313@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2012 15:12:03 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> There's 3 types of conversions done:
> 
>    uninitialized_var(x)        =>  x = 0       /* for scalar types */
>    uninitialized_var(x)        =>  x = NULL    /* for pointers */
>    uninitialized_var(x)        =>  x = { }     /* for structures, unions */

It's regrettable that we lose information.  uninitialized_var() says
"this isn't needed - it's just there for gcc".  The reader can of
course work out the reason with careful code inspection, but that's a
lot more time consuming.

We could go add "/* keep gcc quiet */" to every site, or add
self-documenting macros for the above.
