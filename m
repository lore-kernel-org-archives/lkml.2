Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0GORTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:19:38 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:44397 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0GORTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:19:37 -0400
Date: Thu, 15 Jul 2010 10:19:37 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/2] blktrace: startup / shutdown race fixes
Message-ID: <20100715171937.GA12953@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into the stale-block-directory problem while using blktrace,
and while chasing it noticed the open-coded cmpxchg.

The unlink-on-final-close is a longstanding bug that's triggerable
by the standard blktrace(1) utility (it races child threads against
the parent), and should go to -stable.  The cmpxchg is a startup
race that may be easy to maliciously trigger from userspace, but
is unlikely to be triggered accidentally.  (Famous last words...)

Andy Isaacson (2):
  blktrace: use cmpxchg
  blktrace: unlink blk directory on final trace close

 kernel/trace/blktrace.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)
