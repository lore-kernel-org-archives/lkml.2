Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1EaM1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:27:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43952 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1EaM1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uoPu+YZagUX3bgJloXK8pNaMDfrbZnL+aP4fPQqz+rAhhLbIN4vzbrewxiW5b6yTri
         bDr2VyUUMMyNbVhxC9dHUA95rNYv5AoDDe8XpatEXGVrv8uKaF+fEr+ahGFfJ3c2I2At
         OzNRlOszv/JYeXvloN6A8EuorM5OopGGyQK0o=
MIME-Version: 1.0
In-Reply-To: <20110531080758.GA24172@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <20110529191924.GD9835@elte.hu>
 <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com> <20110531080758.GA24172@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 08:27:12 -0400
X-Google-Sender-Auth: 5r0h-UntqT0uXeS4NF-p295ZA5k
Message-ID: <BANLkTi=Gi_0Uyj+dA6GjriRU9fCzKuLU=g@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 4:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Sun, May 29, 2011 at 3:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > Btw., do you know CONFIG_X86_PTDUMP=y and /debug/kernel_page_tables?
>> > You could use that to double check that after your patches all
>> > executable (and fixed address) pages are removed [or are harmless].
>>
>> Done.  Now there's only one user-executable page and it's mostly harmless.
>
> ok. Will test your v3 series.
>
>> Maybe I'll try to get rid of vread_tsc and vread_hpet later on to
>> make it even more harmless.
>
> Yeah, that's a good idea. They need pushing into the INT 0xCC
> do_intcc() handler, that's all that's needed AFAICS - or can you see
> other complications with them?
>

They're called from the vDSO.  I think they should just be moved into
the vDSO since they're not used by the vsyscall code any more, but
there are two problems.  The clocksource.vread mechanism (or whatever
its called) won't really work if we let them get relocated (not a big
deal).  More importantly, vread_tsc contains an alternative and the
vDSO can't currently contain alternative instructions.  That can
probably be fixed, but it'll take a bit of work.

--Andy
