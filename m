Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1BBVh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:37:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60449
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab1BBVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:37:56 -0500
Date: Wed, 02 Feb 2011 13:38:31 -0800 (PST)
Message-Id: <20110202.133831.193702414.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich.Weigand@de.ibm.com, gcc@gcc.gnu.org,
        linux-kernel@vger.kernel.org, peter.maydell@linaro.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110202163702.GA23240@n2100.arm.linux.org.uk>
References: <201102021700.20683.arnd@arndb.de>
	<20110202163702.GA23240@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Wed, 2 Feb 2011 16:37:02 +0000

> 1. there's no way to tell GCC that the inline assembly is a load
>    instruction and therefore it needs to schedule the following
>    instructions appropriately.

Just add a dummy '"m" (pointer)' asm input argument to the inline asm
statement.  Just make sure "typeof(pointer)" has a size matching the
size of the load your are performing.

> 2. GCC will needlessly reload pointers from structures and other such
>    behaviour because it can't be told clearly what the inline assembly
>    is doing, so the inline asm needs to have a "memory" clobber.

This behavior is correct, and in fact needed.  Writing to chip registers
can trigger changes to arbitrary main memory locations.

> 3. It seems to misses out using the pre-index addressing, prefering to
>    create add/sub instructions prior to each inline assembly load/store.

Yes, this is indeed a problem.

But you really need that memory clobber there whether you like it or
not, see above.
