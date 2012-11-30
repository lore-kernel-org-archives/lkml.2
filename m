Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036Ab2K3QnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:43:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39435 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2K3QnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:43:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121130143110.GD11004@shiny.int.fusionio.com>
References: <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny> <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny> <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
 <20121130024910.GF6434@dastard> <20121130143110.GD11004@shiny.int.fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Nov 2012 08:42:56 -0800
X-Google-Sender-Auth: Gh0JHqxPqQqLel49-P9TXqcjEt4
Message-ID: <CA+55aFyW2ksiv97u5JwC5OUafD_dN=4+sU+YyDM4=aQfkj9s3A@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 6:31 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Thu, Nov 29, 2012 at 07:49:10PM -0700, Dave Chinner wrote:
>>
>> Same with mpage_readpages(), so it's not just direct IO that has
>> this problem....
>
> I guess the good news is that block devices don't have readpages.  The
> bad news would be that we can't put readpages in without much bigger
> changes.

Well, the new block-dev branch no longer cares. It basically says "ok,
we use inode->i_blkbits, but for raw device accesses we know it's
unstable, so we'll just not use it".

So both mpage_readpages and direct-IO should be happy. And it actually
removed redundant code, so it's all good.

                 Linus
