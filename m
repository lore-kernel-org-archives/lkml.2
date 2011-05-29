Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1E2UE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:04:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61508 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1E2UE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=BhBmJ+M99kUMfI5e+HeC1lQkgKiST0d5lwOjh6m4nOeZYQp+pS7PFkQ1KFoc5qCOpd
         Sk3f+rX1yszToZjfjbUJWb3If0CDAykfCQkom0tELoiomBv/I6egftJSvrgcrxm5C3zE
         m5r0ElHfWHhqQKtySswQzqhOj+3vbtnL63sYU=
MIME-Version: 1.0
In-Reply-To: <20110529200131.GA23390@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu> <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
 <20110529194922.GC13539@elte.hu> <BANLkTi=w37QWARQCOTLVXQq6EiW0rdDfcw@mail.gmail.com>
 <20110529200131.GA23390@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 16:04:36 -0400
X-Google-Sender-Auth: qp9AB_lkM--3LEhNhO27g8VP5gw
Message-ID: <BANLkTikHQ8+44K8f3tB87XmroX=EQYAS6g@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 4:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Sun, May 29, 2011 at 3:49 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Andrew Lutomirski <luto@mit.edu> wrote:
>> >
>> >> > Ok, i suspect you marked it 0xCC because that's the INT3 instruction
>> >> > - not very useful for exploits?
>> >>
>> >> Exactly.
>> >>
>> >> The comments in irq_vectors.h make it sound like vectors 0x81..0xed
>> >> are used for device interrupts but AFAICT it's only 0x20..0x39 that
>> >> are used, so the precise choice of vector doesn't matter that much.
>> >
>> > No, we use almost all of the vector space for device interrupts. Why
>> > do you think only 0x20..0x39 is used?
>>
>> Possibility my inability to understand all the IRQ mapping code in
>> just half an hour of trying.
>
> Hey, you managed to find all the scattered pieces in just half an
> hour, i'm impressed ;-)

grep and an SSD are amazing.  I'll add the BUG_ON just to satisfy my
paranoia.  I'll also update the comment in irq_vectors.h.

--Andy
