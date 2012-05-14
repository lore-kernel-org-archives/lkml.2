Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2ENHzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:55:20 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56575 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2ENHzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:55:17 -0400
X-AuditID: 9c93016f-b7cecae000000e00-ac-4fb0ba60b0e3
Message-ID: <4FB0BA7B.1050200@kernel.org>
Date: Mon, 14 May 2012 16:55:39 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel.mmc,gmane.linux.file-systems,gmane.linux.ports.arm.omap,gmane.linux.kernel
To: mani <manishrma@gmail.com>
CC: linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/16] [FS, MM, block, MMC]: eMMC High Priority Interrupt
 Feature
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com> <4FA8CF5E.1070202@kernel.org> <CANfBPZ-d-0FqY8Gruv+KDNoL3+FoQ68JEnxya5PydhY80x8yhA@mail.gmail.com> <4FA9BE10.1030007@kernel.org> <CAB+TZU-r6aYn8WRZjZ0DojxMTMoc5MSx7c93W0pAad1coscPwQ@mail.gmail.com>
In-Reply-To: <CAB+TZU-r6aYn8WRZjZ0DojxMTMoc5MSx7c93W0pAad1coscPwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 04:43 PM, mani wrote:

> Dear Kim,
> 
> I have a query here ..
> 
> 
>     My point is that it would be better for read to not preempt
>     write-for-page_reclaim.
>     And we can identify it by PG_reclaim. You can get the idea.
> 
> I think If there is no page available then no read will proceed.

> When read request comes it reclaim the pages (starts the write if

> syncable pages ) and get back after reclaiming the pages.
> Only then a read request will come to the MMC subsystem.

> And i think the reclaim algorithm will reclaim some substantial amount

> of pages at a time instead of a single page.
> So if we get few pages during the reclamation so there will be no
> problem in halting the another write ops for proceeding the reads ?
> 
> Can we think of a scenario when we are reclaiming the pages and write
> ops is going on where as a high priority read for the interrupt handler
> is pending ?
> 
> Please correct me if i am wrong.


For example, System can have lots of order-0 pages but little order-big pages.
In this case, for getting big contiguos memory, reclaimer should write out
dirty pages while it can handle order-0 page read request.


> 
> Thanks & Regards
> Manish



-- 
Kind regards,
Minchan Kim
