Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2A0UiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:38:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51037 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2A0UiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:38:00 -0500
Message-ID: <4F230AF9.1010104@zytor.com>
Date: Fri, 27 Jan 2012 12:37:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gorcunov@openvz.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, xemul@openvz.org, xemul@parallels.com,
        avagin@openvz.org, kosaki.motohiro@gmail.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, tj@kernel.org,
        matthltc@us.ibm.com, penberg@kernel.org, eric.dumazet@gmail.com,
        segoon@openwall.com, adobriyan@gmail.com, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org> <4F2306BB.5090907@jp.fujitsu.com> <4F230A40.8000203@parallels.com>
In-Reply-To: <4F230A40.8000203@parallels.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 12:34 PM, Glauber Costa wrote:
>>> +	case KCMP_SYSVSEM:
>>> +#ifdef CONFIG_SYSVIPC
>>> +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
>>> +			       (long)task2->sysvsem.undo_list,
>>> +			       KCMP_SYSVSEM);
>>> +#else
>>> +		ret = -EINVAL;
>>
>> ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
>> but in this case, it is not bad. only the kernel doesn't have enough feature.
>>
> 
> Isn't it usually the case for ENOSYS, then ?
> 

ENOSYS means "no such system call".  That would apply if the kcmp system
call itself did not exist.

	-hpa

