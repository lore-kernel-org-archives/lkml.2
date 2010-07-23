Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0GWLCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:02:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0GWLCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mlDsJLRGlAcSWYvjt5Bwyj3krZyRuPjuzS9ZgAXAqJeY3Yi03p1jVIh/epsMOzvPD4
         /+pN+rD4JYvoTdLm8SH3drd1TDDg709ZrBbG/93kRjDkeW7UBd0Y1F7xubKf/H7kQWsF
         6hFxuWUJKoTb98StP9qJLvpgbEAjI+/T0LSlc=
MIME-Version: 1.0
In-Reply-To: <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
	<201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
	<4C44066A.3080701@cn.fujitsu.com>
	<201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
Date: Fri, 23 Jul 2010 12:02:20 +0100
Message-ID: <AANLkTi=G-HtjtwqfxH0vkHi8Pf7HQD2GQs_mMeiLYNQH@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: miaox@cn.fujitsu.com, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, zheng.yan@oracle.com,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2010 19:07, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> Am Montag 19 Juli 2010, 10:01:46 schrieb Miao Xie:
>> On Thu, 15 Jul 2010 20:14:51 +0200, Johannes Hirte wrote:
>> > Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
>> >> On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
>> >>> Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
>> >>> I'm not sure if btrfs is to blame for this error. After the errors I
>> >>> switched to XFS on this system and got now this error:
>> >>>
>> >>> ls -l .kde4/share/apps/akregator/data/
>> >>> ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure
>> >>> needs cleaning
>> >>> total 4
>> >>> ?????????? ? ?    ?        ?            ? feeds.opml
>> >>
>> >> What is the error reported in dmesg when the XFS filesytem shuts down?
>> >
>> > Nothing. I double checked the logs. There are only the messages when
>> > mounting the filesystem. No other errors are reported than the
>> > inaccessible file and the output from xfs_check.
>>
>> Is there anything wrong with your disks or memory?
>> Sometimes the bad memory can break the filesystem. I have met this kind of
>> problem some time ago.
>
> I don't think that's the case. I've checked the RAM with memtest86+ and got no
> errors. I got the errors with two different disks, the first one with btrfs the
> second one now with XFS. Before changing to the second disk, I've run
> badblocks on it to be sure it has no errors.

There are some known-buggy chipsets also. One still around is the
Nvidia CK804/MCP55, under certain patterns of spatially-local pending
reads and writes to the memory controller, a 64-byte request would
occasionally be returned with the wrong offset. I was hitting it with
some 27-Gbit adapters and managed to capture it on a PCI-e protocol
analyser. Rsync between network and local disk would hit sometimes
too.
-- 
Daniel J Blueman
