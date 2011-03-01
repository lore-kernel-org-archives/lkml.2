Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1CAHft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:35:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40848 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CAHfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:35:48 -0500
Date: Tue, 1 Mar 2011 08:35:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
Message-ID: <20110301073533.GA12384@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.017570095@gulag1.americas.sgi.com>
 <20110227120949.GF16453@elte.hu>
 <20110227121518.GA19165@elte.hu>
 <4D6AFBB0.70401@kernel.org>
 <20110228080133.GB1600@elte.hu>
 <4D6BF6CC.4000407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BF6CC.4000407@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> >* Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >>+	pr_info("log_buf_len: %d\n", log_buf_len);
> >>+	pr_info("early log buf free: %d(%d%%)\n",
> >>+		free, (free * 100) / __LOG_BUF_LEN);
> >
> > Such debug printks should be removed from the final version of the patch ...
>
> Because I haven't been able to test on a fully configured
> system, this might be crucial info to figure out how to
> fix this when it happens on a customer system.  Are you
> saying this small line is any less important than the
> other thousands and thousands of seemingly meaningless
> lines?

I think you are thinking about this the wrong way.

The real fix is to never even have to think about 'how much early buffer space do we 
have left'. I.e. via the memblock allocation the buffer can be enlargened before the 
big printks happen.

btw., a sidenote, it would make sense to record cases when we 'lose' printk output, 
in the printk buffer itself. (it can be done by reserving a bit and updating the 
'lost this many bytes' portion of the buffer, or so.)

Thanks,

	Ingo
