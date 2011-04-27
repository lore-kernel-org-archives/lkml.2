Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1D0Sts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:49:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56992 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1D0Stq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rFlHBZD9DwpwRi2sLXdohaRWB+rbmPpu32S6PmaRyCysIO48PoBqGP78n03IlJuZha
         IDqpwD+17h44/0Zo3GWjFPr8WSbsWNByW3eFzcJESjZ//c8+xRHPXjXBQr9iOc7pBBfG
         EHvHYZt0wdttuZWRItDqQ3ok4IeS4+ubJQGjQ=
MIME-Version: 1.0
In-Reply-To: <20110427184756.GB16716@parisc-linux.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <20110427183308.GA16716@parisc-linux.org> <BANLkTinPTPMWPN+JELtCZDjrVepLetX6FQ@mail.gmail.com>
 <20110427184756.GB16716@parisc-linux.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 27 Apr 2011 14:49:25 -0400
X-Google-Sender-Auth: 0AWyNS6le27qqvCeXUxjmHuDg-o
Message-ID: <BANLkTikEKXV=dDrTTqXAKU-zBEfnow5juQ@mail.gmail.com>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrea Righi <andrea@betterlinux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 14:47, Matthew Wilcox wrote:
> On Wed, Apr 27, 2011 at 02:39:53PM -0400, Mike Frysinger wrote:
>> > Mmm ... what if I open /dev/sdxyz and call fadvise() on it? ??I think
>> > you end up flushing /dev's page cache entries, instead of the filesystem
>> > which is on /dev/sdxyz.
>>
>> i was thinking of that, but was trying to come up with situations
>> where there might not have a node to work on.  fs's in a file go
>> through loop devs, dm/lvm have ones created, and flash fs's still have
>> a mtd block.  how about network based fs's ?  how you going to signal
>> dropping of pages for nfs or cifs or fuse ones ?
>
> For a regular file, mapping->host->i_sb points to the superblock this
> file is on.  For a device, mapping->host->i_sb points to the superblock
> corresponding to this device.  So it's always what we want.

sorry, wrong question.  i misread your original post (suggesting we
should be calling fadvise on the block instead of an arbitrary dir
handle).
-mike
