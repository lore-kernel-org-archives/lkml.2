Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1G2P0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:26:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:57580 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1G2P0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:26:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="33562330"
Subject: Re: [PATCH 4/8] coredump_wait: don't call complete_vfork_done()
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110729142555.GC3501@redhat.com>
References: <20110727163159.GA23785@redhat.com>
	 <20110727163311.GD23793@redhat.com>
	 <1311944555.21232.68.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110729142555.GC3501@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 16:26:15 +0100
Message-ID: <1311953175.21232.70.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:25 +0200, Oleg Nesterov wrote:
>
> Please note that if ->vfork_done != NULL, then ->real_parent shares
> ->mm with us, by definition of CLONE_VFORK.
> 
> In this case, with or without this patch, the parent was already
> killed by zap_threads(). It can never do wait() or something else.
> 
> However. before 3/8, it was necessary to wakeup the TASK_UNINTERRUPTIBLE
> parent, otherwise we deadlock. Once again, it can't do anything,
> it will die immediately because of fatal_signal_pending().

D'oh, yes. I see now, thanks!

