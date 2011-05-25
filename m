Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab1EYNYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:24:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64386 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1EYNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j3yBEctgS2uO5TZbMN0QfHzu+HBJlC3lMmt9AsGXAV8Zv4DuMKi/oAB0q4Z6jtHOKb
         rQ0JQd0LTV3MqM5oIhhSahY4wAwomstw+nxBItyb3vHX4MHAsICTJLx4oOUiPqG3Khc+
         pQ/ULAfJJnL5mgUnj1R/I6tPoNP1y5PuDnyMs=
MIME-Version: 1.0
In-Reply-To: <4DDBE4D5.9010000@gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<4DDBE4D5.9010000@gmail.com>
Date: Wed, 25 May 2011 21:24:52 +0800
Message-ID: <BANLkTi=6xB6gyHt4caZwVEZ+qQQnMCTz-A@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        kmpark@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 1:03 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Il 23/05/2011 15:27, Stevie Trujillo ha scritto:
>>
>> Hello,
>>
>> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try
>> to
>
> Yes, or at least was my intention. It's true that this drivers is useful
> when you use an NVRAM, this is typical for the embedded world where the
> platform driver approach is more diffused. Sure at this point the module
> parameters are not useful. In addition the platform data struct doesn't
> define a way to select if to dump only oops. At the end I think a patch it's
> needed here. I have to look at the code to see if it's possible to use the
> platform data OR module parameters. I'll submit a patch.
>

But we have the following code:

        if (reason != KMSG_DUMP_OOPS &&
            reason != KMSG_DUMP_PANIC &&
            reason != KMSG_DUMP_KEXEC)
                return;

which is what you meant by saying "only oops" ?

I still don't think that is a correct way to tell people not to use
ramoops, we need to document this rather than prevent using
it in the code.

Thanks.
