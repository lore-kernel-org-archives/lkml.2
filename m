Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1HCIJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1HCIJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:09:11 -0400
Message-ID: <4E39021F.8070508@redhat.com>
Date: Wed, 03 Aug 2011 11:09:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] KVM: x86: tag the instructions which are used
 to write page table
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DA73.7010908@cn.fujitsu.com> <4E37EB8E.6080207@redhat.com> <4E38E477.2000208@cn.fujitsu.com>
In-Reply-To: <4E38E477.2000208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 09:02 AM, Xiao Guangrong wrote:
> >  Note we don't need to actually emulate, just decode, since page_fault can tell us whether a write failed due to page tables or mmio.
> >
>
> This is a interesting feature. If it happens, i will just drop the shadow pages
> and retry these instructions directly.

Note it's a little dangerous.  If the guest uses a non-page-table 
modifying instruction on the PDE that points to the instruction, then we 
will unmap the instruction and go to an infinite loop.

Maybe it's better to emulate if we can't find a fix for that.

One way would be to emulate every 20 instructions; this breaks us out of 
the loop but reduces costly emulations to 5%.

-- 
error compiling committee.c: too many arguments to function

