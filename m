Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2F1AUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:20:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55011 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2F1AUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:20:25 -0400
X-AuditID: 9c930179-b7cceae000004195-87-4feba3472c79
Message-ID: <4FEBA354.9030609@kernel.org>
Date: Thu, 28 Jun 2012 09:20:36 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/3] zsmalloc: add generic path and remove x86 dependency
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-3-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9A0D.4020000@kernel.org> <4FEB5A7E.8040500@linux.vnet.ibm.com>
In-Reply-To: <4FEB5A7E.8040500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:09 AM, Seth Jennings wrote:

> On 06/27/2012 12:28 AM, Minchan Kim wrote:
>>> +{
>>> +	if (area->vm)
>>> +		return 0;
>>
>>
>> Just out of curiosity.
>> When do we need above check?
> 
> I did this in the case that there was a race between the for
> loop in zs_init(), calling zs_cpu_notifier(), and a CPU
> coming online.  I've never seen the condition hit, but if it
> did, it would leak memory without this check.
> 


Could you add this as a comment?



> I would move the cpu notifier registration after the loop in
> zs_init(), but then I could miss a cpu up event and we
> wouldn't have the needed per-cpu resources for mapping.
> 
> All other suggestions are accepted.  Thanks for the feedback!
> 



Thanks!

-- 
Kind regards,
Minchan Kim
