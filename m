Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387Ab2CSPqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:46:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47035 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007Ab2CSPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:46:43 -0400
Message-ID: <4F6754DA.6090401@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 21:16:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "pavel@ucw.cz" <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Suspend-to-ram not working when ftrace is enabled, again!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031905-1396-0000-0000-000000D62ED9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If tracing is enabled and we are tracing low-level suspend-to-ram related
functions like restore_processor_state() etc (which are included by default
in the list of traced functions), and we try suspending the machine, the
machine doesn't resume. It reboots instead.
(If we trace some unrelated functions like kzalloc() for example, there is
no problem with suspend/resume).

Looking at https://lkml.org/lkml/2008/8/27/177, it appears that this
is an old problem and also had a workaround (disabling tracing around
suspend). The above patch corresponds to commit id: f42ac38c59 (ftrace:
disable tracing for suspend to ram), which went in around 2.6.27 I think.
But then commit cbe2f5a6e84 (tracing: allow tracing of suspend/resume &
hibernation code again) reverted that commit.

And from https://lkml.org/lkml/2008/8/21/349, it looks like 2.6.28 and
further was supposed to be problem-free. But unfortunately this problem has
resurfaced.

I tested kernel 2.6.32.54 and I observed that the machine reboots during
resume, which looks exactly like the problem discussed in the link above.

In another machine, I tested 3.3-rc6 and it doesn't seem to respond to
resume events (like button press, lid open) at all. It just seems to remain
suspended forever.

Should we resort to disabling ftrace around suspend again? Or do we have a
better solution this time around?

Regards,
Srivatsa S. Bhat

