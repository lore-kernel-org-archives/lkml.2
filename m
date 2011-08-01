Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1HAMkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:40:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:52338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1HAMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:39:55 -0400
Subject: Re: threaded interrupt handlers: what if hardirq part not disables
 device interrupt?
From: Peter Zijlstra <peterz@infradead.org>
To: Remy Bohmer <linux@bohmer.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <CANqCtQ+9ab1qt0WzuC6n6gX9Y8XNcDxaTosUBc94eecj0umuiQ@mail.gmail.com>
References: <CANqCtQ+9ab1qt0WzuC6n6gX9Y8XNcDxaTosUBc94eecj0umuiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 14:44:38 +0200
Message-ID: <1312202678.2617.460.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 16:15 +0200, Remy Bohmer wrote:
> As alternative solution I can do the following as well:
> The driver now has a tasklet used for processing the queue. If I add
> IRQF_NO_THREAD as irq-flag, the thread is not created and the handler
> runs completely in hard-irq context. This seems to work okay, but it
> does not feel as the right solution.
> 
> How is this supposed to work? Do you have better ideas how to solve
> situations like this? 

This sounds like the total trainwreck known as tty/console, I believe
jwessel and tglx had some ideas on that. Maybe Jason can share what he
knows, I'm not up to speed on that issue.



