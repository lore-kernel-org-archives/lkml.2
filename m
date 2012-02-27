Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2B0H6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:58:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2B0H57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:57:59 -0500
Date: Mon, 27 Feb 2012 08:57:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Daniel Rahn <drahn@suse.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, pci: Increase the number of iommus supported to
 be MAX_IO_APICS v2
Message-ID: <20120227075741.GD3397@elte.hu>
References: <20120223004930.817124691@gulag1.americas.sgi.com>
 <20120223004931.121722197@gulag1.americas.sgi.com>
 <20120223123011.cfe4ae35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223123011.cfe4ae35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Also we can tweak the code flow and the message to avoid dorky
> 80-column games:

> +		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
>  			  IOMMU_UNITS_SUPPORTED);

Not to mention the use of pr_err():

		pr_err("intel-iommu: exceeded %d IOMMUs\n", IOMMU_UNITS_SUPPORTED);

Plus if we defined a proper driver message prefix at the top of 
the driver:

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

We could do:

		pr_err("Exceeded max %d IOMMUs\n", IOMMU_UNITS_SUPPORTED);

Note, I added 'max', for clarity.

Plus IOMMU_UNITS_SUPPORTED could be renamed to the much shorter 
IOMMU_MAX, without a loss of clarity:

		pr_err("Exceeded max %d IOMMUs\n", IOMMU_MAX);

So we made that line vastly shorter, and made the human-readable 
message actually longer and more expressive.

80 column wraps are almost always not a sign of lack of screen 
real estate, but a symptom of lack of thinking.

Thanks,

	Ingo
