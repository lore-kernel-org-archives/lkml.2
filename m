Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2GMPTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:19:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46655 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2GMPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120628154037.GA28144@twin.jikos.cz>
References: <20120406102232.GH14256@twin.jikos.cz>
	<1334582871-3670-1-git-send-email-arnd@arndnet.de>
	<20120416144233.GC20982@twin.jikos.cz>
	<4FE95B45.8030909@arndnet.de>
	<20120628154037.GA28144@twin.jikos.cz>
Date: Fri, 13 Jul 2012 10:19:14 -0500
Message-ID: <CAKcLGm_cMiEBinmSxkWpY9jm8tW1qbBALcNS-u7DNQhHRF+NFg@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dave@jikos.cz, Arnd Hannemann <arnd@arndnet.de>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ierdnah@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 10:40 AM, David Sterba <dave@jikos.cz> wrote:
> On Tue, Jun 26, 2012 at 08:48:37AM +0200, Arnd Hannemann wrote:
>> How show should we proceed to get above mentioned patch
>> (or the similar patch from Andrei Popa) merged?
>
> Josef picked the patch into btrfs-next, I see not problem to include it
> in next merge window patchset.
>

I was testing the lz4(hc) patches, and I found the the compression
INCOMPAT flags are not being updated using the method in this patch.

The compression INCOMPAT flags are generally checked and updated in
the open_ctree() function.

But, on remount, open_ctree() is not called.

I was going to test a patch to update the INCOMPAT flags similar to
the way lzo INCOMPAT is updated when specifying the compress method in
defragmentation.

http://kerneltrap.org/mailarchive/linux-btrfs/2010/11/18/6886194

But, let me know if it is preferred to just return -EINVAL when trying
to remount with a compression method that has an INCOMPAT not yet seen
by that volume.
