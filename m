Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1FKLCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:02:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40280 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1FKLCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=BFVMZVJu626BiPqhnNAuH9qFIIyGqgCeVe3GmfHHsqdhLdUYK6CYBnqcUmDxk43m8x
         LcUPe14+LP/roV4YE2KfQYBQKUPwpVsFMV8IuX5qLuBBYOyBsljuZ1/shLiIAQt9ChBG
         EO0dIV+bGZyZEgv++cveO6CW6aWZiII/KOets=
MIME-Version: 1.0
In-Reply-To: <1307777464.25182.3.camel@localhost.localdomain>
References: <1307777464.25182.3.camel@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 11 Jun 2011 07:01:57 -0400
X-Google-Sender-Auth: 9rsgamDOImHbxYLvA4BFJlsEpKM
Message-ID: <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>
>   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function

What's the code path that uses ret without initializing it?

> -       if (ret == -EFAULT) {
> +       if (ret == -EFAULT || ret == -EINVAL) {
>                /*
>                 * Bad news -- userspace fed a bad pointer to a vsyscall.
>                 *

EINVAL doesn't seem like grounds to fault.  (I'm not sure how to get
EINVAL from time, gettimeofday, or getcpu, but in case there is, we
should return it back to userspace.)

--Andy
