Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2JROtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2JROtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:49:08 -0400
Message-ID: <508016DC.1040509@redhat.com>
Date: Thu, 18 Oct 2012 16:49:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Sanagi, Koki" <sanagi.koki@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm/ftrace: change the diplaying format of vector in
 trace_msi_set_irq
References: <F6CB40852BC6EF489E0AA83EFF537F4708724889@G01JPEXMBYT04>
In-Reply-To: <F6CB40852BC6EF489E0AA83EFF537F4708724889@G01JPEXMBYT04>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 02:03 AM, Sanagi, Koki wrote:
> This patch changes the way to diplay the vector in trace_msi_set_irq from %x to
> %u.  Currently, it mismatches another output of ftrace such as kvm_msi_set_irq
> and kvm_inj_virq which uses %u.
> 
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> ---
>  include/trace/events/kvm.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 7ef9e75..0a83632 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -109,7 +109,7 @@ TRACE_EVENT(kvm_msi_set_irq,
>  		__entry->data		= data;
>  	),
>  
> -	TP_printk("dst %u vec %x (%s|%s|%s%s)",
> +	TP_printk("dst %u vec %u (%s|%s|%s%s)",
>  		  (u8)(__entry->address >> 12), (u8)__entry->data,
>  		  __print_symbolic((__entry->data >> 8 & 0x7), kvm_deliver_mode),
>  		  (__entry->address & (1<<2)) ? "logical" : "physical",


Changing them all to %02x is probably better.  For example, writes to
APIC_ICR will be shown as hex, with the vector in the low order 8 bits,
so it will be easier to match them if they are all in hex.


-- 
error compiling committee.c: too many arguments to function
