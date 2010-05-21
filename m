Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0EUFyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 01:54:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41366
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab0EUFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 01:54:44 -0400
Date: Thu, 20 May 2010 22:54:54 -0700 (PDT)
Message-Id: <20100520.225454.37197037.davem@davemloft.net>
To: npiggin@suse.de
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, anton@samba.org,
       akpm@linux-foundation.org, willy@linux.intel.com,
       benh@kernel.crashing.org, paulus@samba.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100521052746.GL2516@laptop>
References: <20100519.125449.56392211.davem@davemloft.net>
	<20100519225046.GO2237@linux.vnet.ibm.com>
	<20100521052746.GL2516@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 21 May 2010 15:27:46 +1000

> Hmm, I'm missing something. David, back up a second, as far as I can see,
> with Anton's patches, atomic_read() *is* effectively just ACCESS_ONCE()
> now. Linus pointed out that header tangle is the reason not to just use
> the macro.

My bad, I was under the impression that the proposal was to remove
volatile usage and also not even do ACCESS_ONCE() in atomic_read().

And then explicitly annotate call sits that actually need the
ACCESS_ONCE() semantic.
