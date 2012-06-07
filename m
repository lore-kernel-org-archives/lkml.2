Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2FGCpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:45:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51613 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FGCpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:45:52 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-0c-4fd015de7fe3
Message-ID: <4FD015FE.7070906@kernel.org>
Date: Thu, 07 Jun 2012 11:46:22 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] zram: clean up handle
References: <1338881031-19662-1-git-send-email-minchan@kernel.org> <1338881031-19662-2-git-send-email-minchan@kernel.org> <4FCEE4E0.6030707@vflare.org>
In-Reply-To: <4FCEE4E0.6030707@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 02:04 PM, Nitin Gupta wrote:

> On 06/05/2012 12:23 AM, Minchan Kim wrote:
> 
>> zram's handle variable can store handle of zsmalloc in case of
>> compressing efficiently. Otherwise, it stores point of page descriptor.
>> This patch clean up the mess by union struct.
>>
>> changelog
>>   * from v1
>> 	- none(new add in v2)
>>
>> Cc: Nitin Gupta <ngupta@vflare.org>
>> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zram/zram_drv.c |   77 ++++++++++++++++++++-------------------
>>  drivers/staging/zram/zram_drv.h |    5 ++-
>>  2 files changed, 44 insertions(+), 38 deletions(-)
>>
> 
> 
> I think page vs handle distinction was added since xvmalloc could not
> handle full page allocation. Now that zsmalloc allows full page


I see. I didn't know that because I'm blind on xvmalloc.

> allocation, we can just use it for both cases. This would also allow
> removing the ZRAM_UNCOMPRESSED flag. The only downside will be slightly
> slower code path for full page allocation but this event is anyways
> supposed to be rare, so should be fine.


Fair enough.
It can remove many code of zram.
Okay. Will look into that.

Thanks.

-- 
Kind regards,
Minchan Kim
