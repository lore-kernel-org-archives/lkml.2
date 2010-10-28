Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140Ab0J1Uxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:53:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33476 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653Ab0J1Uxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=U1Nb9FoAqABGvwS75uakkND8/XiQwIeuLRz0w3x4VufOC4K9GXU2Zzjdlp3Xjqulpr
         e4o7sZKhTdLvuMXpGxU07O4CbYmLb9cOqcpy/mM/KQXSDV6IbbMfQlE08FW2qIiytNpN
         FdVXfZhYwekxJ1wYdyTWTqPNhcdrrw/WQ2g/U=
MIME-Version: 1.0
In-Reply-To: <AANLkTimcsAcSgEz7vvVzp11XPvY9f010nCRmBCd9VkfF@mail.gmail.com>
References: <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <20101028203542.GA30879@merkur.ravnborg.org> <AANLkTimcsAcSgEz7vvVzp11XPvY9f010nCRmBCd9VkfF@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 28 Oct 2010 16:53:22 -0400
Message-ID: <AANLkTikHHmugY=tFhqSbj-9noJmdeZHPPY1KN9yM8jMe@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 16:42, Mike Frysinger wrote:
> On Thu, Oct 28, 2010 at 16:35, Sam Ravnborg wrote:
>> On Thu, Oct 28, 2010 at 12:46:31AM +0200, Michal Marek wrote:
>>> On 27.10.2010 20:23, Mike Frysinger wrote:
>>> > can we get this change dropped from linux-next until someone gets a
>>> > chance to fix it ?
>>>
>>> Sorry I missed this thread. So your last patch
>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
>>> failure? Can you submit it with a proper Signed-off-by and changelog?
>>
>> Did you see the patch I posted in: http://lkml.org/lkml/2010/10/19/534
>>
>> The one that fix up the cppflags usage.
>>
>> I think this will solve the issue with blackfin nicely - and
>> make use of cppflags more as expected.
>
> but then i followed up that the Makefile code exists to strip out
> quotes because the CPP cannot do it for us and we need a value sans
> quotes:
> http://lkml.org/lkml/2010/10/19/538

for due diligence, adding those two changes breaks building like so:
  LD      .tmp_vmlinux1
.../bfin-uclinux/bin/ld.real: cannot find _
make: *** [.tmp_vmlinux1] Error 1

and if we look at the generated vmlinux.lds, we indeed see the quotes
causing problems:
  . = ALIGN(8); "_"__lock_text_start = .; *(.spinlock.text)
"_"__lock_text_end = .;
  . = ALIGN(8); "_"__kprobes_text_start = .; *(.kprobes.text)
"_"__kprobes_text_end = .;
-mike
