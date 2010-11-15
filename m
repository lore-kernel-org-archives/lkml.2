Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0KOHDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:03:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51158 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0KOHDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:03:14 -0500
Date: Mon, 15 Nov 2010 08:02:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>, Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
Message-ID: <20101115070254.GA25243@elte.hu>
References: <20101111214546.4e573cad@queued.net>
 <reply-olpc-3-v2@mdm.bga.com>
 <20101112002704.50c629e2@queued.net>
 <20101114095013.GB24206@elte.hu>
 <4CE0B54E.6000101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE0B54E.6000101@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> What?  What is wrong with static variables in functions?  It really doesn't seem 
> to be a good idea to make them file-scope if they don't need to be.

They are very easy to overlook and mix up with regular stack variables and i've seen 
(and introduced myself) a number of bugs due to them.

They also often are used in buggy ways (with SMP not taken into consideration), so 
overlooking them during review compounds their negative effects. Putting them in 
front of the function isnt a big deal in exchange.

There are people who never overlook them (like yourself), but my brain is wired up 
differently.

Thanks,

	Ingo
