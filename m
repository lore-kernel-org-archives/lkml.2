Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2LLQNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:13:13 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39268 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2LLQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:13:11 -0500
MIME-Version: 1.0
X-Originating-IP: [63.163.107.100]
In-Reply-To: <CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
References: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com> <CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
From: Leon Romanovsky <leon@leon.nu>
Date: Wed, 12 Dec 2012 08:12:49 -0800
Message-ID: <CALq1K=J_tDiUoQ2u384KjCqPe6YWzRCL=HJbsgkEOfXug4DOhA@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, jaegeuk.kim@samsung.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 7:05 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
>
> On Wed, Dec 12, 2012 at 3:37 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> > +       /* dot and dotdot dentries should have zero-value hash code */
> > +       if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
> > +               return 0;
>
> That looks suspicious. If memcmp(name, "..", 2) == 0 then always
> memcmp(name, ".", 1) == 0. Why two tests ?
It is not the case vice versa, so you still need to do two checks.
You need to distinguish dot(.), dotdot(..) and something with dot at
the beginning (for example - .o)

>
> Fubo.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
