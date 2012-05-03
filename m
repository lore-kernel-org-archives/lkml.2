Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab2ECE0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:26:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:38218 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2ECE0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:26:32 -0400
Message-ID: <1336019173.2653.12.camel@pasglop>
Subject: Re: [PATCH] powerpc: use local var instead of
 local_paca->irq_happened directly in __check_irq_replay
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 14:26:13 +1000
In-Reply-To: <4FA1EE2C.6050201@gmail.com>
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>
	 <4FA1EE2C.6050201@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 10:32 +0800, Wang Sheng-Hui wrote:
> > It should not as __check_irq_replay() should always be called
> > with interrupts hard disabled... Do you see any code path
> > where that is not the case ?
> 
> Since __check_irq_replay() should always be called with interrupts
> hard disabled, I think it's harmless to use local var here.

No, that would be papering over the real problem. All oprofile does is
trigger perfmon interrupts (which act as some kind of NMI when
soft-disabled but should be masked by MSR:EE when hard disabled).

So there's a deeper issue here that we need to understand before we can
propose a fix. IE. It should not have happened.

Cheers,
Ben.


