Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2EINVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:21:09 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56453 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab2EINVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:21:07 -0400
Message-ID: <4FAA6F38.6080801@fastmail.fm>
Date: Wed, 09 May 2012 15:20:56 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com> <4FAA02DA.3000201@gmail.com> <20120509061956.GA12329@gmail.com> <20120509082527.GA10674@infradead.org> <20120509093016.GA12754@gmail.com> <20120509111243.GB29593@infradead.org> <20120509124804.GA13329@gmail.com>
In-Reply-To: <20120509124804.GA13329@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 02:48 PM, Zheng Liu wrote:
> On Wed, May 09, 2012 at 07:12:43AM -0400, Christoph Hellwig wrote:
>> On Wed, May 09, 2012 at 05:30:16PM +0800, Zheng Liu wrote:
>>> IMHO, FUA provides a solution that we can get better performance in write
>>> cache mode when we do many flush operations.  If I set the disk to write
>>> through mode, I won't get this benefit.  Am I missing something?
>>
>> If you set the disk to write through mode you never have to flush the
>> cache.  So as soonas your number of flushes gets close to the number of
>> writes it tends to be a clear win - for ATA the tradeoff is even more in
>> favour of write through because the flush command can't be queued yetin
>> commonly available standards versions.  So if you have a workload that
>> basically needs to flush out every write you win - if you have workloads
>> where you have a lot more writes than cache flushes write back mode
>> wins.
>
> Thanks for your explanation.  It seems that there still has a problem.
> If I set the disk to write through mode, I need to modify my application
> to remove all of flush/sync operations.  It is unacceptable for us.

Why? You still need to flush the linux page cache. Just the disk cache 
does not need to be flushed anymore. So changing the application would 
be the wrong thing to do.


Cheers,
Bernd
