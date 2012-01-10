Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2AJCqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:46:43 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46936 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2AJCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:46:42 -0500
X-AuditID: b753bd60-99794ba000007b1b-66-4f0ba68e8836
X-AuditID: b753bd60-99794ba000007b1b-66-4f0ba68e8836
Message-ID: <4F0BA67B.8070100@hitachi.com>
Date: Tue, 10 Jan 2012 11:46:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, lkml <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH][RESEND] kprobes: initialize before using a hlist
References: <20120109082001.GE20666@in.ibm.com> <1326156463.3609.1.camel@localhost>
In-Reply-To: <1326156463.3609.1.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/10 9:47), Jim Keniston wrote:
> On Mon, 2012-01-09 at 13:50 +0530, Ananth N Mavinakayanahalli wrote:
>> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>>
>> Commit ef53d9c5e introduced a bug where we can potentially leak
>> kretprobe_instances since we initialize a hlist head after having
>> used it.
>>
>> Initialize the hlist head before using it.
>>
>> (Resent with correct email ID for -stable)
>>
>> Reported by: Jim Keniston <jkenisto@us.ibm.com>
>> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: <stable@vger.kernel.org>
> 
> Acked-by: Jim Keniston <jkenisto@us.ibm.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
>> ---
>>  kernel/kprobes.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux-3.2/kernel/kprobes.c
>> ===================================================================
>> --- linux-3.2.orig/kernel/kprobes.c
>> +++ linux-3.2/kernel/kprobes.c
>> @@ -1077,6 +1077,7 @@ void __kprobes kprobe_flush_task(struct 
>>  		/* Early boot.  kretprobe_table_locks not yet initialized. */
>>  		return;
>>
>> +	INIT_HLIST_HEAD(&empty_rp);
>>  	hash = hash_ptr(tk, KPROBE_HASH_BITS);
>>  	head = &kretprobe_inst_table[hash];
>>  	kretprobe_table_lock(hash, &flags);
>> @@ -1085,7 +1086,6 @@ void __kprobes kprobe_flush_task(struct 
>>  			recycle_rp_inst(ri, &empty_rp);
>>  	}
>>  	kretprobe_table_unlock(hash, &flags);
>> -	INIT_HLIST_HEAD(&empty_rp);
>>  	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
>>  		hlist_del(&ri->hlist);
>>  		kfree(ri);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
