Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2HYJkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 05:40:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48715 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2HYJj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 05:39:56 -0400
Date: Sat, 25 Aug 2012 12:42:49 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number
 when truncating occurs
Message-ID: <20120825124249.6aab8f9e@halley>
In-Reply-To: <CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
	<20120825120231.73577d6a@halley>
	<CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 05:26:51 -0400 Huang Shijie <shijie8@gmail.com> wrote:
> > The specified cmdline partitions might not be ordered (according to
> > start offset), so next partition specified after the truncated one might
> > define a partition at the beginning of the device, which is okay
> > (regardless the truncation of current partition).
> could you please give me an example of this specified cmdline?

Assume we have a 1GB(8Gb) nand chip:
  #gpmi-nand:1g@200m(rootfs),100m@0(boot),100m@100m(kernel)

I am used to explicitly specify size@offset for all my parts.

Obviously I won't define a partition above the device size... somewhat
hypothetical discussion here...

But your code will stop after creating 'rootfs' (and original code will
not create a single partition).

Is that what we want?

Or do we want to truncate 'rootfs', but still have the valid 'boot' and
'kerner' partitions?

Regards,
Shmulik
