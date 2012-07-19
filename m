Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2GSTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:31:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51084 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2GSTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:31:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120719012805.GD17430@twin.jikos.cz>
References: <20120406102232.GH14256@twin.jikos.cz>
	<1334582871-3670-1-git-send-email-arnd@arndnet.de>
	<20120416144233.GC20982@twin.jikos.cz>
	<4FE95B45.8030909@arndnet.de>
	<20120628154037.GA28144@twin.jikos.cz>
	<CAKcLGm_cMiEBinmSxkWpY9jm8tW1qbBALcNS-u7DNQhHRF+NFg@mail.gmail.com>
	<20120719012805.GD17430@twin.jikos.cz>
Date: Thu, 19 Jul 2012 14:31:27 -0500
Message-ID: <CAKcLGm-UYXYM2nP=iW1o5gdFYh4mi_XGFPGKfd054xvvGfAc=w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: allow mount -o remount,compress=no
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dave@jikos.cz, Mitch Harder <mitch.harder@sabayonlinux.org>,
        Arnd Hannemann <arnd@arndnet.de>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ierdnah@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 8:28 PM, David Sterba <dave@jikos.cz> wrote:
> On Fri, Jul 13, 2012 at 10:19:14AM -0500, Mitch Harder wrote:
>> I was testing the lz4(hc) patches, and I found the the compression
>> INCOMPAT flags are not being updated using the method in this patch.
>>
>> The compression INCOMPAT flags are generally checked and updated in
>> the open_ctree() function.
>>
>> But, on remount, open_ctree() is not called.
>
> This currently happens with lzo as well, right?
>

Yes, this will happen with lzo as implemented in the patch at the head
of this thread.

>
> My preference is to let remount succeed and set the incompat bit,
> possibly with a KERN_INFO message to syslog in case the bit is yet
> unseen by the volume.
>

Great.

I've put together a patch that does just that, and I've been testing
it to make sure it works as intended.

I'll finish it up and send it to the list tomorrow.

This patch will only address the lzo INCOMPAT from the remount
capabilities provided by the patch at the head of the thread.

A similar modification will be needed for lz4 patches that allow for remount.
