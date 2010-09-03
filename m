Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0ICGJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:09:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0ICGJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:09:54 -0400
Date: Fri, 3 Sep 2010 08:09:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric B Munson <emunson@mgebm.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        akpm@linux-foundation.org, mingo@redhat.com,
        hugh.dickins@tiscali.co.uk, riel@redhat.com, peterz@infradead.org,
        anton@samba.org, hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] Add trace points to mmap, munmap, and brk
Message-ID: <20100903060927.GA19074@elte.hu>
References: <20100721223359.8710.A69D9226@jp.fujitsu.com>
 <20100727110904.GA6519@mgebm.net>
 <20100727201644.2F46.A69D9226@jp.fujitsu.com>
 <20100902134827.GA6957@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902134827.GA6957@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric B Munson <emunson@mgebm.net> wrote:

> Sorry for the long delay, the enter/exit routines are not compatible 
> with the information that these new trace points provides.  When 
> tracing mmap, for instance, the addr and len arguments can be altered 
> by the function.  If you use the enter/exit trace points you would not 
> see this as the arguments are sampled at function entrance and not 
> given again on exit.  Also, the new trace points are only hit on 
> function success, the exit trace point happens any time you leave the 
> system call.

Would it be feasible to use enter/exit information as the main source of 
events - and only add new tracepoints for the _missing_ information? 
(such as when mmap arguments change)

Then user-space can combine the two. The new tracepoints would also 
carry useful information in themselves: they would show the cases where 
user-space did not get what it wished. (or so)

Thanks,

	Ingo
