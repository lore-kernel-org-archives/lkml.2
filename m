Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2ECT5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:57:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45319 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2ECT5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:57:10 -0400
MIME-Version: 1.0
In-Reply-To: <1336074483.6509.3.camel@twins>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 12:56:48 -0700
X-Google-Sender-Auth: 8MuN5GW08Koy9vpyoFKPgWvcUaU
Message-ID: <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-05-03 at 02:29 +0200, Kay Sievers wrote:
>> + * This is printk(). It can be called from any context. We want it to work.
>
> This is not true..

Well, it is very very nearly true, and people should basically expect it to be.

There are exceptions, but they are ridiculously specific
 - no NMI context
 - we've had trouble with the percpu runqueue lock (due to the stupid wakeup)
 - for similar reasons, we've had trouble with printk called from
within some terminal locks.

But basically, it damn well should be considered a hard rule that you
can printk from pretty much anything. The few cases where that is not
true are big problems, and should be considered to be real problems,
not "oh, you can't printk from here".

                     Linus
