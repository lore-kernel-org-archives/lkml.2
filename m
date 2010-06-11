Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab0FKAhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:37:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60675
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038Ab0FKAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:37:05 -0400
Date: Thu, 10 Jun 2010 17:37:16 -0700 (PDT)
Message-Id: <20100610.173716.35035195.davem@davemloft.net>
To: iconoclasmandheresy@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Off-by-one bug on sun4u SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimw2Hzv1WIJXehqMo4450ftRJWwefQipDM9Zxb4@mail.gmail.com>
References: <AANLkTimw2Hzv1WIJXehqMo4450ftRJWwefQipDM9Zxb4@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Davis <iconoclasmandheresy@gmail.com>
Date: Thu, 10 Jun 2010 11:05:09 -0700

> On at least some sun4u machines, the CPU numbering starts at one not 0.
> This causes an off-by-one bug as other parts of the code assume
> zero-based numbering.
> 
> If you set max-cpus in the kernel config to the actual number of CPUs,
> the last CPU will be ignored and unused.
> This is because the CPU numbering starts at 1 but the code to check
> against max-cpus assumes a zero-based numbering.
> 
> On my computer: Sun Ultra 60 2x450mhz Ultrasparc.
> Building with max-cpus of 2 ignores the second cpu because 2 (one
> based cpu number) >= 2 (zero based max cpus)
> Rebuilding with a larger max-cpus is a workaround but non optimal.

max-cpus means "one larger than the maximum PHYSICAL cpu number", not
the number of cpus.  That's what this setting means, at least on
sparc64.
