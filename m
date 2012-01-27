Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2A0UAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:00:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2A0UAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:00:04 -0500
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org> <20120127193726.GA13190@albatros>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120127193726.GA13190@albatros>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Fri, 27 Jan 2012 11:59:18 -0800
To: Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Message-ID: <a58d4866-7ec3-48b2-8961-f1cdafe9bc4d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, cookies[1] is always odd.

Vasiliy Kulikov <segoon@openwall.com> wrote:

>Hi Cyrill,
>
>On Fri, Jan 27, 2012 at 21:53 +0400, Cyrill Gorcunov wrote:
>> +/*
>> + * We don't expose real in-memory order of objects for security
>> + * reasons, still the comparision results should be suitable for
>> + * sorting. Thus, we obfuscate kernel pointers values (using random
>> + * cookies obtaned at early boot stage) and compare the production
>> + * instead.
>> + */
>> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
>> +
>> +static long kptr_obfuscate(long v, int type)
>> +{
>> +	return (v ^ cookies[type][0]) * cookies[type][1];
>
>AFACS, cookies is fully random value, is it possible that
>
>((v1 ^ cookies[type][0]) * cookies[type][1] == (v2 ^ cookies[type][0])
>* cookies[type][1]) &&
>(v1 != v2)
>
>for too round cookies[type][1]?
>
>Thanks,
>
>-- 
>Vasiliy Kulikov
>http://www.openwall.com - bringing security into open computing
>environments

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
