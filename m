Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab2FCImh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 04:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2FCImP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 04:42:15 -0400
Message-ID: <4FCB2359.9020505@redhat.com>
Date: Sun, 03 Jun 2012 11:42:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home>   <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>  <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com>
In-Reply-To: <4FC90961.8030701@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 09:26 PM, Jan Kiszka wrote:
> 
>> you suggesting we need a request_edge_threaded_only_irq() API?  Thanks,
> 
> I'm just wondering if that restriction for threaded IRQs is really
> necessary for all use cases we have. Threaded MSIs do not appear to me
> like have to be handled that conservatively, but maybe I'm missing some
> detail.
> 

btw, I'm hoping we can unthread assigned MSIs.  If the delivery is
unicast, we can precalculate everything and all the handler has to do is
set the IRR, KVM_REQ_EVENT, and kick the vcpu.  All of these can be done
from interrupt context with just RCU locking.

-- 
error compiling committee.c: too many arguments to function
