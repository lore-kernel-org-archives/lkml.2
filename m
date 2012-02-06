Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2BFTpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:45:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34403 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2BFTpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
References: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 6 Feb 2012 20:45:24 +0100
Message-ID: <CAPXgP11N=8NULMH-o0Us0OuqYpP9sKe9uUKWzE35h1AiRP1Cjg@mail.gmail.com>
Subject: Re: No /dev/root with devtmpfs?
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 12:18, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> Recently I've reworked my system not to use udev, but use devtmpfs
> instead and discovered there is no /dev/root symlink in devtmpfs case.
>
> My setup uses /dev/root early to know what is the boot device and then
> do some operations on it like checksumming, etc...
>
> Now when /dev/root is gone the best workaround I could come up with is
> to   grep /proc/partitions for '[hs]d[a-z]1'  but it's ugly and will
> break when there are several block devices attached.
>
> Is it somehow possible to add /dev/root to devtmpfs?

No, devtmpfs has no business in knowing anything about the rootfs or
who mounted what ans where. I can not create such links.

The entire concept of /dev/root is flawed anyway, and nothing should
really depend on that.

Modern filesystems will not offer a direct relation to a single block
device, they allocate an superblock which has a major == 0, so there
can be by definition never such a link. Better get rid of all uses of
/dev/root, it will just fail in the future.

Kay
