Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1LGKVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1LGKVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:21:33 -0500
Message-ID: <4EDF3E2A.3060208@redhat.com>
Date: Wed, 07 Dec 2011 12:21:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Document KVM_NMI
References: <1323204643-17373-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1323204643-17373-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 10:50 PM, Sasha Levin wrote:
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: kvm@vger.kernel.org

Somehow, the changelog became the place where people manage their cc lists.

>  
> +4.64 KVM_NMI
> +
> +Capability: basic
> +Architectures: none
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0 on success, -1 on error
> +
> +Trigger an NMI on the specified VCPU.
> +
> +This can be used to cause a panic in the guest, which in turn would result
> +in a backtrace/dump.
> +

I'm nitpicking, but this is too strongly worded.  It's completely up to
the guest how to interpret the NMI.

It's also subtly broken with kernel irqchip - it injects an NMI
unconditionally even though LINT1 can be configured to mask NMIs, or to
do something other than queue an NMI (for example, queue a regular
interrupt).  Please note this.

On second thoughts, I'll just document this instead of telling you what
to write.

-- 
error compiling committee.c: too many arguments to function
 

