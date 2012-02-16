Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2BPHJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:09:14 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36577 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757237Ab2BPHJJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:09:09 -0500
MIME-Version: 1.0
In-Reply-To: <25fbf6a9-f43c-4ee4-a3af-53af2dd55b87@email.android.com>
References: <1328582733-31804-1-git-send-email-h.mitake@gmail.com>
	<2d1a4f3c-48b0-4105-bbc6-18d164512405@email.android.com>
	<CAMO-S2h-maRLhkX255XX=TPrMH5d5F_3w-aJr7g=GRHcQ+LAXg@mail.gmail.com>
	<4F33DC0F.7090704@zytor.com>
	<CAMO-S2gdp-GUsJz05hkQbesmwsZUSja4b8KLwYytMYq2kYRymA@mail.gmail.com>
	<25fbf6a9-f43c-4ee4-a3af-53af2dd55b87@email.android.com>
Date: Thu, 16 Feb 2012 16:09:08 +0900
Message-ID: <CAMO-S2inx3UmHvBKnZDdJCp3FG3QeoWRj5ggSThVsxnvw7DFnw@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: architecture independent readq/writeq for
 32bit environment
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Kashyap Desai <Kashyap.Desai@lsi.com>, Len Brown <lenb@kernel.org>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Matthew Garrett <mjg@redhat.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 14:59, hpanvin@gmail.com <hpa@zytor.com> wrote:
> The point is that the type for all readq/writeq should be u64.

So do you mean that readq/writeq should be defined without
bulid_mmio_read/write?
(in the case of x86)
bulid_mmio_read/write define the parameter type of read/write[bwlq] as void *.

And are there some situations that void * typed parameter of
readq/writeq causes problems?

>
> Hitoshi Mitake <h.mitake@gmail.com> wrote:
>
>>On Thu, Feb 9, 2012 at 23:45, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 02/09/2012 05:37 AM, Hitoshi Mitake wrote:
>>>>
>>>> On Tue, Feb 7, 2012 at 12:47, hpanvin@gmail.com<hpa@zytor.com>
>> wrote:
>>>>>
>>>>> Should be volatile u64 * not volatile void *...
>>>>
>>>>
>>>> Is this the type of parameters?
>>>> The parameters of atomic readq/writeq defined in
>>arch/x86/include/asm/io.h
>>>> are defined as void *. I think that atomic readq/writeq and
>>non-atomic
>>>> readq/writeq
>>>> should have same typed parameters and return values.
>>>>
>>>
>>> That sounds like a bug.
>>>
>>>        -hpa
>>>
>>
>>Sorry for my bad writing, I didn't mention:
>>the parameter type == the return value type
>>
>>My intention is:
>>parameter type of atomic readq/writeq == parameter type of non-atomic
>>readq/writeq
>>&&
>>return value type of atomic readq/writeq == return value type of
>>non-atomic readq/writeq
>>
>># == means "should be equal"
>>
>>--
>>Hitoshi Mitake
>>h.mitake@gmail.com
>
> --
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.



-- 
Hitoshi Mitake
h.mitake@gmail.com
