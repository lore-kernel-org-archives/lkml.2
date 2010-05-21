Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab0EUGLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:11:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932854Ab0EUGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:10:28 -0400
Date: Thu, 20 May 2010 23:10:37 -0700 (PDT)
Message-Id: <20100520.231037.200798708.davem@davemloft.net>
To: npiggin@suse.de
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, anton@samba.org,
       akpm@linux-foundation.org, willy@linux.intel.com,
       benh@kernel.crashing.org, paulus@samba.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100521060600.GM2516@laptop>
References: <20100521052746.GL2516@laptop>
	<20100520.225454.37197037.davem@davemloft.net>
	<20100521060600.GM2516@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 21 May 2010 16:06:00 +1000

> Actually, I bet we have a lot of bugs there with loading integers and
> pointers atomically, where the code assumes the loaded value will not
> be reloaded by the compiler, because it is an easy thing to assume.

Alexey Kuznetsov was aware of this problem 8+ years ago when we were
first adding fine-grained locking the the networking.

> atomic_read_light could be useful though, for sure.

I definitely think so. And every usage of it should have a big fat
comment right next to it explaining how it's usage is valid in that
spot :-)
