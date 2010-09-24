Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0IXEsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:48:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38081
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0IXEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:48:36 -0400
Date: Thu, 23 Sep 2010 21:48:56 -0700 (PDT)
Message-Id: <20100923.214856.43029525.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100922231219.GH19804@ZenIV.linux.org.uk>
References: <20100922204323.GG19804@ZenIV.linux.org.uk>
	<20100922.141514.232744402.davem@davemloft.net>
	<20100922231219.GH19804@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 23 Sep 2010 00:12:19 +0100

> OK... sparc32 question: just what the !@#!@# happens if sun4c_rett_stackchk
> find (%fp & 7) != 0?  We go to ret_trap_user_stack_is_bolixed, which
> tries to page in the underlying page.  OK, suppose it's already there and
> readable; we return without doing anything - and go to signal_p.  Which finds
> itself with nothing to do, and %fp is *still* buggered.  Spin ad infinitum?
> srmmu_rett_stackchk will do the same, BTW...

That's a bug.

Likely all of the window_*_fault() routines should force a SIGILL when
the stack is mis-aligned.
