Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2HSQns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab2HSQnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:43:46 -0400
Date: Sun, 19 Aug 2012 18:40:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] uprobes: teach uprobes to clear MMF_HAS_UPROBES
Message-ID: <20120819164008.GA25454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "kill uprobes_state->count, add MMF_HAS_UPROBES"
series.

Once again, I am not sure we really need this (except 1/3).
Perhaps we could remove uprobe_munmap() instead and forget
about the false-positive MMF_HAS_UPROBES's.

OTOH, imho it looks a bit more clean this way. Please comment.

diffstat reports the code bloat, but note that the previous
series removed more code.

Oleg.

 include/linux/sched.h   |    3 +-
 kernel/events/uprobes.c |   82 +++++++++++++++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 18 deletions(-)

