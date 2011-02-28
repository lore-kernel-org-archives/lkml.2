Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1B1IHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:07:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1B1IHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:07:00 -0500
Date: Mon, 28 Feb 2011 09:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
Message-ID: <20110228080642.GC1600@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.017570095@gulag1.americas.sgi.com>
 <20110227120949.GF16453@elte.hu>
 <20110227121518.GA19165@elte.hu>
 <4D6AFBB0.70401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6AFBB0.70401@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +	new_addr = memblock_alloc(new_log_buf_len, PAGE_SIZE);
> +	if (new_addr != MEMBLOCK_ERROR)
> +		new_log_buf = __va(new_addr);
> +	else
> +		new_log_buf = alloc_bootmem(new_log_buf_len);

alloc_bootmem() can fail, especially if someone uses a too large boot parameter 
value - and your code does not check for failure.

Thanks,

	Ingo
