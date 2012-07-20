Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2GTCYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:24:46 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53043 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2GTCYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:24:44 -0400
Message-ID: <5008C162.3020201@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 10:24:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/9] KVM: x86: introduce set_mmio_exit_info
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056E0D.1070905@linux.vnet.ibm.com> <20120720000307.GB7121@amt.cnet>
In-Reply-To: <20120720000307.GB7121@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071916-5490-0000-0000-000001CEAABB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:03 AM, Marcelo Tosatti wrote:
> On Tue, Jul 17, 2012 at 09:52:13PM +0800, Xiao Guangrong wrote:
>> Introduce set_mmio_exit_info to cleanup the common code
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   33 +++++++++++++++++----------------
>>  1 files changed, 17 insertions(+), 16 deletions(-)
> 
> This makes the code less readable IMO. The fragments are small enough
> already.
> 

I think the function name set_mmio_exit_info has the better
explanation - it generates a mmio-exit from the specified fragment.

Actually, the later patchset, readonly memeslot will set a new
member in the mmio-exit-info:

	run->mmio.write_readonly_mem = frag->write_readonly_mem;

If we wrap this operation up, i think the code should be neater. :)



