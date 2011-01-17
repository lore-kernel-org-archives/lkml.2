Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1AQTQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:16:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51388 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1AQTQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:16:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TL1CIuM6EUUkewMpEZ3T2qbQcsXjsvdG/PDGMV0/uQz8oimANynobamvEeCPhNmEWF
         QWaOwh645GpDGHZiHtuSgq6HG7EalLtJWroMKSK3hJrK6d0mRu71ub3Ns6qwpTl0TTWk
         FJm6AMUNr2NMcoE7I7YwtupGcm0NgHfp8nfAE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101171941560.27021@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162145290.13377@swampdragon.chaosbits.net>
	<AANLkTik+Z5C89Hb9Xu3az=deMsXj4rqvYpU=i7vXgdFx@mail.gmail.com>
	<alpine.LNX.2.00.1101171941560.27021@swampdragon.chaosbits.net>
Date: Mon, 17 Jan 2011 14:09:31 -0500
X-Google-Sender-Auth: Dkfs33Wm_4Uw-Q5JprwjLa9i-HE
Message-ID: <AANLkTimFfyT4M=0=mxfF4ZZjip2wbO27p_zUJg26TO2q@mail.gmail.com>
Subject: Re: [PATCH] NFS4: Avoid potential NULL pointer dereference in decode_and_add_ds().
From: Fred Isaman <iisaman@netapp.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 1:42 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 17 Jan 2011, Fred Isaman wrote:
>
>> On Sun, Jan 16, 2011 at 3:50 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > strrchr() can return NULL if nothing is found. If this happens we'll
>> > dereference a NULL pointer in
>> > fs/nfs/nfs4filelayoutdev.c::decode_and_add_ds().
>> >
>> > I tried to find some other code that guarantees that this can never
>> > happen but I was unsuccessful. So, unless someone else can point to some
>> > code that ensures this can never be a problem, I believe this patch is
>> > needed.
>> >
>>
>> The only guarantee is the assumption that the server isn't sending
>> garbage.  As such, this patch looks good to me.
>>
>
> Thanks. Can I add your Acked-by: if/when I resend the patch?
>

Yes.

Fred

> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
