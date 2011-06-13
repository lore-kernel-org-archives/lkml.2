Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1FMNDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:03:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60661 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1FMNDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=OzViwOquvmU8k78Mp6+x4wXUGnPPNhW24M0C/2iA1FXdxMncAtdJxWzs8/DyM0uyHl
         4eAAOv7TagpSZITdarLBn9dh1dpZ+bukIp+9Ue1dFTH93YcP3+8HIodvjXPb9ymZYsqc
         jNjm+uDS8BehjhkEGRRIUSGlHUg6WxdpGaOeo=
MIME-Version: 1.0
In-Reply-To: <20110613092940.GB8282@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com> <20110613092940.GB8282@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 13 Jun 2011 09:03:22 -0400
X-Google-Sender-Auth: cJwLh-MKi0GiWB6DB9ggzIpRwpE
Message-ID: <BANLkTi=eLODKcTfXb8Z1eAy4KnSE16icow@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 5:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> > Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>> >
>> >   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>> >   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
>>
>> What's the code path that uses ret without initializing it?
>
> If the code is correct but GCC got confused then please use the
> simplest possible patch to help GCC find its way around the code.

The simplest patch is to mark ret as uninitialized_var.

Before making that change, though, I'd like to try to reproduce this,
since it's possible that something's wrong with the BUG macro.  That's
why I'm waiting to hear what gcc version gets the warning.

--Andy
