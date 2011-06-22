Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1FVR1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:27:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50197 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab1FVR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=GilIFXPydXUDUCidl0QGtzVoWxadImZBRdSIFKjV3YyqbT8pLaM36bvci/4sIRSBI0
         teOUTmu5cuafpGEi5vpp+5b3ajgNl64QOk3Mg0W2Y5/7puTOYQ3sCRhcCIBlLzOp/A1M
         pRUz/ByjlEmUYJIgQs/4oTaVTKBdIrAzksLho=
MIME-Version: 1.0
In-Reply-To: <20110622132114.GA8656@dumpdata.com>
References: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
	<BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
	<20110622132114.GA8656@dumpdata.com>
Date: Wed, 22 Jun 2011 10:27:08 -0700
Message-ID: <BANLkTi=v7i04JhXRaf18_=nXKSgwHMDJjg@mail.gmail.com>
Subject: Re: code sections beyond .text skipped from alternatives_smp_module_add
From: Deep Debroy <ddebroy@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kraxel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 6:21 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> > Looking at the code, in module_finalize for x86, only .text seems to
>> > be getting picked for the patching of lock prefixes while other
>> > sections such as .exit.text or .init.text are not. Is there a reason
>> > we skip the other *.text code sections from the lock patches? Would
>> + Gerd Hoffmann who introduced the SMP patching code below back in Jan
>> 2006 as part of 2.6.15.
>
> Whoa, long time ago.
>
>>
>> Any comments on why patching of smp_lock prefixes should be restricted
>> to .text and not other *.text code sections?
>
> It could be that at that time the .exit.text or .init.text did not exist.
>
> As in, the patching code just hasn't kept up. One way of checking that
> is just finding the ancient 2.6.15 code and seeing if there is any
> mention of those extra segments.
>

Thanks Konrad. One slight correction: after rechecking the kernel
sources, it appears the smp lock prefix code first made it's
appearance in the official trees during 2.6.18. In any case, going
back even to 2.6.16 sources, layout_sections in module.c specially
handled .init prefixed sections from the rest i.e. core sections.
Further, the module struct in include/module/linux.h seems to have had
members such as init_text_size which suggests atleast .init.text did
exit back then as well. While I didn't find any crumbs in the code
that point to the existence of a .exit.text (besides a function
pointer called exit which most likely ended up in the .exit.text), the
ELF headers for Centos 5.6 kernel objects (which uses the 2.6.18
kernel) typically have a .exit.text.

> Do you have a patch to fix this?
>

I can work on that. Just wanted to first make sure that there wasn't
any specific reason to avoid patching non .text sections.

Thanks,
Deep
