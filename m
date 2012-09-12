Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2ILKWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:22:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:9288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab2ILKWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:22:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzUCu36-3EjzA2RTMTPHOWnekXyHkxWiza=BEvdvhd=hA@mail.gmail.com>
References: <alpine.LRH.2.02.1209121333031.4482@tundra.namei.org>
	<CA+55aFzUCu36-3EjzA2RTMTPHOWnekXyHkxWiza=BEvdvhd=hA@mail.gmail.com>
Date: Wed, 12 Sep 2012 13:22:13 +0300
Message-ID: <CALLzPKZ=rBqRUqb_G6U=5XWoC-ps0qGGphgsPz3iHmAGxSGQnw@mail.gmail.com>
Subject: Re: [GIT] Digital signature library bugfix
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Sep 12, 2012 at 11:34 AM, James Morris <jmorris@namei.org> wrote:
>>
>> -       if (!err && len == hlen)
>> -               err = memcmp(out2, h, hlen);
>> +       if (err || len != hlen) {
>> +               err = -EINVAL;
>> +               goto err;
>> +       }
>> +
>> +       err = memcmp(out2, h, hlen);
>>
>>  err:
>
> Hmm. I'll pull, but this seems to drop the error return from
> pkcs_1_v1_5_decode_emsa() and always replace it with -EINVAL.
>
> Now, I didn't look, and maybe that's the only error that the decode
> thing can return, but still, it looks bad.
>
> Wouldn't it have been better to do instead
>
>    if (err)
>       goto err;
>    err = -EINVAL;
>    if (len != hlen)
>       goto err;
>
> and not overwrite the 'err' return with EINVAL?
>

Error code here just means success or failure.
I did not like it either, but that was just to fix a bug (cc:stable)
and I have one patch more to refactor that stuff for mainline kernel.

But I will re-send updated patch in a moment.

Thanks.

>              Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
