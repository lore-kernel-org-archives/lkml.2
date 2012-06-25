Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2FYPWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:22:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2FYPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <1340634366.27036.324.camel@gandalf.stny.rr.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
 <20120625135611.GA1301@gmail.com> <1340634366.27036.324.camel@gandalf.stny.rr.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 25 Jun 2012 17:22:25 +0200
Message-ID: <CAPXgP13=4fgTuL3fawZUV+Khzx=RK9froKe-iD5KBY1c8wWVGw@mail.gmail.com>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 4:26 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-06-25 at 15:56 +0200, Ingo Molnar wrote:

>> Anyway, bike shed painting aside, the patch looks like a
>> workable solution to me.
>
> Great! Lets hope Kay feels the same way.

Hmm, what I still miss, is how the log record export should work
properly with unbuffered continuation lines.

The buffering of continuation line users resulted in a clean one
record per logged line. Now we will get all separated records for all
continuation prints of a single line, which would either need to be
merged in userspace, or internally.

Non-buffered continuation lines and and a record buffer don't play
that well with each other. It also sounds like quite a lot of wasted
headers in the buffer, which we need to carry around and throw away
when we reconstruct the line for output again. If we merge them
internally we mess around with the sequence numbers, if we merge them
in userspace we would need to export the flags to do that.

Kay
