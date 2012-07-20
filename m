Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2GTCvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:51:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44801 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2GTCvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:51:47 -0400
Message-ID: <5008C7BC.3030405@linux.vnet.ibm.com>
Date: Thu, 19 Jul 2012 19:51:40 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: prevent overflow in size calculation
References: <1342743215-26979-1-git-send-email-cody@linux.vnet.ibm.com> <87a9yv2r5q.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9yv2r5q.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072002-2356-0000-0000-00000082733F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	/* Check for overflow when calculating sizeof_sym_hist */
>> +	if (size > (SIZE_MAX / sizeof(u64)))
>> +		return -1;
>
> How does it guarantee that the end result which used in zalloc below
> would not overflow?
>
>> +
>> +	sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
>>   	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
>>   	if (notes->src == NULL)
>>   		return -1;

Whoops. Thanks for pointing that out.
I've sent a fixed up patch (the check for sizeof_sym_hist wasn't even 
complete)

--
Cody


