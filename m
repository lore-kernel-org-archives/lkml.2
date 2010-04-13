Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0DMIqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:46:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46030
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab0DMIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:46:28 -0400
Date: Tue, 13 Apr 2010 01:46:31 -0700 (PDT)
Message-Id: <20100413.014631.45686537.davem@davemloft.net>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respin local_irq_*_nmi() stuff.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271147834.4807.980.camel@twins>
References: <1271144938.4807.925.camel@twins>
	<20100413.005640.48990319.davem@davemloft.net>
	<1271147834.4807.980.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 13 Apr 2010 10:37:14 +0200

> Hmm, it also assumes %pil is never anything other than 0,
> PIL_NORMAL_MAX, PIL_NMI, because if:
> 
>   (%pil & 1) && (%pil != PIL_NMI)
> 
> then you'll end up disabling NMIs. Could something like that ever
> happen?

The only values we ever program into the %pil are 0, PIL_NORMAL_MAX
and PIL_NMI

Since PIL_NMI is the largest %pil value and all bits are set in it
(0xf), it doesn't matter what PIL_NORMAL_MAX actually is.

Yes this all deserves a comment, I'll add one, thanks for pointing
that out.
