Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0HBIcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0HBIcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:32:46 -0400
Message-ID: <4C5682A3.40409@redhat.com>
Date: Mon, 02 Aug 2010 11:32:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: vatsa@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061445.GB8402@linux.vnet.ibm.com> <4C4DC3AD.7010404@goop.org>
In-Reply-To: <4C4DC3AD.7010404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 08:19 PM, Jeremy Fitzhardinge wrote:
>  On 07/25/2010 11:14 PM, Srivatsa Vaddagiri wrote:
>> Add KVM hypercall for yielding vcpu timeslice.
>
> Can you do a directed yield?
>

A problem with directed yield is figuring out who to yield to.  One idea 
is to look for a random vcpu that is not running and donate some runtime 
to it.  In the best case, it's the lock holder and we cause it to start 
running.  Middle case it's not the lock holder, but we lose enough 
runtime to stop running, so at least we don't waste cpu.  Worst case we 
continue running not having woken the lock holder.  Spin again, yield 
again hoping to find the right vcpu.

-- 
error compiling committee.c: too many arguments to function

