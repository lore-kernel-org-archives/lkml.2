Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0HPXzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:55:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60378 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0HPXzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XIomrg1ltPl7WePr4OAhaAi91bOqwb61Zsq0V6nLLAp6KOgSXNawsT3Q7jSyN26SBq
         1wt6vDTKdA8FnMMZ1NaG6Q3KR3etLGirAq2/4Zug5h5gUvE3yIznSLZECui4fMb5BaDf
         OSPS1ruQu4FOONLO1vimX7C5jHF8bdn20nS0Y=
MIME-Version: 1.0
In-Reply-To: <4C67CC06.7070707@redhat.com>
References: <4C591313.50402@cn.fujitsu.com>
	<4C5A844C.60105@redhat.com>
	<1281730204.30865.12.camel@nimitz>
	<4C67CC06.7070707@redhat.com>
Date: Mon, 16 Aug 2010 16:55:20 -0700
X-Google-Sender-Auth: 7qH4EStFsSuihI-kfdB47cSCfrA
Message-ID: <AANLkTikchCjPte9FoVdp_25xtXh=H8ddYsxfG-pGHEtG@mail.gmail.com>
Subject: Re: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 4:14 AM, Avi Kivity <avi@redhat.com> wrote:
>  On 08/13/2010 11:10 PM, Dave Hansen wrote:
>>
>> On Thu, 2010-08-05 at 12:28 +0300, Avi Kivity wrote:
>>>
>>> On 08/04/2010 10:13 AM, Lai Jiangshan wrote:
>>>>
>>>> mmu_shrink() should attempt to free @nr_to_scan entries.
>>>
>>> This conflicts with Dave's patchset.
>>>
>>> Dave, what's going on with those patches?  They're starting to smell.
>>
>> These seem to fix the original problem reporter's issue.  They were run
>> with 64 guests on a 32GB machine.  No stability problems popped up in
>> this testing, or since I last sent the patches to you.  The results from
>> both the test with only the first four patches and with the entire set
>> of nine looked pretty identical.
>>
>> That tells me that we should only push the first four for now:
>>
>>        abstract kvm x86 mmu->n_free_mmu_pages
>>        rename x86 kvm->arch.n_alloc_mmu_pages
>>        replace x86 kvm n_free_mmu_pages with n_used_mmu_pages
>>        create aggregate kvm_total_used_mmu_pages value
>
> Well, patches 3 and 4 have unaddressed review comments. Please fix them up.
> If you don't have the time, let me know and I'll do it instead.

Dave's out on vacation now so it's probably best to assume he wont get
those fixups done very quickly.  Marcelo's comment on patch 3 is
simple.  The conversation regarding patch 4 back in June though
doesn't read like it clearly concluded...I'd be happy to work
something up, but if you've got strong preferences on which route to
use for protecting the count maybe I should leave it to you?


Tim
