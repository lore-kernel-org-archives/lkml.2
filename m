Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1FCTMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:12:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35684 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1FCTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FHNzTtOyOnoQENdJdJj83dl7AGbUoGeNK6qu6Bo3lw0U9Agu9fUXq5YyRX+5cL9vvs
         XK7v6BjQsUg6M68M3DZNQXfJjRPkm6LTcC4ZIXH1PUXO516IPg4V3offpLT8Fz0Lp9/7
         6xw9ffkohvaexEyNHhvOZ5ah79S7MyR1Wk0IQ=
MIME-Version: 1.0
In-Reply-To: <20110603135303.0800e4a7@schlenkerla.am.freescale.net>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
	<4DE9294B.3040501@freescale.com>
	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
	<20110603135303.0800e4a7@schlenkerla.am.freescale.net>
Date: Fri, 3 Jun 2011 22:12:37 +0300
Message-ID: <BANLkTikmVncMdJhK0Hi6uWeiE_S9TtdhTQ@mail.gmail.com>
Subject: Re: [PATCH] lib: introduce strdup_from_user
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Timur Tabi <timur@freescale.com>, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:53 PM, Scott Wood <scottwood@freescale.com> wrote:
> On Fri, 3 Jun 2011 21:39:28 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On Fri, Jun 3, 2011 at 9:34 PM, Timur Tabi <timur@freescale.com> wrote:
>> > Would it be better if I did this:
>>
>> The point is data should cross kernelspace/userspace boundary only once.
>>
>
> Why does it matter, as long as it doesn't hurt the kernel if userspace
> plays games (i.e. take care of the NUL termination), and it's not a
> performance problem?

Because now you're lucky C strings are NUL-terminated.
If this "idiom" applies to some other case like "validate + copy",
we have a bug.

We copy data to kernelspace THEN validate or copy or whatever.
This is obviously correct and safe.
