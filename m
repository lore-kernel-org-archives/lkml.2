Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0HUHfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:35:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42194 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0HUHfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Oq0DWtllljBaVbbo9ZDtorVlPFViZAmFVixEi9/RuphSi4RX4EJojyDIhVvYuQdhud
         euowbzI/IA7gZ7N5NZv44HNAxB7KxZYZUeKpj7tow7dEAA/kvzPymErEAWWm9KahOVAY
         XC9wF1yVcOFTYKWYefcDk1rbpqe/yjtRCpr8o=
MIME-Version: 1.0
In-Reply-To: <4C6E79B2.1040309@s5r6.in-berlin.de>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<1282293963-27807-2-git-send-email-mitr@redhat.com>
	<4C6E79B2.1040309@s5r6.in-berlin.de>
Date: Sat, 21 Aug 2010 09:35:44 +0200
Message-ID: <AANLkTikM44mbBdYt1EWgXJYEFqY4F0_umG74-6eL2xW=@mail.gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/20 Stefan Richter <stefanr@s5r6.in-berlin.de>:

>> +struct ncr_session_input_data {
>> +     const void __user *data;
>> +     __kernel_size_t data_size;
>> +};
>> +
>> +};
> Why not using fixed-size fit-all members?
> struct ncr_session_input_data {
>        __u64 data;             /* user pointer, cast to/from u64 */
>        __u32 data_size;        /* or __u64? */
> };

A reason is that using (void*) is cleaner as an API. It avoids the
pointer to int casting and the warnings that such a cast will have.

regards,
Nikos
