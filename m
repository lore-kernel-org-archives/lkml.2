Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0FXEvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 00:51:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53272 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0FXEvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 00:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vukcV6z25uS7KJnWQ4HIAazVOePLUM5R5EihX2Pm5icShmNjz/xNjf8tJPmpS3dVVK
         cEQLTYQKPtgXXh9zz3osz7hgNRL+ltmB6+5gE/a1Pixe7ymbvrto9sion1fhUCT/Jdkn
         fzPXHa4VJTxRHEWQTprLfgyoS/likGywSBKb8=
MIME-Version: 1.0
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
References: <4C07C321.8010000@redhat.com>
	<AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	<4C1B7560.1000806@gmail.com>
	<AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	<4C1BA3E5.7020400@gmail.com>
	<20100623234031.GF7058@shareable.org>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
Date: Wed, 23 Jun 2010 21:51:12 -0700
X-Google-Sender-Auth: vCFeQOXcPfSYMeyHUrw5YoT5UOg
Message-ID: <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal 
	fragmentation in Btrfs)
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Mat <jackdachef@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       The development of BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor <Daniel.Taylor@wdc.com> wrote:
> Just an FYI reminder.  The original test (2K files) is utterly
> pathological for disk drives with 4K physical sectors, such as
> those now shipping from WD, Seagate, and others.  Some of the
> SSDs have larger (16K0 or smaller blocks (2K).  There is also
> the issue of btrfs over RAID (which I know is not entirely
> sensible, but which will happen).
>
> The absolute minimum allocation size for data should be the same
> as, and aligned with, the underlying disk block size.  If that
> results in underutilization, I think that's a good thing for
> performance, compared to read-modify-write cycles to update
> partial disk blocks.

Block size = 4k

Btrfs packs smaller objects into the blocks in certain cases.
