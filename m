Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2GINXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:23:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50848 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2GINXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:23:12 -0400
Message-ID: <4FFADB37.4090705@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 21:23:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
References: <4FFA9E16.10001@linux.vnet.ibm.com> <4FFABD59.2070108@redhat.com> <20120709112346.GA23898@redhat.com> <4FFAD341.3080508@redhat.com>
In-Reply-To: <4FFAD341.3080508@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070913-5564-0000-0000-000003878328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 08:49 PM, Avi Kivity wrote:
> On 07/09/2012 02:23 PM, Gleb Natapov wrote:
>>
>>> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
>>>
>>> I agree this code has to go, but it needs to be replaced by something.
>>> Maybe a .valid flag in struct operand.
>>>
>> Valid will not enough for that.
> 
> If we make everything go through operands, any reason why not?
> 

I noticed some instructions need to read ESP for many times (e.g, iret_real),
maybe .valid flag is not enough for this case if the stack is in MMIO, yes?

IIUC, I also noticed ESP is not reset back if it is emulated fail (mmio is needed).
If the stack located in mmio region, this kind of instruct will be broken, i know no
guest will use mmio as stack but SDM does not limit it, is it valid?




