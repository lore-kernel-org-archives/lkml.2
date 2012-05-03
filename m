Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2ECP0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:26:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45329 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2ECP0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:26:36 -0400
Message-ID: <4FA2A2F0.3030509@linux.vnet.ibm.com>
Date: Thu, 03 May 2012 10:23:28 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org> <4FA28907.9020300@vflare.org>
In-Reply-To: <4FA28907.9020300@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050315-5518-0000-0000-0000041DBB12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 08:32 AM, Nitin Gupta wrote:

> On 5/3/12 2:40 AM, Minchan Kim wrote:
>> We should use zs_handle instead of void * to avoid any
>> confusion. Without this, users may just treat zs_malloc return value as
>> a pointer and try to deference it.
>>
>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
>> Signed-off-by: Minchan Kim<minchan@kernel.org>
>> ---
>>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
>>   drivers/staging/zram/zram_drv.c          |    8 ++++----
>>   drivers/staging/zram/zram_drv.h          |    2 +-
>>   drivers/staging/zsmalloc/zsmalloc-main.c |   28
>> ++++++++++++++--------------
>>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
>>   5 files changed, 34 insertions(+), 27 deletions(-)
> 
> This was a long pending change. Thanks!


The reason I hadn't done it before is that it introduces a checkpatch
warning:

WARNING: do not add new typedefs
#303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
+typedef void * zs_handle;

In addition this particular patch has a checkpatch error:

ERROR: "foo * bar" should be "foo *bar"
#303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
+typedef void * zs_handle;

--
Seth

