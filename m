Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1EYKCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:02:08 -0400
Received: from 8bytes.org ([88.198.83.132]:45120 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab1EYKCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:02:06 -0400
Date: Wed, 25 May 2011 12:02:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110525100201.GL23407@8bytes.org>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com> <20110524034023.GB25230@elte.hu> <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com> <20110524173326.GA7635@gere.osrc.amd.com> <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com> <1306272274.2497.73.camel@laptop> <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com> <BANLkTi=Mz7SoXz5zk-p-+FYBKC6aSWtgtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Mz7SoXz5zk-p-+FYBKC6aSWtgtg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 02:48:30PM -0700, Tony Luck wrote:

> But the case when I'd want to do the "stop this task" thing is when I
> think that I can recover - for memory errors detected while in kernel
> code I expect this will only ever be a few special cases:
> 1) copy to/from user
> 2) copy page (for copy-on-write fault)
> 3) ...
> and in these cases we don't have interrupts disabled.  In fact I have
> difficulty imagining a scenario where the kernel trips over a memory
> error in interrupt disabled code that would ever be recoverable.

Perf itself has a copy_from_user_nmi which is used to collect stack
traces. But those non-preemptible user accesses can be moved out of
your special cases.

	Joerg

