Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1DPFnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 01:43:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59043 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1DPFnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 01:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=IV/oVUzsI2CE+Tnrcl4XjJ4VlWMfrC1S0FouPwThch3TYa3P1QzNxqYlRMlS+2BXF5
         uLq8UMk1S8imE4mmjeKLSS5sOKDHOPhCWUV4g4lqEBmYPj00kWPyxkJaQfGwuRQinp0h
         DIAoIGnEg6b55lUbNB5/BdCcwU1P7ibkk/crw=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTi=Z4N4BmjHZkAFev85YL0a=fji4BA@mail.gmail.com>
References: <1302892769.2577.24.camel@schen9-DESK>
	<4DA8B3FB.5020401@linux.intel.com>
	<BANLkTi=Z4N4BmjHZkAFev85YL0a=fji4BA@mail.gmail.com>
Date: Sat, 16 Apr 2011 07:43:52 +0200
Message-ID: <BANLkTi=npf23NBTg-mvxTFVN90zuP=s8qg@mail.gmail.com>
Subject: Re: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com, alex.shi@intel.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 15, 2011 at 2:09 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> On 4/15/2011 11:39 AM, Tim Chen wrote:
>>>
>>> During RCU walk in path_lookupat and path_openat, the rcu lookup
>>> frequently failed because when root directory was looked up, seq number
>>> was not properly set in nameidata.  We dropped out of RCU walk in
>>> nameidata_drop_rcu due to mismatch in directory entry's seq number.  We
>>> reverted to slow path walk that need to take references.
>>
>> Thanks Tim. Adding Andrew, Linus too. IMHO this fix is quite important to
>> actually make the fabled RCU dcache work -- without it it's just slower
>> because
>> it will fallback nearly allways.
>
> Well, only for absolute paths, but yes.
>
> I think all my benchmarking was for thing like "git diff", which are
> all about the relative paths and wouldn't have triggered this case.
>
> So this patch does look correct, and yes, should also be stable material for 38.
>
> And it's pretty fundamental. But I'd like to get a few more acks
> exactly because it's so fundamental. Al and Nick sadly are both gone.
> Anybody else feel like they know something about the path lookup code?
>
>                             Linus
>

I see this patch was pushed.

What's with fs-synchronize_rcu-when-unregister_filesystem-success-not-failure.patch
from [1]?

- Sedat -

[1] https://patchwork.kernel.org/patch/707322/
