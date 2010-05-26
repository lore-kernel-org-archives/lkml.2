Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0EZFLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:11:32 -0400
Received: from mail.perches.com ([173.55.12.10]:2436 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0EZFLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:11:31 -0400
Subject: Re: PATCH 1/3 ] SCSI: Support 1024 scatter-gather list entries and
 improve AP while FW trapped and behaviors of EHs
From: Joe Perches <joe@perches.com>
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <2D7BE052D37A48D59461AB6B775FE070@areca4e4f859d4>
References: <2D7BE052D37A48D59461AB6B775FE070@areca4e4f859d4>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 22:11:29 -0700
Message-ID: <1274850689.1845.11.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 12:55 +0800, Nick Cheng wrote:
> 1. To support 4M/1024 scatter-gather list entry, reorganize struct
> ARCMSR_CDB and struct CommandControlBlock
> 2. To modify arcmsr_probe
> 3. In order to help fix F/W issue, add the driver mode for type B card
> 4. To improve AP's behavior while F/W resets
> 5. To unify struct MessageUnit_B's members' naming in all OS drivers'
> 6. To improve error handlers, arcmsr_bus_reset(), arcmsr_abort()
> 7. To fix the arcmsr_queue_command() in bus reset stage, just let the
> commands pass down to FW, don't block
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
> ---

Hi Nick.

These patches don't use normal kernel coding style.
Can you run scripts/checkpatch.pl against them please.

You've also got continuation lines like this:

+                       printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+                       timeout, retry count down = %d \n", acb->host->host_no, 

which are defective because of the additional white space introduced
into the format string after the line continuations.

These should written as:

			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' "
			       "timeout, retry count down = %d\n",

I did submit patches to Erich Chen <support@areca.com.tw> to fix the
some of the existing problems.

http://patchwork.kernel.org/patch/75997/


