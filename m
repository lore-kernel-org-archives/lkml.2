Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1INHCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:02:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63713 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1INHCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxL3aK9kDOdfGUSVzcXJcotFKaQnmJXt4rqgBFL6oo52Q@mail.gmail.com>
References: <20110911213634.GA3065@p183.telecom.by> <CA+55aFxL3aK9kDOdfGUSVzcXJcotFKaQnmJXt4rqgBFL6oo52Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Sep 2011 00:02:00 -0700
X-Google-Sender-Auth: XpCfAf-Wf4MvW6nICyyGG0_my_8
Message-ID: <CA+55aFwEjVL6QH8x1=nS1g=tfdZKO2uN-nbMBaKcAThVfpDJXQ@mail.gmail.com>
Subject: Re: 3.1.0-rc4: oops at elv_put_request()
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: axboe@kernel.dk, jbottomley@parallels.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending selected emails that apparently never went out. But others
are likely just lost forever..

On Sun, Sep 11, 2011 at 2:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Sep 11, 2011 at 2:36 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Caught this one, there was no real load at the moment.
>> FWIW, setup is ext4 over RAID-6 across 4 disks.
>
> Do you have the register state and oops address? Is it a NULL pointer,
> or a case of PAGE_ALLOC_DEBUG or what?
>
> There's commit 94007751bb02 that fixes one md-related oops ("Avoid
> dereferencing a 'request_queue' after last close") but that doesn't
> seem to be the case for you (it needs a __blkdev_put()).
>
>                     Linus
>
