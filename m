Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0ERGsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:48:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42304 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab0ERGsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SMwYIsdqFImbknWbCNckFGz1KCAZMs/Lc6UcfmrRlMXdUjsZIAhg/ebn0RbxO4uQRK
         I7hZceNGWnmqT9/D6WkhD/jL56fHLU2k2r0RLVBJWrfQdcSBay7HIzmuabL6e1YZLtSf
         JKpkPIfc039P5NIau7xvp+CeCfecCTH2eYt+U=
MIME-Version: 1.0
In-Reply-To: <20100518063241.GB27262@amit-laptop.redhat.com>
References: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
	 <20100518052230.GA1706@amit-laptop.redhat.com>
	 <AANLkTimXLkzb-CyhbkOaubAOiSsIkGKW0y5Cblrwfvst@mail.gmail.com>
	 <20100518063241.GB27262@amit-laptop.redhat.com>
Date: Tue, 18 May 2010 14:41:35 +0800
Message-ID: <AANLkTinkel3TW8cCY3YCIw_savLuwcQKR67ebX7EmmSU@mail.gmail.com>
Subject: Re: [PATCH] fix a code style in drivers/char/virtio_console.c
From: Steven Liu <lingjiujianke@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

okay, i see, thanks for your regards :)

2010/5/18 Amit Shah <amit.shah@redhat.com>:
> Hello,
>
> On (Tue) May 18 2010 [13:41:29], Steven Liu wrote:
>> Hi, Amit,
>>
>>     if 'err' initialised in this path, it needn't do err = -ENOMEM
>> after,isn't it?
>
> What I mean is if we later add some code that just does:
>
>        if (err)
>                goto fail;
>
> then 'ret' can be -ENOMEM, as it was initialised to, which would be
> fine. But if a later patch adds something like:
>
> +       ret = -EIO;
> +       err = ...
> +       if (err)
> +               goto fail;
> +
>        err = ...
>        if (err)
>                goto fail;
>
> In this case, the 2nd if() would now return EIO instead of ENOMEM as
> earlier.
>
> Also, this style of coding can prevent uninitialised usage of 'ret', eg:
>
>
>        int ret;
>
>        if (err)
>                goto fail;
>
> fail:
>        return ret;
>
> In this case, the compiler will warn about 'ret' being used
> uninitialised.
>
> This is just a coding style issue. I had initially coded it the way your
> patch does, but Rusty asked me to change that and I like this new style
> better: there's less scope for surprises.
>
>                Amit
>
