Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1EXPTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:19:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32798 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1EXPTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:19:17 -0400
Date: Tue, 24 May 2011 17:19:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] x86: UV uv_tlb.c cleanup
Message-ID: <20110524151910.GA23496@elte.hu>
References: <E1QOrld-0003II-DP@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QOrld-0003II-DP@eag09.americas.sgi.com>
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


Well, so you have changed this current sequence in uv_init_per_cpu():

>	...
>		return 1;

>  	kfree(uvhub_descs);
>  	kfree(uvhub_mask);
>       [ ...]
>  	return 0;

to:

> +       if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask))
> +               goto fail;


>  	kfree(uvhub_descs);
>  	kfree(uvhub_mask);
>       [ ...]
> +	init_per_cpu_tunables();
>  	return 0;
> +
> +fail:
> +	kfree(uvhub_descs);
> +	kfree(uvhub_mask);
> +	return 1;

Don't the kfree()s get changed - i.e. the patch has a side-effect?

And yes, while this might be a kmem leak fix, it is a fix and a *SIDE EFFECT* 
which i explicitly asked to be queued in a separate patch(es) from the large 
cleanup patch ...

The cleanup patch should be a cleanup of existing code - even if that code has 
bugs. Nothing more. Bug fixes are for different patches.

Thanks,

	Ingo
