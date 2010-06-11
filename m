Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0FKF0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:26:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40388
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab0FKF0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:26:18 -0400
Date: Thu, 10 Jun 2010 22:26:29 -0700 (PDT)
Message-Id: <20100610.222629.116376474.davem@davemloft.net>
To: iconoclasmandheresy@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Off-by-one bug on sun4u SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimrIOLiX3m3rFsdakHn8PRhkfSHCCmYUlw6rkFz@mail.gmail.com>
References: <AANLkTimw2Hzv1WIJXehqMo4450ftRJWwefQipDM9Zxb4@mail.gmail.com>
	<20100610.173716.35035195.davem@davemloft.net>
	<AANLkTimrIOLiX3m3rFsdakHn8PRhkfSHCCmYUlw6rkFz@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Davis <iconoclasmandheresy@gmail.com>
Date: Thu, 10 Jun 2010 21:01:28 -0700

> OK... so there are no kernel data structures allocated for CPU #0
> which is not present? It is my understanding that this is not the case
> but I could be wrong. If this is true, then a chunk of kernel memory
> is wasted tor the phantom CPU #0.

There are two cases.

1) There are certain arrays which we have to allocate before we know
   how many physical cpus will be present.  There are therefore
   CONFIG_NR_CPUS of these elements allocated statically in the
   kernel image.

   These cases are extremely few and constantly decreasing over time
   as we find ways to remove these cases.

2) Everything else is only allocated for cpus actually present.

Frankly, I often run with CONFIG_NR_CPUS=2048 or some crazy value like
that and the memory wasted by static data structures is very small.

> A quick search was unable to find documentation on this quirk. Perhaps
> you could point me at some?

Feel free to write a patch which adds that documentation.
