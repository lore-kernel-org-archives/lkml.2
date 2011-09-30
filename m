Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1I3VVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:21:05 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:52942 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1I3VVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:21:02 -0400
X-ASG-Debug-ID: 1317417660-01de285e7bea5d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E8632BB.20700@fusionio.com>
Date: Fri, 30 Sep 2011 15:20:59 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <4E69D519.8070802@fusionio.com> <20110930133323.GA2730@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
In-Reply-To: <20110930133323.GA2730@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1317417660
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.76034
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-30 07:33, Christoph Hellwig wrote:
> On Fri, Sep 09, 2011 at 10:58:01AM +0200, Jens Axboe wrote:
>>>  - handling of REQ_FUA / REQ_FLUSH requests is completely broken.
>>>    There is a weird barrier flag to mtip_hw_submit_io which set the
>>>    hwardware FUA bit if the FLUSH bit is set on a request.
>>>    Please take a look at how this should be handled, the
>>>    Documentation/block/writeback_cache_control.txt file is the canonical
>>>    resource.  Implementing your driver at the make_request layer
>>>    unfortunately means you will have to do all the hard work yourself.
>>
>> I noticed both of these flush/fua problems too and have fixed them up.
> 
> I sitll can't find anything doing that in your tree while all kinds of
> other patches are in.  In fact I can't find a place that sends
> ATA_CMD_FLUSH/ATA_CMD_FLUSH_EXT commands, not the required queue
> draining for it.
> 
> And this stuff really makes me nervous - we get a driver for a new,
> expensive high end device and there seems absolutely no concern for
> data integrity, or testing of it.

I'm away from home, so changes have been coming in through the laptop.
But don't worry about the driver, it's sort-of in a staging position at
the moment. Before Micron has resolved the issues around queueing etc,
it's not going to be merged into mainline.

> Or does the device not even have a volatile cache at all, and we could
> just remove the FUA code?  In this case it should be clearly documented
> in the driver.

See reply from Micron folks, there's no write back cache currently.

-- 
Jens Axboe

