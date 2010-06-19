Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0FSIfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:35:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0FSIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:35:09 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-10-git-send-email-tj@kernel.org>
	<20100616204854.4b036f87@infradead.org>
Date: Sat, 19 Jun 2010 10:35:02 +0200
In-Reply-To: <20100616204854.4b036f87@infradead.org> (Arjan van de Ven's
	message of "Wed, 16 Jun 2010 20:48:54 -0700")
Message-ID: <87zkyro1xl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Sun, 13 Jun 2010 17:31:35 +0200
> Tejun Heo <tj@kernel.org> wrote:
>> + */
>> +void expect_irq(struct irq_expect *exp)
>
>
> I would like to suggest an (optional) argument to this with a duration
> within which to expect an interrupt....
>
> that way in the backend we can plumb this also into the idle handler
> for C state selection...

I'm not sure it's really that useful to power optimize
the lost interrupts polling case. It's just a last resort
fallback anyways and will be always less power efficient
because there will be unnecessary polls.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
