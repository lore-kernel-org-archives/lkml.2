Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1EWBhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:37:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52050 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1EWBhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:37:16 -0400
Message-ID: <4DD9BA2F.9000303@zytor.com>
Date: Sun, 22 May 2011 18:36:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eduardo Silva <edsiper@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: Fix ftrace.c compiler warning when calling ftrace_nop_replace()
References: <1306113548.29789.2.camel@monotop>
In-Reply-To: <1306113548.29789.2.camel@monotop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 06:19 PM, Eduardo Silva wrote:
> the function ftrace_nop_replace() returns a 'static const unsigned char *'
> value, so when the caller perform a direct assignment to a
> 'static unsigned char *', the compiler raise the following warning message:
> 
>  ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
>  ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
> 
> Adding the proper casts the message goes away.
> 
> Signed-off-by: Eduardo Silva <edsiper@gmail.com>

This quiets a warning of something that potentially looks like a real
bug.  Perhaps "new" should be const?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

