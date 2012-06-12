Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2FLCX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:23:57 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53672 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2FLCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:23:56 -0400
Message-ID: <4FD6A833.6060206@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:23:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FC470C7.5040700@linux.vnet.ibm.com> <4FC4716A.8030304@linux.vnet.ibm.com> <20120611233212.GA29573@amt.cnet>
In-Reply-To: <20120611233212.GA29573@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061117-3568-0000-0000-000001F4AEBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 07:32 AM, Marcelo Tosatti wrote:

> On Tue, May 29, 2012 at 02:49:14PM +0800, Xiao Guangrong wrote:
>> This bit indicates whether the spte can be writable on MMU, that means
>> the corresponding gpte is writable and the corresponding gfn is not
>> protected by shadow page protection
> 
> Why is this still necessary, now that only sptes of direct shadow pages 
> are updated locklessly? 
> 


Yes, but it is still needed, for nested npt/ept, we need protect
the nested page tables.

