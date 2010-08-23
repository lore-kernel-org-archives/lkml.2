Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0HWWSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:18:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55760
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824Ab0HWWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:18:36 -0400
Date: Mon, 23 Aug 2010 15:18:53 -0700 (PDT)
Message-Id: <20100823.151853.108794567.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: arnd@arndb.de, linuxppc-dev@lists.ozlabs.org,
        torvalds@linux-foundation.org, paulus@au.ibm.com,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: 64-bit ppc rwsem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1282600885.22370.453.camel@pasglop>
References: <20100818.222925.233689776.davem@davemloft.net>
	<201008231544.16422.arnd@arndb.de>
	<1282600885.22370.453.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Aug 2010 08:01:25 +1000

> On Mon, 2010-08-23 at 15:44 +0200, Arnd Bergmann wrote:
>> 
>> * Alpha has an optimization for the uniprocessor case, where the atomic
>> instructions get turned into nonatomic additions. The spinlock based
>> version uses no locks on UP but disables interrupts for reasons I don't
>> understand (nothing running at interrupt time should try to access an rwsem).
>> Should the generic version do the same as Alpha?
> 
> I've seen drivers in the past do trylocks at interrupt time ... tho I
> agree it sucks.

Recently there was a thread where this was declared absolutely illegal.

Maybe it was allowed, or sort-of worked before, and that's why it's
accounted for with IRQ disables in some implementations.  I don't
know.
