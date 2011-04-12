Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1DLLiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:38:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44328 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab1DLLiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:38:20 -0400
Date: Tue, 12 Apr 2011 12:38:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] signal: sigprocmask: narrow the scope of ->sigloc
Message-ID: <20110412123817.019bae16@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411172109.GD32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
	<20110411172109.GD32469@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:21:09 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> No functional changes, preparation to simplify the review of the next
> change.
> 
> 1. We can read current->block lockless, nobody else can ever change
> this mask.

Is it worth mentioning this in a comment? What is the reason that it's
OK? Is it because we only ever modify current->blocked and never
another task's blocked signals and that we never modify
current->blocked from within any form of interrupt context?

Some of the code in fs/{autofs4,coda} seems to do interesting things
with current->blocked, particularly the daemon stuff in autofs4.

-- 
Matt Fleming, Intel Open Source Technology Center
