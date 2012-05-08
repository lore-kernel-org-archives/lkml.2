Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2EHHqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:46:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47328 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2EHHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:46:43 -0400
X-AuditID: 9c93016f-b7c79ae0000006b3-40-4fa8cf5ec530
Message-ID: <4FA8CF5E.1070202@kernel.org>
Date: Tue, 08 May 2012 16:46:38 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel.mmc,gmane.linux.file-systems,gmane.linux.ports.arm.omap,gmane.linux.kernel
To: Venkatraman S <svenkatr@ti.com>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCHv2 00/16] [FS, MM, block, MMC]: eMMC High Priority Interrupt
 Feature
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:22 PM, Venkatraman S wrote:

> Standard eMMC (Embedded MultiMedia Card) specification expects to execute
> one request at a time. If some requests are more important than others, they
> can't be aborted while the flash procedure is in progress.
> 
> New versions of the eMMC standard (4.41 and above) specfies a feature 
> called High Priority Interrupt (HPI). This enables an ongoing transaction
> to be aborted using a special command (HPI command) so that the card is ready
> to receive new commands immediately. Then the new request can be submitted
> to the card, and optionally the interrupted command can be resumed again.
> 
> Some restrictions exist on when and how the command can be used. For example,
> only write and write-like commands (ERASE) can be preempted, and the urgent
> request must be a read.
> 
> In order to support this in software,
> a) At the top level, some policy decisions have to be made on what is
> worth preempting for.
> 	This implementation uses the demand paging requests and swap
> read requests as potential reads worth preempting an ongoing long write.
> 	This is expected to provide improved responsiveness for smarphones
> with multitasking capabilities - example would be launch a email application
> while a video capture session (which causes long writes) is ongoing.


Do you have a number to prove it's really big effective?

What I have a concern is when we got low memory situation.
Then, writing speed for page reclaim is important for response.
If we allow read preempt write and write is delay, it means read path takes longer time to
get a empty buffer pages in reclaim. In such case, it couldn't be good.


-- 
Kind regards,
Minchan Kim
