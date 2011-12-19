Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1LST6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:58:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49080 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752597Ab1LST6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:58:32 -0500
Message-ID: <4EEF9752.1020404@fb.com>
Date: Mon, 19 Dec 2011 11:58:10 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1324324293-10390-1-git-send-email-asharma@fb.com> <1324324293-10390-3-git-send-email-asharma@fb.com>
In-Reply-To: <1324324293-10390-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-19_06:2011-12-19,2011-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 11:51 AM, Arun Sharma wrote:

> +/* Should be optimized away at compile time */
> +static noinline int check_vvar_overflow(void)
> +{
> +	long vcpu_data_offset =  (long) vvaraddr_vcpu_data - VVAR_ADDRESS;
> +	size_t size = (vcpu_data_offset + sizeof(vcpu_data)
> +			+ sizeof(struct vpercpu_data) * CONFIG_NR_CPUS);
> +	return (size>  VVAR_NUM_PAGES * PAGE_SIZE);
> +}

Forgot to drop the "noinline" part (which I had added for debug 
purposes, so I could inspect the generated code). Fixed in my repo.

  -Arun

