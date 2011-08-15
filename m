Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1HOSfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:35:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62176 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1HOSfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <4E4964F1.1020900@zytor.com>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <4E493449.70907@mit.edu> <be840e9d6d1ff3fdb94ce2ac23a15338.squirrel@www.skyhub.de>
 <CAObL_7GmMPBKa4QwcnUeehowzvTUdqXN7yswAfXsy8q71ZJzmg@mail.gmail.com>
 <4E494557.8080708@zytor.com> <CAObL_7HAhSaknKRD=0BGWYdZaanX9fOc+i2B74K844T=1r6yGg@mail.gmail.com>
 <4E4964F1.1020900@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 15 Aug 2011 14:35:26 -0400
X-Google-Sender-Auth: -sDfOzprbk5BrXQqzIAMspNYNg4
Message-ID: <CAObL_7GNyj2u1smn+tmg1W+Su4uXL9OgYCT-k+9KPuSS4v0gXQ@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 2:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/15/2011 09:58 AM, Andrew Lutomirski wrote:
>> On Mon, Aug 15, 2011 at 12:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 08/15/2011 08:36 AM, Andrew Lutomirski wrote:
>>>>
>>>> (*)  kernel_fpu_begin is a bad name.  It's only safe to use integer
>>>> instructions inside a kernel_fpu_begin section because MXCSR (and the
>>>> 387 equivalent) could contain garbage.
>>>>
>>>
>>> Uh... no, it just means you have to initialize the settings.  It's a
>>> perfectly good name, it's called kernel_fpu_begin, not kernel_fp_begin.
>>
>> I prefer get_xstate / put_xstate, but this could rapidly devolve into
>> bikeshedding. :)
>>
>
> a) Quite.
>
> b) xstate is not architecture-neutral.

Are there any architecture-neutral users of this thing?  If I were
writing generic code, I would expect:

kernel_fpu_begin();
foo *= 1.5;
kernel_fpu_end();

to work, but I would not expect:

kernel_fpu_begin();
use_xmm_registers();
kernel_fpu_end();

to make any sense.

Since the former does not actually work, I would hope that there is no
non-x86-specific user.

--Andy
