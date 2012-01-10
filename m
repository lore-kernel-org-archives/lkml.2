Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2AJE1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 23:27:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43269 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2AJE13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 23:27:29 -0500
MIME-Version: 1.0
Date: Tue, 10 Jan 2012 13:27:28 +0900
X-Google-Sender-Auth: SSWY6Jah6auinZmjbrHeuOMxPiE
Message-ID: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
Subject: BUG: sleeping function called from invalid context at include/linux/freezer.h:45
From: Kyungmin Park <kmpark@infradead.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all

with the latest kernel. I got the below bug message.
It calls the sleep function. Does it intended operation?

static inline bool try_to_freeze(void)
{
        might_sleep();
        if (likely(!freezing(current)))
                return false;
        return __refrigerator(false);
}

# poweroff
[    6.852523] BUG: sleeping function called from invalid context at
include/linux/freezer.h:45
[    6.859489] in_atomic(): 0, irqs_disabled(): 128, pid: 1, name: init
[    6.865846] [<c0013508>] (unwind_backtrace+0x0/0xec) from
[<c0010124>] (do_signal+0x88/0x588)
[    6.874337] [<c0010124>] (do_signal+0x88/0x588) from [<c001063c>]
(do_notify_resume+0x18/0x38)
[    6.882928] [<c001063c>] (do_notify_resume+0x18/0x38) from
[<c000dc18>] (work_pending+0x24/0x28)

commit e4e11180dfa545233e5145919b75b7fac88638df
Merge: 37cfc3f adc0e91
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jan 9 17:37:37 2012 -0800

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vi

Thank you,
Kyungmin Park
