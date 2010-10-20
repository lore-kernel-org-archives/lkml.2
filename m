Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab0JTNGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:06:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0JTNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:06:37 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=r7vHpovKClYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=qyGgBq6Egb8k_feRqDMA:9 a=TO1xO2AdWe8j_sr-ghJWz_Gf7LIA:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/5] ring-buffer: Bind time extend and data events
 together
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1010192244290.6815@localhost6.localdomain6>
References: <20101019175432.854431527@goodmis.org>
	 <20101019194203.807907304@goodmis.org>
	 <alpine.LFD.2.00.1010192244290.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Oct 2010 09:06:33 -0400
Message-ID: <1287579993.16971.552.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 22:46 +0200, Thomas Gleixner wrote:
> On Tue, 19 Oct 2010, Steven Rostedt wrote:

> > Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/ring_buffer.h |   12 --
> >  kernel/trace/ring_buffer.c  |  283 +++++++++++++++++++++++--------------------
> >  2 files changed, 154 insertions(+), 141 deletions(-)
> 
> Is there no way to make this change a bit more finegrained,
> i.e. incremental patches ?
> 
> Thanks,

There's probably a little I can add incrementally, but the main change
that this does is that the ring buffer can return either a data type or
time extend type (which has a data type appended to it).

Luckily, the interface to the ring buffer has all be encapsulated, so
the only changes need to be made in ring_buffer.[ch]. All interfaces
that take a event type needs to check if it is a data or time extend.
Which is why the patch looks so big. But these changes are contained in
this file.

But there's some clean ups that this patch did, I can pull them out and
submit again.

Thanks,

-- Steve


