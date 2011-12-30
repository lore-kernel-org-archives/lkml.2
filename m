Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1L3Rf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:35:56 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43610 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1L3Rfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:35:52 -0500
Message-ID: <4EFDF671.7020101@linux.vnet.ibm.com>
Date: Fri, 30 Dec 2011 11:35:45 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zcache: fix serialization bug in zv stats
References: <<1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>> <d9558871-53ec-4d49-8df4-c09bee100a49@default>
In-Reply-To: <d9558871-53ec-4d49-8df4-c09bee100a49@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11123017-7408-0000-0000-0000019437C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2011 11:02 AM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Sent: Friday, December 30, 2011 9:42 AM
>> To: Greg Kroah-Hartman
>> Cc: Seth Jennings; Dan Magenheimer; Brian King; devel@driverdev.osuosl.org; linux-
>> kernel@vger.kernel.org
>> Subject: [PATCH] staging: zcache: fix serialization bug in zv stats
>>
>> In a multithreaded workload, the zv_curr_dist_counts
>> and zv_cumul_dist_counts statistics are being corrupted
>> because the increments and decrements in zv_create
>> and zv_free are not atomic.
>>
>> This patch converts these statistics and their corresponding
>> increments/decrements/reads to atomic operations.
>>
>> Based on v3.2-rc7
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> I'm inclined to nack this change, at least unless inside an #ifdef DEBUG,

I guess I didn't respond to this suggestion.  We could put #ifdef DEBUG
around the updates in zv_create and zv_free and around the two sysfs
*_show functions.  Kinda messy though.  I guess it might not matter
if we'll be re-evaluating this whole thing soon.

I'd just like to have it correct in mainline until then.

--
Seth

