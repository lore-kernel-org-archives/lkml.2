Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0HQHWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:22:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38413
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab0HQHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:22:44 -0400
Date: Tue, 17 Aug 2010 00:23:02 -0700 (PDT)
Message-Id: <20100817.002302.193698894.davem@davemloft.net>
To: dm@chelsio.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C6A1C7C.7070004@chelsio.com>
References: <4C6A1C7C.7070004@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitris Michailidis <dm@chelsio.com>
Date: Mon, 16 Aug 2010 22:22:04 -0700

> This may be similar to the problems IA-64 had last week as a result of
> the rwsem changes, eg see commit
> 01d69a82e1d3c938da16bf55aab000672243aa24.  I see
> arch/sparc/include/asm/atomic_64.h uses ints with atomic64_t, which
> was a problem for IA-64.  Just guessing.

Well, the return types for the atomic64 routines were wrong and I
fixed that.

But our rwsem implementation on sparc64 uses a 32-bit counter so that
couldn't be the issue.  And indeed I still get the problem of tasks
being stuck on rwsems even after the atomic64 return types are fixed.

But I bet that rwsem commit 424acaaeb3a3932d64a9b4bd59df6cf72c22d8f3
introduced some kind of problem in another manner.  I'll try to dig
some more.

