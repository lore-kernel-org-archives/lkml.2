Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1L1TCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 14:02:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40655 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754400Ab1L1TC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 14:02:28 -0500
Message-ID: <4EFB67AB.7060707@fb.com>
Date: Wed, 28 Dec 2011 11:02:03 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/4] Add clock_gettime_ns syscall
References: <cover.1324831829.git.luto@amacapital.net> <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
In-Reply-To: <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-28_05:2011-12-28,2011-12-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/11 8:51 AM, Andy Lutomirski wrote:

> +struct timens {
> +	u64	ns;		/* nanoseconds since the relevant epoch */
> +	u64	padding;	/* for future expansion (UTC offset? sub-ns?) */
> +};
>..
> +SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
> +		struct timens __user *, tp)
> +{

How about returning a (signed) long as the time in ns? This way, we save 
a store and a load and the value can be passed in registers.

This shouldn't preclude future expansion via extra args.

  -Arun
