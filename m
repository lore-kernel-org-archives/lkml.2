Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab0ISEXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:23:50 -0400
Received: from mail-da-3.dns-solutions.net ([69.12.112.3]:54016 "HELO
	mail-da-3.dns-solutions.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750848Ab0ISEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:23:49 -0400
From: "Joshua Hintze" <joshh@imsar.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
References: <00d401cb55f7$33a78210$9af68630$@com>	<20100917154732.330c4b1b@varda>	<010901cb5754$ae6735a0$0b35a0e0$@com> <20100919015903.49606426@lxorguk.ukuu.org.uk>
In-Reply-To: <20100919015903.49606426@lxorguk.ukuu.org.uk>
Subject: RE: PATA IDE is slower in newer versions of kernel
Date: Sat, 18 Sep 2010 22:23:41 -0600
Message-ID: <000301cb57b2$716041c0$5420c540$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: ActXktm7RJQgCKpqT86GOLamN/R4tQAHprgA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the input. The reason why I'm using the old drivers/ide is
because I'm using a TI Davinci ARM processor in an embedded system. They
wrote a PalmChip driver for the older IDE interface and I don't think they
have anything yet for the drivers/ata (out of curiousity is the newer
drivers/ata the reason why PATA devices show up as /dev/sda in newer
kernels?)

After spending most of the day today adding printks and learning about the
old ide driver I'm pretty much convinced that the IDE driver is working
fine. The long delays are actually between block driver request queues. In
the 2.6.10 kernel the time between block writes is less than 1 ms, where as
the 2.6.32 that TI has blessed takes 8+ ms between blocks that are pushed to
the IDE interface.

Like I mentioned earlier I tried changing the I/O scheduler to Noop and as
for the elevator. Anything else I should look to so I get blocks sent out
faster?

Thanks


-----Original Message-----
From: linux-ide-owner@vger.kernel.org
[mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Alan Cox
Sent: Saturday, September 18, 2010 6:59 PM
To: Joshua Hintze
Cc: linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
Subject: Re: PATA IDE is slower in newer versions of kernel

> I'm dedicated to continue working on the problem, I just need to advice
from the linux community. I've tried different I/O schedulers such as noop
and anticipatory and I'm studying the ide-dma code but still lost to where
this is happening.

drivers/ide is pretty much obsolete - so what you are seeing is doubly
odd. Most stuff now is using the newer drivers/ata code which can support
SATA, NCQ etc unlike the old codebase.

One thing to check would be whether using the drivers/ata code shows the
same problem.

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

No virus found in this incoming message.
Checked by AVG - www.avg.com 
Version: 9.0.851 / Virus Database: 271.1.1/3143 - Release Date: 09/18/10
00:34:00

