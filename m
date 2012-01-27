Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2A0Ufl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:35:41 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47935 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2A0Ufk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:35:40 -0500
Message-ID: <4F230A40.8000203@parallels.com>
Date: Sat, 28 Jan 2012 00:34:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: <gorcunov@openvz.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <ebiederm@xmission.com>,
        <xemul@openvz.org>, <xemul@parallels.com>, <avagin@openvz.org>,
        <kosaki.motohiro@gmail.com>, <mingo@elte.hu>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <andi@firstfloor.org>, <tj@kernel.org>,
        <matthltc@us.ibm.com>, <penberg@kernel.org>, <eric.dumazet@gmail.com>,
        <segoon@openwall.com>, <adobriyan@gmail.com>,
        <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org> <4F2306BB.5090907@jp.fujitsu.com>
In-Reply-To: <4F2306BB.5090907@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	case KCMP_SYSVSEM:
>> +#ifdef CONFIG_SYSVIPC
>> +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
>> +			       (long)task2->sysvsem.undo_list,
>> +			       KCMP_SYSVSEM);
>> +#else
>> +		ret = -EINVAL;
> 
> ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
> but in this case, it is not bad. only the kernel doesn't have enough feature.
> 

Isn't it usually the case for ENOSYS, then ?

