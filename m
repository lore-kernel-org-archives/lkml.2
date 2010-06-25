Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0FYHo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:44:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:52357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0FYHo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:44:58 -0400
Message-ID: <4C245E50.7090701@kernel.org>
Date: Fri, 25 Jun 2010 09:44:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org>
In-Reply-To: <4C23F6C1.7070603@garzik.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 07:44:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On 06/25/2010 02:22 AM, Jeff Garzik wrote:
>> @@ -4972,6 +4972,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
>>   {
>>       struct ata_port *ap = qc->ap;
>>
>> +    unexpect_irq(ap->irq_expect, false);
>> +
>>       /* XXX: New EH and old EH use different mechanisms to
>>        * synchronize EH with regular execution path.
>>        *
> 
> Unconditional use of unexpect_irq() here seems incorrect for some cases,
> such as sata_mv's use, where ata_qc_complete() is called multiple times
> rather than a singleton ata_qc_complete_multiple() call.

Indeed, sata_mv is calling ata_qc_complete() directly multiple times.
I still think calling unexpect_irq() from ata_qc_complete() is correct
as ata_qc_complete() is always a good indicator of completion events.
What's missing is a way for sata_mv to indicate that it has more
events to expect for, which under the current implementation only
sata_mv interrupt handler can determine.  I'll see if I can convert it
to use ata_qc_complete_multiple() instead.

Thanks.

-- 
tejun
