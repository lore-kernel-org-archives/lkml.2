Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2EUIdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:33:19 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60131 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2EUIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:33:17 -0400
Message-ID: <4FB9F9B6.50101@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 16:15:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: fix async page fault working for readonly mapping
References: <4FB9E499.2010505@linux.vnet.ibm.com> <20120521080856.GS10209@redhat.com>
In-Reply-To: <20120521080856.GS10209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052108-2674-0000-0000-0000048A463A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 04:08 PM, Gleb Natapov wrote:

> On Mon, May 21, 2012 at 02:45:45PM +0800, Xiao Guangrong wrote:
>> If we map a readonly memory space from host to guest and the page is
>> not currently mapped in the host, we will get a fault-pfn and async
>> is not allowed, then the vm will crash
>>
> Why would we want to map a readonly memory space from host to guest?
> We may want to do it to support memory semantics on read and mmio on
> write, but do not right now unless something changed while I was not
> looking.


Some test cases in kvm-unit-tests and the benchmark i am writing for KVM
need map the function on host to guest.

