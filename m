Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0JSCYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:24:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47597 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0JSCYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ws016IkZBNJ3Ct+Z6angU2WiN/1msqF5kcawfDh6FPoyr+izH2Ju7wvShk+28v5XXV
         PMkXfG3KZOqyiJSjzP5VE3ebZ3CXaXIhND1SdGQPSwjs4YKIy4uDbUaDQ+PWiZMiKKdr
         QQt/Ff40WfMyYIlRVoU8S33801UOWuUq7nFTU=
MIME-Version: 1.0
In-Reply-To: <20101018191840.89b39aa3.akpm@linux-foundation.org>
References: <20101016043331.GA3177@darkstar>
	<20101018164647.bc928c78.akpm@linux-foundation.org>
	<AANLkTikVueTjihngtC2rsoeqkUb5Wg-zeEFH1HKgcuuo@mail.gmail.com>
	<AANLkTi=t2U5wa_7pqcb1pAq6p_x7VqYKbfMDZ10q+Geq@mail.gmail.com>
	<20101018191840.89b39aa3.akpm@linux-foundation.org>
Date: Tue, 19 Oct 2010 10:24:44 +0800
Message-ID: <AANLkTik_yrUkbY+UpA0A9CJcDDXc9kd-MFVhqCNdK_JP@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:18 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 19 Oct 2010 09:55:17 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Tue, Oct 19, 2010 at 9:27 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > On Tue, Oct 19, 2010 at 7:46 AM, Andrew Morton
>> >>
>> >> Also, a slightly better implementation would be
>> >>
>> >> static inline void * vmalloc_node_flags(unsigned long size, gfp_t flags)
>> >> {
>> >>        return  vmalloc_node(size, 1, flags, PAGE_KERNEL, -1,
>> >>                                 builtin_return_address(0));
>> >> }
>>
>> Is this better? might  vmalloc_node_flags would be used by other than vmalloc?
>>
>> static inline void * vmalloc_node_flags(unsigned long size, int node,
>> gfp_t flags)
>
> I have no strong opinions, really.  If we add more and more arguments
> to vmalloc_node_flags() it ends up looking like vmalloc_node(), so we
> may as well just call vmalloc_node().  Do whatever feels good ;)

Ok, thanks.

Then I would prefer add 'node' argument due to the function name of
vmalloc_node_flags

-- 
Regards
dave
