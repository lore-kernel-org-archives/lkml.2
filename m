Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2DUE3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:29:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50197 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2DUE3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:29:49 -0400
Message-ID: <4F9237B8.9090503@gmail.com>
Date: Sat, 21 Apr 2012 12:29:44 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911C05.2070701@linux.vnet.ibm.com> <20120420215211.GC13817@amt.cnet> <20120421004030.GA16191@amt.cnet> <20120421005555.GA16526@amt.cnet>
In-Reply-To: <20120421005555.GA16526@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 08:55 AM, Marcelo Tosatti wrote:


>> So this is an example of implicit assumptions which break if you update
>> spte without mmu_lock. Certainly there are more cases. :(
> 
> OK, i now see you mentioned a similar case in the document, for
> rmap_write_protect.
> 
> More importantly than the particular flush TLB case, the point is
> every piece of code that reads and writes sptes must now be aware that
> mmu_lock alone does not guarantee stability. Everything must be audited.
> 


Yes, that is true, but it is not hard to audit the code since we only
change the spte from read-only to writable, also all information that
fast page fault depends on is from spte.

