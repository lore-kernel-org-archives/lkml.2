Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0FQITo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:54405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab0FQITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:19:42 -0400
Message-ID: <4C19DA64.8000409@kernel.org>
Date: Thu, 17 Jun 2010 10:18:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org>	<1276443098-20653-10-git-send-email-tj@kernel.org> <20100616204854.4b036f87@infradead.org>
In-Reply-To: <20100616204854.4b036f87@infradead.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 08:18:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 06/17/2010 05:48 AM, Arjan van de Ven wrote:
> On Sun, 13 Jun 2010 17:31:35 +0200
> Tejun Heo <tj@kernel.org> wrote:
>> + */
>> +void expect_irq(struct irq_expect *exp)
> 
> I would like to suggest an (optional) argument to this with a duration
> within which to expect an interrupt....
> 
> that way in the backend we can plumb this also into the idle handler
> for C state selection...

Hmmm.... oh, I see.  Wouldn't it be much better to use moving avg of
IRQ durations instead of letting the driver specify it?  Drivers are
most likely to just hard code it and It's never gonna be accurate.

Thanks.

-- 
tejun
