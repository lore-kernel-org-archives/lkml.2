Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab2JLJtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:49:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2JLJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:49:38 -0400
Message-ID: <5077E7AA.9070705@gmail.com>
Date: Fri, 12 Oct 2012 17:49:30 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] KVM: MMU: fix release noslot pfn
References: <50716EE0.6010504@linux.vnet.ibm.com> <50716F1E.90308@linux.vnet.ibm.com> <20121010151125.GA28406@amt.cnet> <5076C444.8080309@gmail.com> <20121011143152.GA8665@amt.cnet>
In-Reply-To: <20121011143152.GA8665@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 10:31 PM, Marcelo Tosatti wrote:
> On Thu, Oct 11, 2012 at 09:06:12PM +0800, Xiao Guangrong wrote:
>> On 10/10/2012 11:11 PM, Marcelo Tosatti wrote:
>>
>>>
>>> Why does is_error_pfn() return true for mmio spte? Its not an "error",
>>> after all. 
>>>
>>> Please kill is_invalid_pfn and use
>>>
>>> -> is_error_pfn for checking for errors (mmio spte is not an error pfn,
>>> its a special pfn)
>>>
>>> -> add explicit is_noslot_pfn checks where necessary in the code
>>> (say to avoid interpreting a noslot_pfn's pfn "address" bits).
>>>
>>> (should have noticed this earlier, sorry).
>>
>> Never mind, your comments are always appreciated! ;)
>>
>> Marcelo, is it good to you?
>> (will post it after your check and full test)
> 
> Yes, this works (please check the validity of each case in addition to
> testing, haven't done it).
> 
> Also add a oneline comment on top of each
> is_error_pfn,is_noslot_pfn,is_error_noslot_pfn
> 
> /* is_noslot_pfn: userspace translation valid but no memory slot */
> /* is_error_pfn: ... */
> 
> etc.
> 

Marcelo, i think this fix should be backport and your idea can be a
separate patchset. Yes?
