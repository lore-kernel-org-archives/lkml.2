Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1JLTCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:02:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46216 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1JLTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:02:11 -0400
Date: Wed, 12 Oct 2011 15:02:07 -0400 (EDT)
Message-Id: <20111012.150207.1100668688848833225.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cy82c693: fix PCI device selection
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110121652.10495.bzolnier@gmail.com>
References: <201110111937.32501.bzolnier@gmail.com>
	<20111011.152040.662786307819949300.davem@davemloft.net>
	<201110121652.10495.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 12 Oct 2011 12:02:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 12 Oct 2011 16:52:10 +0200

> David Miller wrote:
> 
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Tue, 11 Oct 2011 19:37:32 +0200
>> 
>> > While at it remove redundant pci_get_slot() call as cy82c693_init_one()
>> > already takes care of keeping the reference on the second port's PCI
>> > device.
>> 
>> Please do not submit unrelated changes with a bug fix, and as IDE is
>> in long-term maintainence I would not accept a risky refinement like
>> this anyways.
> 
> Removed code is just bogus, we cannot fail in ->set_pio_mode method.
> 
> Please take a look at the code:
>  
> -	/* select primary or secondary channel */
> -	if (hwif->index > 0) {  /* drive is on the secondary channel */
> -		dev = pci_get_slot(dev->bus, dev->devfn+1);
> -		if (!dev) {
> -			printk(KERN_ERR "%s: tune_drive: "
> -				"Cannot find secondary interface!\n",
> -				drive->name);
> -			return;
> -		}
> -	}
> 
> Please apply the patch,

Sorry, I will not do that, please respin the patch with the unrelated
pieces removed.  I don't care how obvious it is to you.

The IDE layer is not a place for refinements or simplifications any
longer, I'm sorry if that isn't clear to you.


