Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1DZIHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:07:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1DZIHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:07:02 -0400
Date: Tue, 26 Apr 2011 10:06:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] printk: Allocate log buffer as early as possible
Message-ID: <20110426080639.GB806@elte.hu>
References: <20110425181136.055235992@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425181136.055235992@gulag1.americas.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> On larger systems, information in the kernel log is lost because
> there is so much early text printed, that it overflows the static
> log buffer before the log_buf_len kernel parameter can be processed,
> and a bigger log buffer allocated.
> 
> Distros are relunctant to increase memory usage by increasing the
> size of the static log buffer, so minimize the problem by allocating
> the new log buffer as early as possible.

I think this looks sane in principle and will solve quite a few 'the log buffer 
got too large' problems which previously resulted in somewhat complex looking 
printk-reduction patches. Andrew, if you agree with the patches, wanna carry 
them?

Thanks,

	Ingo
