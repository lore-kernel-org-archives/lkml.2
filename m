Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1E3BiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:38:12 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:44984 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1E3BiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=T21R1kCfDOdHoM296D3EcW3UUGguyi7VluvfRXe/hxmLx4irtDqtV2ShCq3/kDJ7d9
         mezSExaTdouwWiyFGv9UDqRE+1++1j7AgulHa8us1UaWtw4U1/o0nzIBv9xrGtLIaUpZ
         OgP34mcii72/cecTUL9iNp3Sog8SKCqzsC3NM=
MIME-Version: 1.0
In-Reply-To: <20110529203402.GB1192@liondog.tnic>
References: <cover.1306517576.git.luto@mit.edu> <80895427afdff1cb56c7f02d567f92ce2e1fa9d8.1306517576.git.luto@mit.edu>
 <20110529203402.GB1192@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 21:37:50 -0400
X-Google-Sender-Auth: VINhta2fMr9Bx3VTizenIRMK2_8
Message-ID: <BANLkTimsB8Q3bxVc5SY9Rk4ecZYWTnqNmg@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86-64: Give vvars their own page
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 4:34 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, May 27, 2011 at 01:38:39PM -0400, Andy Lutomirski wrote:
>> Move vvars out of the vsyscall page into their own page and mark it
>> NX.
>>
>> Without this patch, an attacker who can force a daemon to call some
>> fixed address could wait until the time contains, say, 0xCD80, and
>> then execute the current time.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/include/asm/fixmap.h        |    1 +
>>  arch/x86/include/asm/pgtable_types.h |    2 ++
>>  arch/x86/include/asm/vvar.h          |   22 ++++++++++------------
>>  arch/x86/kernel/vmlinux.lds.S        |   27 ++++++++++++++++-----------
>>  arch/x86/kernel/vsyscall_64.c        |    5 +++++
>>  tools/power/x86/turbostat/turbostat  |  Bin 0 -> 29200 bytes
>
> You've added the turbostat binary to the diffstat too. I believe this
> wasn't your intention, no? :)

Foiled again!

--Andy
