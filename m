Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0GWLO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:14:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51225 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0GWLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i7gOBW/7sQTFUnVNuAn/q+ER7WhH8Djk4MamdJC5UtAJ+MRH2MGcq71ZPIGUk8Z3+D
         Juj67SOlL+N+easGeV2QbDSBdJfHTJmphpZde11+C3/iC1e+mT8AAbAM/CpYrt2IDLNn
         g9EMKuA9rqNbwTud/MJbfnLz4r2HsiwvxllcM=
MIME-Version: 1.0
In-Reply-To: <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
	<201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
	<4C44066A.3080701@cn.fujitsu.com>
	<201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
Date: Fri, 23 Jul 2010 07:14:55 -0400
X-Google-Sender-Auth: TgXZ7eoZjPR-5_q0GzU0PWkZau4
Message-ID: <AANLkTi=ffOv44xziJHTBX0LCUWXqdku30NiHqyTW=AGK@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: miaox@cn.fujitsu.com, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, zheng.yan@oracle.com,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 2:07 PM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
>> Is there anything wrong with your disks or memory?
>> Sometimes the bad memory can break the filesystem. I have met this kind of
>> problem some time ago.
>
> I don't think that's the case. I've checked the RAM with memtest86+ and got no
> errors. I got the errors with two different disks, the first one with btrfs the
> second one now with XFS. Before changing to the second disk, I've run
> badblocks on it to be sure it has no errors.

You might also try kmemcheck.  There's a good chance that a bug
that scribbles random memory shows up as FS corruption.  I have had
ext4 corruption due to an inotify bug, which kmemcheck found on the
first try.

-- 
Bob Copeland %% www.bobcopeland.com
