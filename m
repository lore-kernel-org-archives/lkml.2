Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0IQNrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:47:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59965 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0IQNrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Z6CUi7PiKHMfGJNo2CKCq/+U+Qgf26vh+LRhANTsjqMhnnFJyJ33igpY+JmrTBGVgz
         2TXVQzZ8atF++a45g3IF8eMyf+DDvCSF9qf/4/crGEXkny6lbjA2KZZZ198yHWd5hZfT
         OiSUSRwsTvtO5v2RC5ES01nsatAC1e6B1niKg=
Date: Fri, 17 Sep 2010 15:47:32 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Joshua Hintze" <joshh@imsar.com>
Cc: <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: PATA IDE is slower in newer versions of kernel
Message-ID: <20100917154732.330c4b1b@varda>
In-Reply-To: <00d401cb55f7$33a78210$9af68630$@com>
References: <00d401cb55f7$33a78210$9af68630$@com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 16 Sep 2010 17:30:51 -0600
"Joshua Hintze" <joshh@imsar.com> escribió:

 [ Just CC linux-ide ]

> Hello, 
> 
> I've been digging into this for a couple weeks now. I have an embedded board
> that runs Linux Kernel 2.6.10 that is connected to a SSD over a PATA
> connection. Data is transferred using UDMA4 speeds and I get a nice
> sustained write speed of about 20 MBps which is adequate for us. 
> 
> I have recently taken the plunge to update to a newer version of the kernel
> starting at 2.6.32 (also tried 2.6.33) and what I am seeing writes speeds
> drop to about 18 MBps peak with large jumps going from 8 MBps->16 MBs for
> sustained throughput.
> 
> I decided to read up on the ATA specification and I connected a logic
> analyzer to the PATA bus and here is what is happening...after a large chunk
> of data is written to the device, instead of the device pausing the transfer
> by asserting DDMARDY it actual initiates a device data-out termination by
> pulling DMARQ low.
> 
> The old kernel 2.6.10 responds to this by strobing the STOP line 8 times
> within 800uS and the device releases DMARQ shortly afterwards. On the newer
> kernels the strobing of the STOP line takes near 8mS of time. Since the hard
> drive only release DMARQ after this 8 pulse strobe I believe this is the
> cause of the slower write speeds on the newer kernels. This whole process
> happens thousands of times when writing megs of data. So those extra 7mS
> begin to add up fast.
> 
> My problem is I've been digging through the ide.c/ide-dma.c and other code
> but I'm not exactly sure where the code would jump to upon a device
> initiated termination on a data-out dma transfer.
> 
> My guess is ide_dma_intr(...). Is this correct?
> 
> Any other areas I could look at?
> 
> Thanks in advance.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
