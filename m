Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0ESQ5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0ESQ5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:57:06 -0400
Message-ID: <4BF41501.1020909@redhat.com>
Date: Wed, 19 May 2010 12:42:41 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH -tip v2 1/5] [BUGFIX] kprobes: Fix selftest to clear	flags
 field for reusing probes
References: <20100518201244.6058.73083.stgit@localhost6.localdomain6> <20100518201251.6058.60749.stgit@localhost6.localdomain6> <20100519050246.GB17114@in.ibm.com>
In-Reply-To: <20100519050246.GB17114@in.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Tue, May 18, 2010 at 04:12:51PM -0400, Masami Hiramatsu wrote:
>  
>>  kernel/test_kprobes.c |   12 +++++++++---
>>  1 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
>> index 4f10451..ede20f4 100644
>> --- a/kernel/test_kprobes.c
>> +++ b/kernel/test_kprobes.c
>> @@ -115,7 +115,9 @@ static int test_kprobes(void)
>>  	int ret;
>>  	struct kprobe *kps[2] = {&kp, &kp2};
>>
>> -	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
>> +	/* addr and flags should be cleard for reusing kprobe. */
>> +	kp.addr = 0;
> 
> kp.addr = NULL;

OK, I'll fix that (and below too).

Thank you!

> 
>> +	kp.flags = 0;
>>  	ret = register_kprobes(kps, 2);
>>  	if (ret < 0) {
>>  		printk(KERN_ERR "Kprobe smoke test failed: "
>> @@ -210,7 +212,9 @@ static int test_jprobes(void)
>>  	int ret;
>>  	struct jprobe *jps[2] = {&jp, &jp2};
>>
>> -	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
>> +	/* addr and flags should be cleard for reusing kprobe. */
>> +	jp.kp.addr = 0;
> 
> Same here...
> 
>> +	jp.kp.flags = 0;
>>  	ret = register_jprobes(jps, 2);
>>  	if (ret < 0) {
>>  		printk(KERN_ERR "Kprobe smoke test failed: "
>> @@ -323,7 +327,9 @@ static int test_kretprobes(void)
>>  	int ret;
>>  	struct kretprobe *rps[2] = {&rp, &rp2};
>>
>> -	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
>> +	/* addr and flags should be cleard for reusing kprobe. */
>> +	rp.kp.addr = 0;
> 
> Here too.
> 
> Ananth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
