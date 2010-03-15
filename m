Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476Ab0CORDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:03:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50391 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965417Ab0CORDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:03:15 -0400
Date: Mon, 15 Mar 2010 13:03:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: Changli Gao <xiaosuo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [RELEASE] LTTng 0.199 for Linux 2.6.33
Message-ID: <20100315170311.GA390@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:53:48 up 51 days, 19:31,  8 users,  load average: 1.16, 0.77,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I just released an updated LTTng tree/tarball that is now based on the 2.6.33
kernel. As always, comments and testing results are welcome.

Website:
http://lttng.org

Kernel tree:
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git

Tarballs:
http://lttng.org/files/lttng/patch-2.6.33-lttng-0.199.tar.bz2

There has been some changes in the way splice() works between 2.6.32 and 2.6.33
(commit cc56f7de7f00d188c7c4da1e9861581853b9e92f). It now checks for NULL llseek
fop in addition to check for the no_llseek. In LTTng, we use the offset value
directly in our own implementation of the splice_read fop, so there is no point
in having a llseek fop.  The solution I used to bypass this check is to create
my own copy of "no_llseek" in ltt-relay-splice.c, which does basically nothing,
but makes do_splice() happy.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
