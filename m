Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1CWP0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:26:49 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:32938 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773Ab1CWP0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:26:48 -0400
X-ASG-Debug-ID: 1300894006-03d6a54f60c3bd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8A1133.20502@fusionio.com>
Date: Wed, 23 Mar 2011 16:26:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
References: <20110322194755.GA20122@infradead.org> <4D88FE5E.1010204@fusionio.com> <4D890EBD.1090103@fusionio.com> <20110323130137.GA10455@infradead.org>
X-ASG-Orig-Subj: Re: merging discard request in the block layer
In-Reply-To: <20110323130137.GA10455@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300894006
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58745
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-23 14:01, Christoph Hellwig wrote:
> On Tue, Mar 22, 2011 at 10:03:57PM +0100, Jens Axboe wrote:
>>> That would seem to indicate a bug in the merging logic instead.
>>
>> What kind of max discard size does you device have? If the max discard
>> size is smaller than the regular request size, this could help.
> 
> It's a SCSI device, so the max discard size is a lot larger:
> 
> # cat /sys/block/sda/queue/max_sectors_kb
> 512
> # cat /sys/block/sda/queue/max_hw_sectors_kb 
> 32767
> # cat /sys/block/sda/queue/discard_max_bytes 
> 4294966784

I'll try and throw a synthetic test at it that produces a slew of
discard merging and see what happens.

-- 
Jens Axboe

