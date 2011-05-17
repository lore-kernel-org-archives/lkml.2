Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1EQV2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:28:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44339 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab1EQV2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:28:09 -0400
Date: Tue, 17 May 2011 23:27:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect
 task->comm access
Message-ID: <20110517212734.GB28054@elte.hu>
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
 <1305665263-20933-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305665263-20933-2-git-send-email-john.stultz@linaro.org>
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


* John Stultz <john.stultz@linaro.org> wrote:

> The implicit rules for current->comm access being safe without locking are no 
> longer true. Accessing current->comm without holding the task lock may result 
> in null or incomplete strings (however, access won't run off the end of the 
> string).

This is rather unfortunate - task->comm is used in a number of performance 
critical codepaths such as tracing.

Why does this matter so much? A NULL string is not a big deal.

Note, since task->comm is 16 bytes there's the CMPXCHG16B instruction on x86 
which could be used to update it atomically, should atomicity really be 
desired.

Thanks,

	Ingo
