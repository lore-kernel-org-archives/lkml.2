Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab2ILQKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:10:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34021 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2ILQKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+MoWDquDi6+kY9z3rj79dJK6j5tSWO9oWHCkvt6J-XBB=HNvA@mail.gmail.com>
References: <1347454564-5178-2-git-send-email-peter.senna@gmail.com>
	<CAH0vN5+ZoexHtmgyZ+s9tiW3LYx+6PMT8aLyYt-T5mnaGXvYbQ@mail.gmail.com>
	<CA+MoWDquDi6+kY9z3rj79dJK6j5tSWO9oWHCkvt6J-XBB=HNvA@mail.gmail.com>
Date: Wed, 12 Sep 2012 13:10:50 -0300
Message-ID: <CAH0vN5KeNB1JfW8n66fse=vuk-ak9LShni7FhVCJ=_kjyEzqcg@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] drivers/media/platform/davinci/vpbe.c: Removes
 useless kfree()
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2012/9/12 Peter Senna Tschudin <peter.senna@gmail.com>:
> Marcos,
>
>> Now that you removed this kfree, you could remove this label too. Very
>> nice your cleanup :)
> Thanks!
>
>>
>>>  vpbe_fail_sd_register:
>>>         kfree(vpbe_dev->encoders);
>>>  vpbe_fail_v4l2_device:
>
> The problem removing the label is that it will require some more work
> naming the labels. See:
> if (!vpbe_dev->amp) {
> ...
>         goto vpbe_fail_amp_register;
>
> If I just remove the label vpbe_fail_amp_register, the label names
> will not make sense any more as the next label is
> vpbe_fail_sd_register. So I will need to change the name to something
> different or rename all labels to out1, out2, out3 or err1, err2,
> err3, or ....

I was looking at the code here, but this code is under
drivers/media/video/davince/vpbe.c....

Are  you using the Linus tree?

BTW, this label is only used once. AFAICS, you can GOTO to the next
label, vpbe_fail_sd_register in this case, who frees another member of
the vpbe_dev.

This make sense to you?

> Any suggestions?
>
> --
> Peter



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
