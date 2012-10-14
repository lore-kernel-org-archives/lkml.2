Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2JNQRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:17:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56561 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JNQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:17:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6865"; a="250172766"
Message-ID: <0861696a510e833409520496cfe84d3c.squirrel@www.codeaurora.org>
In-Reply-To: <CAFEEs1=zU88dwY1K0+Q9PxdqyOpsNMtj6mZ3YkwebPugofyEEw@mail.gmail.com>
References: <1349192378-1676-1-git-send-email-kdorfman@codeaurora.org>
    <1349192378-1676-2-git-send-email-kdorfman@codeaurora.org>
    <CAFEEs1=zU88dwY1K0+Q9PxdqyOpsNMtj6mZ3YkwebPugofyEEw@mail.gmail.com>
Date: Sun, 14 Oct 2012 18:17:29 +0200 (IST)
Subject: Re: [PATCH] mmc: fix async request mechanism for sequential read 
     scenarios
From: "Konstantin Dorfman" <kdorfman@codeaurora.org>
To: "Per Forlin" <per.lkml@gmail.com>
Cc: "Konstantin Dorfman" <kdorfman@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>, per.forlin@stericsson.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 17:19:01 +0200, Per Forlin <per.lkml@gmail.com>
wrote:
Hello Per,

>I would like to start with some basic comments.
>
>1. Is this read sequential issue specific to MMC?
>2. Or is it common with all other block-drivers that gets data from
>the block layer (SCSI/SATA etc) ?
>If (#2) can the issue be addressed inside the block layer instead?
>
>BR
>Per
This issue specific to MMC, others block drivers probably not using
MMC mechanism for async request (or have more kernel threads for
processing incoming blk requests).
I think, since MMC actively fetches requests from block layer queue,
the solution has nothing to do with block layer context.

>
>On Tue, Oct 2, 2012 at 5:39 PM, Konstantin Dorfman
><kdorfman@codeaurora.org> wrote:
>> The main assumption of the async request design is that the file
>> system adds block requests to the block device queue asynchronously
>> without waiting for completion (see the Rationale section of
>> https://wiki.linaro.org/WorkingGroups/Kernel/Specs
>> /StoragePerfMMC-async-req).
>>
>> We found out that in case of sequential read operations this is not
>> the case, due to the read ahead mechanism.
>Would it be possible to improve this mechanism to achieve the same result?
>Allow an outstanding read ahead request on top of the current ongoing one.
>

I need to look on this mechanism,  but from first glance such
behaviour may be result of libc/vfs/fs decisions and too complex
comparing to the patch we are talking about.


-- 
Konstantin Dorfman,
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

