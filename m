Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1GGTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1GGTGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:06:01 -0400
Date: Thu, 7 Jul 2011 21:03:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, indan@nul.nu, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: fix ptrace_signal() && STOP_DEQUEUED
	interaction
Message-ID: <20110707190301.GA25332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another very annoying and ancient problem which needs the fix,
and any fix obviously adds the subtle user-visible changes.

In short, in general it is simply impossible to know whether
PTRACE_CONT(SIGSTOP) will stop the tracee or not.

ee77f075 "signal: Turn SIGNAL_STOP_DEQUEUED into GROUP_STOP_DEQUEUED"
makes the things better, at least STOP_DEQUEUED can't be set/cleared
by another thread, but still without this patch the behavior is not
clearly defined.

Oleg.

