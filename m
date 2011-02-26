Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1BZLTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 06:19:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51068 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1BZLTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 06:19:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uHWdKMrHQLZouhNlqkqceJv+CG0PGCarfLA9jNOS0VaKnFUlDMmADSxMCG7Iy47R+S
         HrMBIsSfWRLTh3dWQKFbDiWMO7OnvDtdDsE59p67f7ULkFqVX5lF71zpuKMRqd07eopf
         EvAmBiM1PRn6Kwr2ADmQyOEriGXGcD6W/u3WQ=
MIME-Version: 1.0
In-Reply-To: <4D68B397.6040809@gmail.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
	<1294348732-15030-6-git-send-email-dzickus@redhat.com>
	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
	<4D68B397.6040809@gmail.com>
Date: Sat, 26 Feb 2011 19:19:13 +0800
Message-ID: <AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: huang ying <huang.ying.caritas@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 4:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 02/23/2011 05:39 AM, Maciej W. Rozycki wrote:
> ...
>>
>>  [Catching up with old e-mail...]
>>
>>  In line with the comment above that you're removing -- have you (or
>> anyone else) adjusted code elsewhere so that external NMIs are actually
>> delivered to processors other than the BSP?  I can't see such code in this
>> series nor an explanation as to why it wouldn't be needed.
>>
>>  For the record -- the piece of code above reflects our setup where the
>> LINT1 input is enabled and configured for the NMI delivery mode on the BSP
>> only and all the other processors have this line disabled in their local
>> APIC units.  If system NMIs are to be handled after the removal of the
>> BSP, then another processor has to be selected and configured for NMI
>> reception.  Alternatively, all local units could have their LINT1 input
>> enabled and arbitrate handling, although it would be quite disruptive as
>> all the processors would take the interrupt if it happened.  OTOH it would
>> be more fault-tolerant in the case of a CPU failure.  On a typical x86 box
>> the system NMI cannot be routed to an I/O APIC input.
>>
>>   Maciej
>
>  Hi Maciej, good catch! The code doesn't reconfig LVT. As just Don pointed
> it might be Intel is working on something, dunno. Probably we better should
> drop this patch for now (at least until LVT reconfig would not be
> implemented).

Why?  Without LVT reconfig, system with this patch can not work
properly?  This is just one of the steps to make CPU 0 hot-removable.
We must enable CPU 0 hot-removing in one step?

Best Regards,
Huang Ying
