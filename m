Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1ARG0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:26:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51307
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab1ARG0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:26:51 -0500
Date: Mon, 17 Jan 2011 22:27:24 -0800 (PST)
Message-Id: <20110117.222724.112609854.davem@davemloft.net>
To: brl+ccmadness@pcpool00.mathematik.uni-freiburg.de
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
References: <20110115.211722.39173519.davem@davemloft.net>
	<20110116.220755.179947617.davem@davemloft.net>
	<20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Bernhard R. Link" <brl+ccmadness@pcpool00.mathematik.uni-freiburg.de>
Date: Mon, 17 Jan 2011 15:39:54 +0100

>> I think we want none of this, and I think we should elide the align
>> directives entirely, or at least fix them so we don't get unaligned
>> stuff on 64-bit.
> 
> One fix might be to move the __attribute__ from include/trace/ftrace.h
> (and from include/linux/syscalls.h) to include/linux/ftrace_event.h
> and attach it to the struct there. This way it should only increase it.

I'm beginning to think that the align directive is there purposely to
down-align the structure so that the amount of space that tracing
information consumes is minimized.

I honestly can't tell, only Steven Rostedt can tell us for sure,
because there are no commit messages or comments that explain why
these things need to be there.

If the align directives exist for that reason, then your suggestion
would likely completely undo what these directives are trying to
achieve.

Someone mentioned that the default struct alignment on x86-64 is
something rather rediculious like 32 bytes or something like that.
Yet someone else suggested to use __aligned__(32) to fix this, so
color me completely confused.

