Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2BNQxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:53:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab2BNQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:53:52 -0500
Date: Tue, 14 Feb 2012 17:47:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] make request_module() killable
Message-ID: <20120214164709.GA21178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tetsuo pointed out, request_module() is very much unfriendly wrt OOM.
It needs "a lot" of time/memory to finish while the caller is blocked in
TASK_UNINTERRUPTIBLE.

Changes:

	- improve the comments a bit

	- reorder the changes so that 3/6 which changes kABI can be
	  skipped, to simplify the backporting

	- tried to test, seems to work

This series is orthogonal to kmod-avoid-deadlock-by-recursive-kmod-call.patch
(which I still think should be replaced, I'll try to return to this later).

3/6 depends on usermodehelper-use-umh_wait_proc-consistently.patch


Many thanks to Tetsuo for the discussion.

Oleg.

