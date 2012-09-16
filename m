Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2IPUXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 16:23:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44273 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2IPUXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 16:23:14 -0400
MIME-Version: 1.0
X-Originating-IP: [72.177.21.136]
In-Reply-To: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
Date: Sun, 16 Sep 2012 15:23:12 -0500
Message-ID: <CAOS_Y6QgFTu9=R4aQuo4J3JMaaCSxTsNmq1rrojFuNf3B3EpUQ@mail.gmail.com>
Subject: Re: Getting debugfs mountpoint?
From: Rob Landley <rob@landley.net>
To: Jacob Sowles <sowlesj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From userspace? Something like:

  grep " debugfs " /proc/mounts | awk '{print $2}' | xargs echo -e

>From kernel space? There isn't guaranteed to be _one_, you can mount
multiple instances of most filesystems, and with container support you can
even have multiple debugfs superblocks.

Rob

On Fri, Sep 14, 2012 at 8:49 PM, Jacob Sowles <sowlesj@gmail.com> wrote:
> Is there an easy way to get the path to where debugfs is mounted? I
> found a function called debugfs_find_mountpoint(), which is exactly
> what I want, but it’s not exported, so I can’t use it. The only
> exported debugfs functions that I could find are the ones that create,
> remove, etc.
>
> Jacob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
