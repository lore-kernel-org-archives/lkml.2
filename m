Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2EYDV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 23:21:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45359 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2EYDV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 23:21:28 -0400
Date: Thu, 24 May 2012 23:19:05 -0400 (EDT)
Message-Id: <20120524.231905.583157981128832060.davem@davemloft.net>
To: fenghua.yu@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/copy_user_generic: Optimize copy_user_generic with
 CPU erms feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712200771A972@ORSMSX105.amr.corp.intel.com>
References: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
	<20120524.215019.1013474044821595274.davem@davemloft.net>
	<3E5A0FA7E9CA944F9D5414FEC6C712200771A972@ORSMSX105.amr.corp.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 24 May 2012 20:19:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Fri, 25 May 2012 02:47:22 +0000

> Are you talking about memory overlap between source and destination?
> There is no overlap between these two areas in copy_user case
> because one area is in user space and another one is in kernel
> space.
> 
> In overlap case, it's software that detects overlap and sets
> backward copy. I don't see backward rep movsb performance
> degradation from my measurement.

We have been told repeatedly in the past that the string instructions,
for compatibility with the defined semantics of the instruction, only
check the lowest bits when determining source and destination overlap.

So even if bits 12 and higher in the virtual address are different, it
is the address bits below bit 12 that determine overlap.  And if this
overlap check triggers, the slow path is taken inside of the cpu.

This means that the impossibility of virtual address overlap, which
you mention, is irrelevant.  Because it is the non-virtual address
bits which the cpu uses for overlap detection.

