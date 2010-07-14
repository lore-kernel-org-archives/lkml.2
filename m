Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0GNTCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:02:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46804
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436Ab0GNTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:02:23 -0400
Date: Wed, 14 Jul 2010 12:02:38 -0700 (PDT)
Message-Id: <20100714.120238.112604503.davem@davemloft.net>
To: tglx@linutronix.de
Cc: hch@lst.de, mingo@elte.hu, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
References: <20100708205302.GA23961@lst.de>
	<20100714151215.GA31825@lst.de>
	<alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Jul 2010 17:27:01 +0200 (CEST)

> On Wed, 14 Jul 2010, Christoph Hellwig wrote:
> 
>> Turns out this wasn't a regression introduced by a commit, but it
>> happens when CONFIG_FUNCTION_GRAPH_TRACER is enabled.  From a quick
>> look I have no idea why these would interact badly, especially as
>> CONFIG_FUNCTION_GRAPH_TRACER works fine with irq stacks if the
>> CONFIG_4KSTACKS options is set.
> 
> So you're saying, that the problem appears when
> CONFIG_FUNCTION_GRAPH_TRACER is enabled w/o being used and that it
> exists prior to your patches with irq stacks and 8k stack size, but
> works with 4k stacks. That's definitely more than odd.

Some hard-coded check somewhere assuming kernel stack pages
won't straddle a page boundary?

Just a guess...
