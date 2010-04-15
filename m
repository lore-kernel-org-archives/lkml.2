Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0DOGzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:55:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54163
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712Ab0DOGzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:55:54 -0400
Date: Wed, 14 Apr 2010 23:55:57 -0700 (PDT)
Message-Id: <20100414.235557.123118153.davem@davemloft.net>
To: mingo@elte.hu
Cc: sfr@canb.auug.org.au, tglx@linutronix.de, hpa@zytor.com,
       peterz@infradead.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final
 tree (tip related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100415064940.GA9240@elte.hu>
References: <20100415161214.04637496.sfr@canb.auug.org.au>
	<20100415064940.GA9240@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Apr 2010 08:49:40 +0200

> Btw., WARN_ON trapping on PowerPC is clearly a PowerPC bug - there's a good 
> reason we have WARN_ON versus BUG_ON - it should be fixed.

I disagree, an implementation should be allowed to use the most
efficient implementation possible for both interfaces.

I would be using traps for both on sparc64 if that were really
feasible on sparc64 (and actually with gcc-4.5's "asm goto" it might
actually be now)

The WARN and BUG macros, when implemented without traps, have serious
implications for overall code size and register pressure.
