Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0HBIvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0HBIvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:51:08 -0400
Message-ID: <4C5686EC.4060703@redhat.com>
Date: Mon, 02 Aug 2010 11:50:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 0/4] Paravirt-spinlock implementation for KVM guests
 (Version 0)
References: <20100726061150.GB21699@linux.vnet.ibm.com>
In-Reply-To: <20100726061150.GB21699@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 09:11 AM, Srivatsa Vaddagiri wrote:
> This patch-series implements paravirt-spinlock implementation for KVM guests,
> based heavily on Xen's implementation. I tried to refactor Xen's spinlock
> implementation to make it common for both Xen and KVM - but found that
> few differences between Xen and KVM (Xen has the ability to block on a
> particular event/irq for example) _and_ the fact that the guest kernel
> can be compiled to support both Xen and KVM hypervisors (CONFIG_XEN and
> CONFIG_KVM_GUEST can both be turned on) makes the "common" code a eye-sore.
> There will have to be:
>
> 	if (xen) {
> 		...
> 	} else if (kvm) {
> 		..
> 	}
>
> or possibly:
>
> 	alternative(NOP, some_xen_specific_call, ....)
>
> type of code in the common implementation.

I do think things are pretty common.  If that is the only issue, you can 
use a plain function vector, no?

-- 
error compiling committee.c: too many arguments to function

