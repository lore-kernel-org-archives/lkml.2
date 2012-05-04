Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2EDCY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:24:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63572 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2EDCY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:24:58 -0400
X-AuditID: 9c930179-b7c19ae000000486-f8-4fa33df8a801
Message-ID: <4FA33DF6.8060107@kernel.org>
Date: Fri, 04 May 2012 11:24:54 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org> <4FA28907.9020300@vflare.org> <4FA2A2F0.3030509@linux.vnet.ibm.com>
In-Reply-To: <4FA2A2F0.3030509@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:23 AM, Seth Jennings wrote:

> On 05/03/2012 08:32 AM, Nitin Gupta wrote:
> 
>> On 5/3/12 2:40 AM, Minchan Kim wrote:
>>> We should use zs_handle instead of void * to avoid any
>>> confusion. Without this, users may just treat zs_malloc return value as
>>> a pointer and try to deference it.
>>>
>>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
>>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
>>> Signed-off-by: Minchan Kim<minchan@kernel.org>
>>> ---
>>>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
>>>   drivers/staging/zram/zram_drv.c          |    8 ++++----
>>>   drivers/staging/zram/zram_drv.h          |    2 +-
>>>   drivers/staging/zsmalloc/zsmalloc-main.c |   28
>>> ++++++++++++++--------------
>>>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
>>>   5 files changed, 34 insertions(+), 27 deletions(-)
>>
>> This was a long pending change. Thanks!
> 
> 
> The reason I hadn't done it before is that it introduces a checkpatch
> warning:
> 
> WARNING: do not add new typedefs
> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
> +typedef void * zs_handle;
> 


Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.

 (a) totally opaque objects (where the typedef is actively used to _hide_
     what the object is).

No?

> In addition this particular patch has a checkpatch error:
> 
> ERROR: "foo * bar" should be "foo *bar"
> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
> +typedef void * zs_handle;


It was my mistake. Will fix.
Thanks!

-- 
Kind regards,
Minchan Kim
