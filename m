Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1DSLAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:00:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53097 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1DSLAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=GhzRoDyufTYPwQzp/wOXuWZhgdKjrqvwL3Yv2bR/RKGF9FQDKeyRgnOoEOrUvZVg1t
         olb4d3L6uO5Ea8VfXnkS54QztbKGy6n2UIVU8yrztT4J3IKQaWwp2J36fpA7PFEf1dSH
         gd00bQ4yzbpQbemIonx6J5CHi8GgJ/8j5b4Sg=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 13:00:30 +0200
X-Google-Sender-Auth: o4ts1VOCaCdXTbt-ghrTvbeWAAA
Message-ID: <BANLkTi=zNkSkD7L8f0pkZ2+j5pGcGhCYJA@mail.gmail.com>
Subject: =?UTF-8?Q?fs=2Fbtrfs=2Finode=2Ec=3A6039=3A_warning=3A_=E2=80=98bio=E2=80=99_is_used_un?=
	=?UTF-8?Q?initialized_in_this_function?=
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/btrfs/inode.c: In function ‘btrfs_submit_direct_hook’:
fs/btrfs/inode.c:6039: warning: ‘bio’ is used uninitialized in this function

`BIO_BUG_ON(!atomic_read(&bio->bi_cnt))' in bio_put() later will blow up nicely
when passed a random pointer on the stack.

Introduced by commit 02f57c7aedef1a537f4b16db7061cdd8efa3bb4e
("Btrfs: don't split dio bios if we don't have to").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
