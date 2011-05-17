Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1EQWSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:18:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49480 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab1EQWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:18:03 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: John Stultz <john.stultz@linaro.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <4DD2EBAB.5080004@gmail.com>
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
	 <1305665263-20933-3-git-send-email-john.stultz@linaro.org>
	 <4DD2EBAB.5080004@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 15:17:46 -0700
Message-ID: <1305670666.2915.128.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:42 +0200, Jiri Slaby wrote:
> On 05/17/2011 10:47 PM, John Stultz wrote:  
> > +static noinline_for_stack
> 
> I still fail to see why this should be slowed down by noinlining it.
> Care to explain?

Just that I was hesitant to change it without consensus and it follows
the convention of other similarly called functions.

> With my setup, the code below inlined will use 32 bytes of stack. The
> same as %pK case. Uninlined it obviously eats "only" 8 bytes for IP.

Maybe could we defer that discussion into a following patch, which maybe
does a similar analysis on the other noinline_for_stack usage in that
case?

(And I may be dropping the whole series here in a bit, so more debate on
it might be moot)

thanks
-john


