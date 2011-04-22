Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1DVMbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:31:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54434 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab1DVMbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:31:20 -0400
Date: Fri, 22 Apr 2011 13:31:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] signal: sigprocmask: narrow the scope of
 ->siglock
Message-ID: <20110422133118.48c0933e@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134538.GE15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134538.GE15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:45:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> No functional changes, preparation to simplify the review of the next change.
> 
> 1. We can read current->block lockless, nobody else can ever change this mask.
> 
> 2. Calculate the resulting sigset_t outside of ->siglock into the temporary
>    variable, then take ->siglock and change ->blocked.
> 
> Also, kill the stale comment about BKL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks for that updated comment about not being able to change
->blocked from irq context!

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
