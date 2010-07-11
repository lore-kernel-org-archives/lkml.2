Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0GKCv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:51:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab0GKCv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:51:56 -0400
Date: Sat, 10 Jul 2010 19:52:10 -0700 (PDT)
Message-Id: <20100710.195210.200371025.davem@davemloft.net>
To: joe@perches.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278562423.1712.43.camel@Joe-Laptop>
References: <20100707.174522.148565561.davem@davemloft.net>
	<20100707.181847.62350965.davem@davemloft.net>
	<1278562423.1712.43.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 07 Jul 2010 21:13:42 -0700

> On Wed, 2010-07-07 at 18:18 -0700, David Miller wrote:
>> It looks like there are just a hand-ful of cases, so maybe we can tweak
>> them by hand.  For example, in the sym53c8xx_2 driver bits we can replace
>> the NULL labels passed to sym_print_msg() with a real string and therefore
>> remove the "" case.
>> 
>> Joe, any better ideas?
> 
> You're right there are just a few cases where dev_info
> is uses as a preface for a hex_dump style display.
> 
> Maybe it'd be OK to simply add a trailing space to the
> preface and remove any leading spaces from the subsequent
> initial printks.
> 
> dev_info(dev, " ");

That might work.

The sym53c8xx_2 doesn't even need this, like I said, you could
just remove the NULL 'label' argument cases and then have that
bit cured.

Could you take a stab at this and the other scsi bits that
trigger this warning?

Thanks Joe!
