Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0FZIhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 04:37:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0FZIhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 04:37:01 -0400
Subject: Re: [RFC][PATCH] irq_work -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, davem <davem@davemloft.net>,
       paulus <paulus@samba.org>
In-Reply-To: <20100625222953.GE13421@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop> <1277490625.1875.986.camel@laptop>
	 <20100625193031.GD13421@basil.fritz.box> <1277494784.1875.989.camel@laptop>
	 <20100625222953.GE13421@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 26 Jun 2010 10:36:45 +0200
Message-ID: <1277541405.1875.993.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 00:29 +0200, Andi Kleen wrote:

> Yes it would be good to separate that, because I doubt other users
> will require similar hacks.

You're such a constructive critic..

I would think every NMI user would need them since NMI can interrupt at
any time, and if you have a limited number of irq_work structs (like 1
per cpu) you'll end up with wanting to enqueue an already enqueued one
at some point.
