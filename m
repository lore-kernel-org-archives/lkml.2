Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2FKTlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:41:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40214 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110Ab2FKTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:41:16 -0400
Message-ID: <4FD649CF.5020300@fb.com>
Date: Mon, 11 Jun 2012 12:41:03 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <mingo@elte.hu>
Subject: Re: [PATCH] perf/x86: fix broken LBR fixup code
References: <20120611134426.GA7542@quad> <1339422464.30462.17.camel@twins>
In-Reply-To: <1339422464.30462.17.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-06-11_04:2012-06-11,2012-06-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/12 6:47 AM, Peter Zijlstra wrote:
> On Mon, 2012-06-11 at 15:44 +0200, Stephane Eranian wrote:
>> I noticed that the LBR fixups were not working anymore
>> on programs where they used to. I tracked this down to
>> a recent change to copy_from_user_nmi().
>>
>> commit db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
>> Author: Arun Sharma<asharma@fb.com>
>> Date:   Fri Apr 20 15:41:36 2012 -0700
>>
>>      perf/x86: Check user address explicitly in copy_from_user_nmi()
>>
>> This commit added a call to __range_not_ok() to the
>> copy_from_user_nmi() routine. The problem is that the logic
>> of the test must be reversed. __range_not_ok() returns 0 if the
>> range is VALID. We want to return early from copy_from_user_nmi()
>> if the range is NOT valid.
>
> D'0h.. Thanks!

My bad. I was fooled by all the kernel addresses that were unwound 
properly. Didn't notice the broken unwinding in user space before I sent 
the patch. The fix looks good. Thanks.

  -Arun
