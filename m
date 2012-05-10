Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2EJCDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:03:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45483 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2EJCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:03:14 -0400
X-AuditID: 9c930179-b7bc8ae0000062c3-73-4fab21deab7e
Message-ID: <4FAB21E7.7020703@kernel.org>
Date: Thu, 10 May 2012 11:03:19 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org> <4FA28907.9020300@vflare.org> <4FA2A2F0.3030509@linux.vnet.ibm.com> <4FA33DF6.8060107@kernel.org> <20120509201918.GA7288@kroah.com>
In-Reply-To: <20120509201918.GA7288@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 05:19 AM, Greg Kroah-Hartman wrote:

> On Fri, May 04, 2012 at 11:24:54AM +0900, Minchan Kim wrote:
>> On 05/04/2012 12:23 AM, Seth Jennings wrote:
>>
>>> On 05/03/2012 08:32 AM, Nitin Gupta wrote:
>>>
>>>> On 5/3/12 2:40 AM, Minchan Kim wrote:
>>>>> We should use zs_handle instead of void * to avoid any
>>>>> confusion. Without this, users may just treat zs_malloc return value as
>>>>> a pointer and try to deference it.
>>>>>
>>>>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
>>>>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
>>>>> Signed-off-by: Minchan Kim<minchan@kernel.org>
>>>>> ---
>>>>>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
>>>>>   drivers/staging/zram/zram_drv.c          |    8 ++++----
>>>>>   drivers/staging/zram/zram_drv.h          |    2 +-
>>>>>   drivers/staging/zsmalloc/zsmalloc-main.c |   28
>>>>> ++++++++++++++--------------
>>>>>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
>>>>>   5 files changed, 34 insertions(+), 27 deletions(-)
>>>>
>>>> This was a long pending change. Thanks!
>>>
>>>
>>> The reason I hadn't done it before is that it introduces a checkpatch
>>> warning:
>>>
>>> WARNING: do not add new typedefs
>>> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
>>> +typedef void * zs_handle;
>>>
>>
>>
>> Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.
>>
>>  (a) totally opaque objects (where the typedef is actively used to _hide_
>>      what the object is).
>>
>> No?
> 
> No.
> 
> Don't add new typedefs to the kernel.  Just use a structure if you need
> to.


I tried it but failed because there were already tightly coupling between [zcache|zram]
and zsmalloc. 
They already knows handle's internal well so they used it as pointer, even zcache keeps
handle's value as some key in tmem_put and tmem_get
AFAIK, ramster also will use zsmalloc sooner or later and add more coupling codes. Sigh.
Please fix it as soon as possible.

Dan, Seth
Any ideas?

> 
> Vague "handles" are almost never what you want to do in Linux, sorry, I
> can't take this patch.
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
