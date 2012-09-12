Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab2ILPu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:50:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45669 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab2ILPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAH0vN5+ZoexHtmgyZ+s9tiW3LYx+6PMT8aLyYt-T5mnaGXvYbQ@mail.gmail.com>
References: <1347454564-5178-2-git-send-email-peter.senna@gmail.com>
	<CAH0vN5+ZoexHtmgyZ+s9tiW3LYx+6PMT8aLyYt-T5mnaGXvYbQ@mail.gmail.com>
Date: Wed, 12 Sep 2012 17:50:54 +0200
Message-ID: <CA+MoWDquDi6+kY9z3rj79dJK6j5tSWO9oWHCkvt6J-XBB=HNvA@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] drivers/media/platform/davinci/vpbe.c: Removes
 useless kfree()
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Marcos Souza <marcos.souza.org@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcos,

> Now that you removed this kfree, you could remove this label too. Very
> nice your cleanup :)
Thanks!

>
>>  vpbe_fail_sd_register:
>>         kfree(vpbe_dev->encoders);
>>  vpbe_fail_v4l2_device:

The problem removing the label is that it will require some more work
naming the labels. See:
if (!vpbe_dev->amp) {
...
	goto vpbe_fail_amp_register;

If I just remove the label vpbe_fail_amp_register, the label names
will not make sense any more as the next label is
vpbe_fail_sd_register. So I will need to change the name to something
different or rename all labels to out1, out2, out3 or err1, err2,
err3, or ....

Any suggestions?

-- 
Peter
