Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1JUOzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 10:55:35 -0400
Received: from lokagrupo.gerwinski.de ([213.239.212.49]:48726 "EHLO
	lokagrupo.gerwinski.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1JUOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 10:55:34 -0400
X-Greylist: delayed 1843 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Oct 2011 10:55:34 EDT
Date: Fri, 21 Oct 2011 16:25:30 +0200
Message-ID: <1319207130.31815.498615@m31.gerwinski.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=us-ascii
Subject: Can I call kthread_should_stop() from
	user-space tasks?
To: linux-kernel@vger.kernel.org
From: Frank Heckenbach <f.heckenbach@fh-soft.de>
User-Agent: semail 20060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is it permissible to call kthread_should_stop() from normal
user-space tasks (looking at kthread.c I suppose not), and if not,
is there a way to find out whether the current task is a kthread?

Reason I'm asking, I have a function that's called from both
kthreads and user-space tasks which calls
wait_event_interruptible(). If it's a kthread I want to add
"|| kthread_should_stop()" to the condition so it can be stopped
with kthread_stop() while waiting, but of course I don't want to
break user-space tasks by calling kthread_should_stop() if it's
invalid.
