Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab0JRUmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:42:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42768 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0JRUmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fvd1NAEqatCOoKdD/ITeqSvWUS82U0d2PPcB/msmwB61NLw3ttBfZGxaOz4mDwlTUg
         gs6IX6AAg87M0ED/+WiG7B0EXuFHzXvip8Eu37v1MXzxdVr5YfsRi7RU2v+W+1bUmhRC
         6unEwekZGtzPQF1tJWCOaDxIMJFdbg+PKPgI8=
MIME-Version: 1.0
In-Reply-To: <20101018184628.GX8781@llucax.com.ar>
References: <20100927163823.GD2834@integratech.com.ar>
	<29C1DC0826876849BDD9F1C67ABA2943090B67EC@ala-mail09.corp.ad.wrs.com>
	<20100929153805.GG2834@integratech.com.ar>
	<29C1DC0826876849BDD9F1C67ABA29430914AC18@ala-mail09.corp.ad.wrs.com>
	<20101001150034.GS8781@llucax.com.ar>
	<0434463FDA60A94FA978ACA44617682DEE843EDD79@EUSAACMS0702.eamcs.ericsson.se>
	<20101001162346.GV8781@llucax.com.ar>
	<4CA69F18.7000005@amln.net>
	<0434463FDA60A94FA978ACA44617682DEE8446A03B@EUSAACMS0702.eamcs.ericsson.se>
	<20101018150422.GV8781@llucax.com.ar>
	<20101018184628.GX8781@llucax.com.ar>
Date: Mon, 18 Oct 2010 16:42:33 -0400
X-Google-Sender-Auth: zlqVceqb4B7Hd0zX76pkYTKEuok
Message-ID: <AANLkTimKbOreV4Fuyw3TbCrk9aa5yBZQSuRbo3Vdx=Q1@mail.gmail.com>
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes [was: TIPC 2.0 and TIPC_SUB_SERVICE]
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Leandro Lucarella <luca@llucax.com.ar>
Cc: Jon Maloy <jon.maloy@ericsson.com>, davem@redhat.com,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 2:46 PM, Leandro Lucarella <luca@llucax.com.ar> wrote:
> Leandro Lucarella, el 18 de octubre a las 12:04 me escribiste:
>> This means D can't be used to write code that uses TIPC if you target
>> kernels >= 2.6.35 (unless they write their own bindings, or at least use
>> a custom TIPC_SUB_SERVICE constant). I could change the TIPC_SUB_SERVICE
>> value, but then people using older kernels will be screwed. Another
>> option is to use the version statement (kind of like C's #ifdef):
>>
>>       version (TIPC_2_0)
>>               const TIPC_SUB_SERVICE = 0x00;
>>       else
>>               const TIPC_SUB_SERVICE = 0x02;
>
> I keep finding problems with this change. Another, no D-related, problem
> with this change is old code could be silently (and very subtly) broken
> if they check for TIPC_SUB_SERVICE as a flag with something like:
>
>        if (s.filter & TIPC_SUB_SERVICE)
>                /* do something */
>
> Because TIPC_SUB_SERVICE has changed its semantics, not just its value,
> and the new value (0x00) will give you always 0 in that test. This one
> is really tricky, because the application code will fail silently, there
> will be no dmesg indication of a failure, nor the connection to the
> topology service be closed. You might get a compiler warning if you're
> lucky.

If you have access to the user space code in question, you can just
switch behaviour semantics based on the results of a uname call, knowing
that this change was included in versions since approx last Feb.  There
is also /proc/version which can be parsed manually if you prefer.

If you have kernel code/modules, you can do the same/similar things with
the KERNEL_VERSION and its support macros.

In either case, you don't have to restrict yourself to information that is
specific to and/or exported just from TIPC itself.

Hope that helps,
Paul.

>
> --
> Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
> ----------------------------------------------------------------------
> GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
> ----------------------------------------------------------------------
> Novocaine for the soul
> you better give me something
> to fill the hole
> before I sputter out
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
