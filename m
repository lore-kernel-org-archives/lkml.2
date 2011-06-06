Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1FFRWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:22:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab1FFRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:22:20 -0400
Date: Mon, 6 Jun 2011 19:22:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Anderson <anderson@redhat.com>, Andy Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, jstancek@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: Prevent gcc from optimizing away venosys_1()
Message-ID: <20110606172209.GH2391@elte.hu>
References: <313387488.1201.1307114323524.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
 <2060873692.1232.1307114423575.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2060873692.1232.1307114423575.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Anderson <anderson@redhat.com> wrote:

> One of the changes in commit a4928cffe6435caf427ae673131a633c1329dbf3 
> made the venosys_1() system call static, which causes it to be 
> optimized out of the kernel:
> 
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Wed Apr 23 13:20:56 2008 +0200
> 
>   "make namespacecheck" fixes
> 
>   Signed-off-by: Ingo Molnar <mingo@elte.hu>

Andy noticed this recently, so we got rid of that broken (and unused) 
syscall in:

  bb5fe2f78ead: x86-64: Remove vsyscall number 3 (venosys)

which is in the tip:x86/vdso branch at:

   http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
