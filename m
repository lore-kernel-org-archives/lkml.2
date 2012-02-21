Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2BUE6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:58:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49998 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUE6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:58:35 -0500
Message-ID: <4F432475.4090903@gmail.com>
Date: Mon, 20 Feb 2012 21:58:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F338CAA.10807@linux.vnet.ibm.com> <4F338D56.6010505@linux.vnet.ibm.com> <4F42DB8D.7060900@gmail.com> <4F43150F.7010902@linux.vnet.ibm.com>
In-Reply-To: <4F43150F.7010902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/12 8:52 PM, Xiao Guangrong wrote:
>>> +    /* Both begin and end events did not get the key. */
>>> +    if (!event&&   key->key == INVALID_KEY)
>>> +        return;
>>> +
>> Should not be able to get here with event unset, so the next 2 lines should not be needed. ie., you only want to process events where the begin event was seen in which case event is defined.
>
>
> In some case, the 'begin event' just records the start timestamp, the actually event
> is recognised in the 'end event'.
>
> Take mmio-read for example, in the old kernel, we use kvm-exit as the 'begin event'
> and kvm_mmio(KVM_TRACE_MMIO_READ...) is the 'end event'.

ah, ok. Please add a comment about this path.

David

