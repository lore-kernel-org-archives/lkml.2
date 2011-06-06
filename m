Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1FFRqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:46:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50936 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1FFRqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=pLa1fyt8S6tCqstHgFj3dL6KhmXOYf/wA6Jo459GQ7KPP1hrWFO3NZAmXQyMjFnmgS
         /Qh0hEiHwytcB3VyyYdOSkjhYJezjZv6lKshKvFcvvsopF4hbBJS1MIoPeR4j7PyAsFH
         obzvKsn/soJMjxgF50EAP/n/WwKAdHdEvJZCk=
MIME-Version: 1.0
In-Reply-To: <20110606174129.GA6412@elte.hu>
References: <cover.1307380481.git.luto@mit.edu> <bd468a0e02befab146667fab5de57df7332d54d9.1307380481.git.luto@mit.edu>
 <20110606174129.GA6412@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 6 Jun 2011 13:45:52 -0400
X-Google-Sender-Auth: wV5oKVQALdtDPXtrrALlRdq6UqQ
Message-ID: <BANLkTikudFYgtueTAdQjAeEMn1MgjmmM9g@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86-64: Clean up vsyscall emulation and remove
 fixed-address ret
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 1:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> Remove the fixed-address ret in the vsyscall emulation stubs.  As a
>> result, int 0xcc no longer works if executed from user address space
>> (which is OK -- nothing sensible should do that).
>>
>> Removing support for int 0xcc in user address space cleans up the
>> code considerably.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/include/asm/vsyscall.h   |   10 ++++-
>>  arch/x86/kernel/vsyscall_64.c     |   78 +++++++++++--------------------------
>>  arch/x86/kernel/vsyscall_emu_64.S |   17 +--------
>>  3 files changed, 32 insertions(+), 73 deletions(-)
>
> Ok, this makes the whole series a lot more palatable!
>
> Can i propagate the rename suggested by hpa into patch #3:
>
>  CONFIG_COMPAT_VSYSCALL => CONFIG_LEGACY_VSYSCALL

Certainly!  CONFIG_LEGACY_VTIME might be even better, but I'm fine
with any renaming you'd like to do.

--Andy

>
> ? 'legacy' is probably the best name for this and it thus won't be
> confused with the 32-bit compat facilities we have.
>
> Thanks,
>
>        Ingo
>
