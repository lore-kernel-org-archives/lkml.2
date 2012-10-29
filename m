Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697Ab2J2VE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:04:26 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38048 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2J2VEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <1351521477.8467.78.camel@gandalf.local.home>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	<1351517296-9173-10-git-send-email-fweisbec@gmail.com>
	<1351521477.8467.78.camel@gandalf.local.home>
Date: Mon, 29 Oct 2012 22:04:23 +0100
Message-ID: <CAFTL4hxQf72sx1sspDNFBvQOSOz2pMynQUpi8S+3HGMNusUsbw@mail.gmail.com>
Subject: Re: [RFC PATCH 9/9] printk: Wake up klogd using irq_work
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
>> klogd is woken up asynchronously from the tick in order
>> to do it safely.
>>
>> However if printk is called when the tick is stopped, the reader
>> won't be woken up until the next interrupt, which might not fire
>> before a while. As a result, the user may miss some message.
>
> Just a grammar nit (and goes for your previous patch as well). We say
> "might not fire for a while." or you could say ".. for some time", but
> not "before a while" ;-)

Right!

>
> I wounder what the French translation of that is.

You don't really want to know ;)
But as you guess, this is quite close to something like "before a while" ;)
