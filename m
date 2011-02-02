Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1BBV7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:59:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51805
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab1BBV7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:59:19 -0500
Date: Wed, 02 Feb 2011 13:59:54 -0800 (PST)
Message-Id: <20110202.135954.189712480.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich.Weigand@de.ibm.com, gcc@gcc.gnu.org,
        linux-kernel@vger.kernel.org, peter.maydell@linaro.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110202214522.GG31043@n2100.arm.linux.org.uk>
References: <20110202163702.GA23240@n2100.arm.linux.org.uk>
	<20110202.133831.193702414.davem@davemloft.net>
	<20110202214522.GG31043@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Wed, 2 Feb 2011 21:45:22 +0000

> On Wed, Feb 02, 2011 at 01:38:31PM -0800, David Miller wrote:
>> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Date: Wed, 2 Feb 2011 16:37:02 +0000
>> 
>> > 1. there's no way to tell GCC that the inline assembly is a load
>> >    instruction and therefore it needs to schedule the following
>> >    instructions appropriately.
>> 
>> Just add a dummy '"m" (pointer)' asm input argument to the inline asm
>> statement.  Just make sure "typeof(pointer)" has a size matching the
>> size of the load your are performing.
> 
> That involves this problematical cast from a packed struct pointer to
> an unsigned long pointer, which according to the C standard and GCC
> folk is undefined.

It's alignment may be undefined, but it's size definitely is well
defined and that's what matters here.

> Practice over the last 15 years on ARM has also shown that this is not
> necessary.

Sorry oh big super man, little ole' me is only a kernel newbie.
