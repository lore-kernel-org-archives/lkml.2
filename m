Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1I3Tpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:45:31 -0400
Received: from masquerade.micron.com ([137.201.242.130]:1867 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab1I3Tp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:45:28 -0400
Message-ID: <4E861C3C.8020506@micron.com>
Date: Fri, 30 Sep 2011 13:45:00 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <jaxboe@fusionio.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <4E69D519.8070802@fusionio.com> <20110930133323.GA2730@infradead.org>
In-Reply-To: <20110930133323.GA2730@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--12.172200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/2011 7:33 AM, Christoph Hellwig wrote:
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
> 
> Or does the device not even have a volatile cache at all, and we could
> just remove the FUA code?  In this case it should be clearly documented
> in the driver.

At present there is no write back cache in the device, making
appropriate changes in the code.

-- 
Regards,
Asai Thambi
