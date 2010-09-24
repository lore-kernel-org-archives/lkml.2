Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0IXJM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:12:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab0IXJMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:12:55 -0400
Message-ID: <4C9C6B7D.1060805@kernel.dk>
Date: Fri, 24 Sep 2010 11:12:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: dgilbert@interlog.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Joel Becker <joel.becker@oracle.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
  prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com> <4C9C2039.8050903@teksavvy.com>
In-Reply-To: <4C9C2039.8050903@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-24 05:51, Mark Lord wrote:
> On 10-09-23 10:53 PM, Mark Lord wrote:
>> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>>> Mark,
>>> If you issued the SG_IO ioctl with a timeout of at
>>> least 66 minutes (expressed in milliseconds) then
>>> it looks like ata_scsi_queuecmd() has a problem.
>> ..
>>
>> Mmm.. more like blk_execute_rq() perhaps.
>> That's where the wait_for_completion(&wait) call is at.
>>
>> Perhaps I should change it to wait in smaller increments,
>> so that the lockup detection doesn't trigger on it..
> ..
> 
> This patch (below) seems to work.
> 
> Does this look kosher enough for me to roll it up
> as a proper patch submission?   Jens?  Joel?

Ideally it would be nice to just pass the info down that it should not
complain, since waiting > 120 seconds (or whatever the timeout is set
to) is expected by the caller in some cases.

But your patch is simple enough and it gets the job done. I will queue
it up for .37 if you send a properly formatted and signed-off-by
version.

-- 
Jens Axboe

