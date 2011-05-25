Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1EYTCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:02:30 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:58116 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1EYTC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:02:28 -0400
X-ASG-Debug-ID: 1306350147-03d6a50f542c000001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDD5240.2060308@fusionio.com>
Date: Wed, 25 May 2011 21:02:24 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Parag Warudkar <parag.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:  __elv_add_request
 OOPS]
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:  __elv_add_request
 OOPS]
In-Reply-To: <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306350147
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 20:55, Linus Torvalds wrote:
> On Wed, May 25, 2011 at 11:44 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>>
>> Below patch pushes the check down to ioctl functions and hopefully should
>> cover more ioctl-on-gone-device cases by returning -ENXIO if an attempt
>> was made to submit request to a non-running device.
> 
> Can we please not duplicate complicated logic like that?
> 
> IOW, just make a helper function for it.
> 
> That said, isn't this all *exactly* what scsi_prep_state_check() is
> supposed to check for? Why isn't that called, or if called, why isn't
> it doing the right thing?

This is before you get that far, it's actually oopsing on inserting the
request on sdev->sdev_queue that is now NULL. The prep state checking
happens when sr/sd pulls the request off the queue for processing.

-- 
Jens Axboe

