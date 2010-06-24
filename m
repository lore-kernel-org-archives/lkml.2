Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0FXK12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:27:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0FXK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:27:27 -0400
Date: Thu, 24 Jun 2010 12:27:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624102725.GA578@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
 <1277361352.1875.838.camel@laptop>
 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
 <1277362073.1875.839.camel@laptop>
 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
 <1277362680.1875.845.camel@laptop>
 <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
 <1277363993.1875.847.camel@laptop>
 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277364727.1875.857.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> True, but I really don't like the softirq thing, and I really don't care
> about !APIC machines, I probably couldn't buy one if I wanted to and its
> not like we have good MCE support for them now, so who cares.

In theory you can run a machine with good MCE support in non APIC single
CPU mode. It wouldn't make much sense, but you could do it.

Anyways, I don't think we need a lot of effort to handle this case,
but it would be better to not explicitely break it either.

That's why the timer fallback in the original code was fine, this 
basically never happens and even if there is a 5s delay from tickless
that's fine.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
