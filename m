Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1ELUoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:44:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43163 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab1ELUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:44:05 -0400
Date: Thu, 12 May 2011 16:43:19 -0400 (EDT)
Message-Id: <20110512.164319.1770509419224900253.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: eranian@google.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 13:43:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 13:31:37 -0700

> That said, I have considered just reverting the thing that makes
> kptr_restrict be 1 by default. I do like the security implications of
> restricting visibility into kernel pointers, but I also think that
> security rules that make the system less usable are dubious. So I
> dunno.

We don't have any firewalling or SELINUX rules installed by default,
even if those features are enabled in the kernel.  Userspace asks for
it.

Many people would claim that use of such things are "essential" these
days.

I don't see a good reason to handle kptr_restrict any differently.
