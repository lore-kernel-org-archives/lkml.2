Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1C1O5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:57:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44080 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1C1O5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kYSG2zMJMN54bbqoVcAFFec5Gv35jY/jDrk+ZdEzcaaFT6rPU0+ZHnPQmatCxS7mLD
         h0digzNJgJ+d+M+pTgD+4mryrZx7awqk67ytYH4/Vl3djDMinvXKnp20jt9KyZ2dfCm1
         /sdNSdw7EPRUAJk81YR/ASTrWITCgxT4CIwtU=
MIME-Version: 1.0
In-Reply-To: <4D90A08D.707@zytor.com>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
	<4D90A08D.707@zytor.com>
Date: Mon, 28 Mar 2011 16:56:59 +0200
Message-ID: <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, adobriyan@gmail.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 4:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/28/2011 07:45 AM, tip-bot for Steven Rostedt wrote:
>>
>> WARN_ON_SMP(): Add comment to explain ({0;})
>>
>> The define to use ({0;}) for the !CONFIG_SMP case of WARN_ON_SMP()
>> can be confusing. As the WARN_ON_SMP() needs to be a nop when
>> CONFIG_SMP is not set, including all its parameters must not be
>> evaluated, and that it must work as both a stand alone statement
>> and inside an if condition, we define it to a funky ({0;}).
>>
>> A simple "0" will not work as it causes gcc to give the warning that
>> the statement has no effect.
>>
>> As this strange definition has raised a few eyebrows from some
>> major kernel developers, it is wise to document why we create such
>> a work of art.
>>
>
> What the heck is wrong with the idiomatic and non-gcc-extension-using:
>
>        ((void)0)
>
> ?

AFAIK you cannot use it within an if-statement.

>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
