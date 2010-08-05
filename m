Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab0HEJVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:21:05 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:58995 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859Ab0HEJVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:21:01 -0400
X-ASG-Debug-ID: 1281000057-1ea400000000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5A8273.2010803@fusionio.com>
Date: Thu, 5 Aug 2010 11:20:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH RESEND block#for-2.6.36] block_dev: always serialize 
 exclusive open attempts
Subject: Re: [PATCH RESEND block#for-2.6.36] block_dev: always serialize 
 exclusive open attempts
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera> <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com> <4C56F30D.3020304@kernel.org> <4C598E6B.7050405@gmail.com> <4C5A7E33.3060101@fusionio.com> <20100805091704.GA1772@arch.tripp.de>
In-Reply-To: <20100805091704.GA1772@arch.tripp.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281000058
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-05 11:17, Markus Trippelsdorf wrote:
> On Thu, Aug 05, 2010 at 11:02:43AM +0200, Jens Axboe wrote:
>> On 2010-08-04 17:59, Tejun Heo wrote:
>>> bd_prepare_to_claim() incorrectly allowed multiple attempts for
>>> exclusive open to progress in parallel if the attempting holders are
>>> identical.  This triggered BUG_ON() as reported in the following bug.
>>>
>>>   https://bugzilla.kernel.org/show_bug.cgi?id=16393
>>>
>>> __bd_abort_claiming() is used to finish claiming blocks and doesn't
>>> work if multiple openers are inside a claiming block.  Allowing
>>> multiple parallel open attempts to continue doesn't gain anything as
>>> those are serialized down in the call chain anyway.  Fix it by always
>>> allowing only single open attempt in a claiming block.
>>>
>>> This problem can easily be reproduced by adding a delay after
>>> bd_prepare_to_claim() and attempting to mount two partitions of a
>>> disk.
>>>
>>> stable: only applicable to v2.6.35
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
>>> Cc: stable@kernel.org
>>
>> Thanks Tejun, applied.
> 
> It's already in mainline:
> e75aa85892b2ee78c79edac720868cbef16e62eb

Irk, had not noticed yet, my for-2.6.36 branch isn't fully merged
up yet. Thanks for the heads-up.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
