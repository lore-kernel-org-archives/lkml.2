Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1EXU50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:57:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46176 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1EXU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=utBZBQIMmN+Ejeys6PY9GFLmxDrAlSKPIcLja5lh4xlrHiaetOe0PR3kJZkmSSaBrV
         gSDlco6/+H8xeY1UOFWyXBaxvV19rzOwmBwJE37Qpn0QIrESbMje0NJ62KU7Tz1U/PjK
         Syx7pauJ+maPxwSylBnl9iBiqsRhJE7OFiou8=
Message-ID: <4DDC1BB2.4090503@gmail.com>
Date: Tue, 24 May 2011 14:57:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Vince Weaver <vweaver1@eecs.utk.edu>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression -- missing /sys/devices/system/cpu/perf_events
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu> <1306246306.18455.36.camel@twins> <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu> <20110524194810.GB27634@elte.hu> <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
In-Reply-To: <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/24/11 14:12, Vince Weaver wrote:
> On Tue, 24 May 2011, Ingo Molnar wrote:
>>
>> So, what is wrong with the method Peter suggested: the presence of the perf 
>> syscall (it not returning -ENOSYS) is bona fide evidence that perf is 
>> available.
> 
> it's just hard to do that from a shell script.

What about kallsyms:

grep sys_perf_event_open /proc/kallsyms

even with the new security feature you should be able to see that it
exists. The name has been the same since the counters->events rename in
cdd6c48. egrep for both names for kernels older than 2.6.31.

David


> 
> also, running the perf syscall can be tricky if you have a new kernel but 
> an older set of header files that doesn't have the syscall number defined.
> 
> Vince
> vweaver1@eecs.utk.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
