Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1BQR0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:26:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab1BQR0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:26:10 -0500
Date: Thu, 17 Feb 2011 18:25:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in exception
 tables
Message-ID: <20110217172559.GD17058@elte.hu>
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
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


Nice patch. I've got a really small code readability nitpick:

> +#ifndef ex_insn /* until all architectures have this accessor */
> +#define ex_insn(x) (x)->insn
> +#endif

> +#else
> +#define swap_ex NULL
> +#endif

In the x86 architecture we tend to write this as:

> +#else
> +# define swap_ex NULL
> +#endif

So that the conditional structure stands out more, visually. (There might be more 
such cases in these patches as well.)

Thanks,

	Ingo
