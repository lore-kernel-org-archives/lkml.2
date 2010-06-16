Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab0FPKRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:17:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42087 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0FPKRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h27ShiCG0qQ1t6TDWe1r3nNhhNZVrFNOanH1k9T/iSOpc/dufKbVj/ys/6x3UUYQHL
         NKLxzox8OxSXiW+JrzCH4952vazCzI1alWbmi2zKzuVSiyI14BMSVgkEyvVE9IHqz3IA
         uJ3yeCkfn92R3skCM+Hah5wBnsVxrPL5yZa4o=
MIME-Version: 1.0
In-Reply-To: <AANLkTikYo2fa_dZAkkr-Rq2ocVy0u1jJQDlin1yxX5sz@mail.gmail.com>
References: <AANLkTikYo2fa_dZAkkr-Rq2ocVy0u1jJQDlin1yxX5sz@mail.gmail.com>
Date: Wed, 16 Jun 2010 11:17:37 +0100
X-Google-Sender-Auth: qPNMrO0BMqHgSEToiIL49m5f1Pg
Message-ID: <AANLkTiltMUX2EzJrdsUhBFjPz0LTCYstunpRrzRBee8F@mail.gmail.com>
Subject: Re: Noticed Issue in kmemleak test module if inserted twice
From: Catalin Marinas <catalin.marinas@arm.com>
To: Amit Agarwal <amit.agarr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2010 09:52, Amit Agarwal <amit.agarr@gmail.com> wrote:
> I backported the latest kmemleak(2.6.34-rc1) patches to my 2.6.29-RT kernel
> for ARM target.
> I am facing the issue while inserting the kmemleak-test.ko module twice in
> my 29-RT kernel.
> Step I followed.
> {{{
> # mount -t debugfs nodev /sys/kernel/debug/ # cat /sys/kernel/debug/kmemleak
> # echo scan > /sys/kernel/debug/kmemleak # cat /sys/kernel/debug/kmemleak
>  # insmod kmemleak-test.ko
>  # rmmod kmemleak-test.ko
> # insmod kmemleak-test.ko
> # cat /sys/kernel/debug/kmemleak
> cat: can't open '/sys/kernel/debug/kmemleak': Device or resource busy
> }}}
> I have attached the detail log with the mail.
> I am not clear is this the behaviour of kmemleak

It works fine on the latest kernel, so it's not a kmemleak bug. Most
likely it's a back-porting issue. From the log, kmemleak disabled
itself because of errors (freeing some blocks of memory by a pointer
to somewhere inside the block rather than to the beginning).

All I can say is make sure that the kmemleak_*() callbacks are
correct. The log gives you the backtrace of where kmemleak_free() was
called from, so that should help.

-- 
Catalin
