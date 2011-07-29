Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1G2NCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:02:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:36933 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab1G2NCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="33748046"
Subject: Re: [PATCH 4/8] coredump_wait: don't call complete_vfork_done()
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110727163311.GD23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
	 <20110727163311.GD23793@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 14:02:35 +0100
Message-ID: <1311944555.21232.68.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 18:33 +0200, Oleg Nesterov wrote:
> Now that CLONE_VFORK is killable, coredump_wait() no longer needs
> complete_vfork_done(). zap_threads() should find and kill all tasks
> with the same ->mm, this includes our parent if ->vfork_done is set.
> 
> mm_release() becomes the only caller, unexport complete_vfork_done().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Isn't there a subtle change in user-visible behaviour regarding wait()
with this patch?

Before the patch, if a child dumps its core it will wakeup the parent
which can read the status of the child via wait(), whereas with this
patch applied the parent will actually be killed along with the child.

I'm not trying to say which behaviour I think is the correct one, just
that because it is a user-visible change and it is maybe worth a bit
more discussion in the changelog?

