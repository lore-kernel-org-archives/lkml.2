Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab1EWUF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:05:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48525 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab1EWUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:05:26 -0400
Message-ID: <4DDABDF2.1080704@zytor.com>
Date: Mon, 23 May 2011 13:05:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Eduardo Silva <edsiper@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: Fix ftrace.c compiler warning when calling ftrace_nop_replace()
References: <1306113548.29789.2.camel@monotop>  <4DD9BA2F.9000303@zytor.com> <1306156114.1465.37.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1105232159350.4933@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1105232159350.4933@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 01:01 PM, John Kacur wrote:
> On Mon, 23 May 2011, Steven Rostedt wrote:
>> The real solution is to change all the users into const *. This should
>> be doable as the new and old pointers are not modified.


> 
> From 71d6e5971cc90a03fd2d7bf8aaa2b81932bd0c7c Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Mon, 23 May 2011 21:24:27 +0200
> Subject: [PATCH] ftrace: Change unsigned char *new, *old to const
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This removes the warning:
> arch/x86/kernel/ftrace.c: In function ¡ftrace_make_nop¢:
> /arch/x86/kernel/ftrace.c:308: warning: assignment discards qualifiers from pointer target type
> 
> Steven Rostedt suggested to make these pointers const pointers.
> 
> This patch assumes that
> https://patchwork.kernel.org/patch/798172/
> is applied first.
> 
> Reported-by: Eduardo Silva <edsiper@gmail.com>
> Signed-off-by: John Kacur <jkacur@redhat.com>

Looks much better.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
