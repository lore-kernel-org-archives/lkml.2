Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1B0LyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:54:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab1B0LyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:54:04 -0500
Date: Sun, 27 Feb 2011 12:53:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110227115350.GB16453@elte.hu>
References: <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
 <20110225111606.GG24828@htj.dyndns.org>
 <4D680EA4.6050402@kernel.org>
 <20110226085737.GT24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226085737.GT24828@htj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> > will have problem with cross node conf. like 0-4g, 8-12g on node0, 4g-8g, 
> > 12g-16g on node1.
> 
> And how common are they?  This whole cruft is basically meaningless if 1GiB 
> mapping is supported, IOW, basically on all AMD 64s and all post-nehalem intels.  
> Why not just cite the limitation in the comment and stick to something simple?

Such complexity should be justified via very careful "perf stat --repeat" 
measurements.

I.e. showing 'before patch' and 'after patch' instruction, TLB miss and cycle 
counts, showing that a positive effect that goes beyond the noise of the measurement 
exists.

1GB mappings should be assumed as the common case - anything else probably does not 
matter from a future performance/scalability POV. For vmalloc() it might make sense 
- but even for those precise measurements should be done about the positive effect.

Thanks,

	Ingo
