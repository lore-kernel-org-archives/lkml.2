Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1D2Ufd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:35:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41774 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab1D2Ufb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Zz5mBZotvQ8Vt8HJvSIMxD8LUG4VGiz86d0Gw5cA4lSen17dgEME1JndrElFI/vLvz
         QaNhCCiIzPVcjHz/mCwMxYuva+9Y5Uzka2TjFO5RivFkIqvktifh0ukeJ2MlsvN/EjIG
         /P2lOn0h6ikpU2UwZHBaZX5C6kXnB1qrpwSFo=
Message-ID: <4DBB210F.8030200@gmail.com>
Date: Fri, 29 Apr 2011 22:35:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Boris Ostrovsky <boris.ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Boris Ostrovsky <ostr@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jvpeetz@web.de" <jvpeetz@web.de>
Subject: Re: [PATCH] Subject: [PATCH] x86, AMD: K8 Rev.A-E processors are
 subject to erratum 400
References: <1304106663-3720-1-git-send-email-ostr@amd64.org> <20110429195548.GA17166@elte.hu> <4DBB1B6E.9060203@amd.com> <20110429202338.GA21523@aftab>
In-Reply-To: <20110429202338.GA21523@aftab>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 10:23 PM, Borislav Petkov wrote:
> On Fri, Apr 29, 2011 at 04:11:26PM -0400, Boris Ostrovsky wrote:
>> On 04/29/2011 03:55 PM, Ingo Molnar wrote:
>>>
>>> * Boris Ostrovsky<ostr@amd64.org>  wrote:
>>>
>>>> Signed-off-by: Boris Ostrovsky<Boris.Ostrovsky@amd.com>
>>>> Acked-by: Borislav Petkov<borislav.petkov@amd.com>
>>>> Reported-by: Joerg-Volker Peetz<jvpeetz@web.de>
>>>> Tested-by: Joerg-Volker Peetz<jvpeetz@web.de>
>>>>
>>>> Older AMD K8 processors (Revisions A-E) are affected by erratum 400 (APIC
>>>> timer interrupts don't occur in C states greater than C1). This, for example,
>>>> means that X86_FEATURE_ARAT flag should not be set for these parts.
>>>>
>>>> This addresses regression introduced by commit
>>>> b87cf80af3ba4b4c008b4face3c68d604e1715c6 (x86, AMD: Set ARAT feature on AMD
>>>> processors") so it is somewhat high priority.
>>>
>>> Hm, what is the regression, how do users see it? Hangs? Delays? Crashes?
>>> Something more benign? The changelog should really contain such information.
>>
>>
>> The system becomes unresponsive until an external interrupt (e.g. 
>> keyboard input) happens. The most obvious effect is that time is not 
>> reported correctly. We haven't seen anything worse but that's probably 
>> bad enough.
>>
>> Do you want me to resubmit the patch with updated comments?
> 
> Yes please. Being too verbose is much better than being laconic with the
> commit message.
> 
> Also, please put those lines
> 
> Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
> Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
> 
> _after_ the commit message.

And also please add
Cc: stable@kernel.org
as the original commit (b87cf80a) was merged into stable trees.

thanks,
-- 
js
