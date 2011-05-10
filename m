Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1EJUjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:39:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1EJUjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:39:16 -0400
Date: Tue, 10 May 2011 22:39:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: Support for SGI UV2 hub chip
Message-ID: <20110510203905.GD21903@elte.hu>
References: <20110510191110.GA18052@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510191110.GA18052@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> +				/*
> +				 * Our retries may be blocked by all destination
> +				 * swack resources being consumed, and a timeout
> +				 * pending.  In that case hardware returns the
> +				 * ERROR that looks like a destination timeout.
> +				 */
> +				if (cycles_2_us(ttime - bcp->send_message) <
> +								timeout_us) {
> +					bcp->conseccompletes = 0;
> +					return FLUSH_RETRY_PLUGGED;
> +				}

This code is sick. Symptom: too long lines. Illness: it's too complex.

checkpatch warned you but you applied the wrong cure: you only addressed the 
symptom and broke the lines in an ugly way.

You need to pick another cure. One of the many options:

  - eliminate many repetitive strings
  - reduce indentation by the introduction of helper inlines
  - sensible shortening of variable/field/definition names

... applies to this particular case and will solve the problem.

Note that there's other, similar incidents in this patch, please address all of 
them.

Thanks,

	Ingo
