Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2FFOvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:51:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2FFOve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:51:34 -0400
Date: Wed, 6 Jun 2012 16:49:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] uprobes: make register/unregister O(n)
Message-ID: <20120606144933.GA24078@redhat.com>
References: <20120604145238.GA6408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604145238.GA6408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On top of "[PATCH 0/3] uprobes: misc minor changes".

Sorry for delay. When I tried to test these changes, I hit the
bug report from bad_page(). However, it turns out this is another
unrelated problem, hopefully I'll send the fix soon. In short,
replace_page() is buggy.

Changes:

	- do not try GFP_NOWAIT if it failed before and more != 0,
	  this is pointless and wrong

	- update the comments (thanks Peter)

Oleg.

