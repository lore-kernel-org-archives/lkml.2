Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab0HET3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:29:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49827 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab0HET3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <1280946126-19587-3-git-send-email-wad@chromium.org>
References: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com> 
	<1280946126-19587-3-git-send-email-wad@chromium.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 5 Aug 2010 21:29:27 +0200
Message-ID: <AANLkTi=Xets_QkMPpy+Z3F+H8pVP6OjiMjTWhUhsS8eR@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] init: add support for root devices specified by 
	partition UUID
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 20:22, Will Drewry <wad@chromium.org> wrote:
> This is the third patch in a series which adds support for
> storing partition metadata, optionally, off of the hd_struct.
>
> One major use for that data is being able to resolve partition
> by other identities than just the index on a block device.  Device
> enumeration varies by platform and there's a benefit to being able
> to use something like EFI GPT's GUIDs to determine the correct
> block device and partition to mount as the root.
>
> This change adds that support to root= by adding support for
> the following syntax:
>
>  root=PARTUUID=hex-uuid

Just an update:

There is still no better idea than using this notation. We should
distinguish between filesystem and partiton UUIDs, and overloading
/dev with magic strings that will never exist there doesn't sound like
a good idea.

I checked with Karel, and fstab supports UUID=, initramfs tools
support root=UUID=, so we are probably going to have PARTUUID support
in fstab and initramfs too when we get there.

Kay
