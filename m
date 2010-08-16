Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0HPTnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:43:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39759
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621Ab0HPTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:43:42 -0400
Date: Mon, 16 Aug 2010 12:44:00 -0700 (PDT)
Message-Id: <20100816.124400.42792595.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net, mingo@elte.hu,
        peterz@infradead.org
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1281981301.3268.110.camel@gandalf.stny.rr.com>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	<1281979893.2524.54.camel@edumazet-laptop>
	<1281981301.3268.110.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 16 Aug 2010 13:55:01 -0400

> Please tell me what prevents an interrupt going off after we grab the
> xt_info_wrlock(cpu) in get_counters().

He's only accessing the per-cpu counter locks of other cpus.

The per-cpu lock is only locally accessed by a cpu in software
interrupt context.

That is why his transformation is legal.

Lockdep simply hasn't been informed of this invariant and has
to assume the worst.

