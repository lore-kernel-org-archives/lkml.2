Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1GGAvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:51:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55841 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1GGAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:51:31 -0400
Date: Thu, 7 Jul 2011 02:51:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110707005124.GC21115@somewhere>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
 <4E14F31B.4080102@zytor.com>
 <20110706235613.GA21115@somewhere>
 <4E14F797.8070501@zytor.com>
 <20110707002512.GB21115@somewhere>
 <4E14FE1A.9000003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14FE1A.9000003@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 05:30:18PM -0700, H. Peter Anvin wrote:
> > Trace events are irresponsible anyway because they involve that "ABI not really stable but tools
> > rely on it so...well...)". I'm not sure the above points make the situation worse though. Probably
> > the cases that fit in 2) need to be carefully checked to ensure they really fit in 2).
> 
> Yes, it was much more of a generic concern.  However, it is very
> important that people have a correct idea about what the stability of
> something like tracepoint is -- or we'll end up in a situation where we
> can never change the kernel because anything is suddenly "user space
> visible."

Agreed. Well the current situation is a best effort to keep trace events stable, but when
subsystems evolve, some trace events don't make any sense anymore, or some parameters need
to be changed or removed.

This break tools but OTOH those tools were measuring something that don't make sense anymore
with newer kernels. I guess we don't have the choice there.

But the situation is more scary when some tracepoints seem to have been badly designed and need
refactoring. I believe it was the case of power events. And now we are forced to maintain old
tracepoints that halfway make sense, just to avoid breaking old tools.

So yeah, we definetly need to care about new tracepoints coming. Especially as they touch generic
parts but archs are also to be considered.
