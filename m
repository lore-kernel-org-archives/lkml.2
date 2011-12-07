Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1LGLfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:35:44 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50321 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1LGLfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:35:43 -0500
Message-ID: <4EDF4F6D.1040806@parallels.com>
Date: Wed, 7 Dec 2011 09:35:09 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
References: <20111207150956.52d41fd8580de3b66abd5d2d@canb.auug.org.au>
In-Reply-To: <20111207150956.52d41fd8580de3b66abd5d2d@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 02:09 AM, Stephen Rothwell wrote:
> + 	index = (TASK_NICE(p)>  0) ? CPUTIME_NICE : CPUTIME_USER;
> +
>    	/* Add user time to cpustat. */
> - 	if (TASK_NICE(p)>  0)
> - 		cpustat->nice += (__force cputime64_t) cputime;
> - 	else
> - 		cpustat->user += (__force cputime64_t) cputime;
>   -	task_group_account_field(p, index, cputime);
> ++	task_group_account_field(p, index, (__force cputime64_t) cputime);


I doubt __force cputime64_t is necessary. After these patches, those 
fields are all u64.
