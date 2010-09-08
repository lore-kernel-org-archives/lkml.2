Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0IHPTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:19:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0IHPTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:19:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100908145705.GC23745@lixom.net>
References: <20100818041333.GA14149@lixom.net> <20100818171636.0625b668.akpm@linux-foundation.org>
 <20100819032230.GA21980@lixom.net> <20100820010242.GA29588@lixom.net>
 <20100820221323.GC8535@lixom.net> <AANLkTikLLwfSXbnjPByXTktEFFVueeAd7HZS5ft-rj-m@mail.gmail.com>
 <20100908145705.GC23745@lixom.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Sep 2010 17:19:25 +0200
Message-ID: <AANLkTi=jft-j+2Y_dez_gJSrHEkuKSwKq8PbPZxvuHqk@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: add config and runtime option for number of
 mmcblk minors
To: Olof Johansson <olof@lixom.net>
Cc: Lei Wen <adrian.wenl@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mandeep Baines <msb@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 16:57, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Sep 08, 2010 at 10:25:58PM +0800, Lei Wen wrote:
>
>> The patch's purpose is good. As modern sd&mmc is used to host the file
>> system, the 8 partition limitation is becoming a kind of bottleneck...
>> But why not just add GENHD_FL_EXT_DEVT flag to allow mmc use extended
>> partition numbers?
>
> No need to quote the whole patch next time. :)
>
> Given that MMC is sometimes used in deeply embedded environments where
> udev might not be running to take care of dynamic device numbering,
> I chose to stay with a static layout.
>
> I could be convinced otherwise though. It would cause some additional
> hassles for me since we start udev lateish during boot and have a
> prepopulated /dev before that, but that can be dealt with.

I think the extended number are only used for stuff larger than the static 8?

Apart from that, you can not reliably or securely use a static /dev
these days, you never know which device you talk to, because the
kernel has far too many dynamically assigned numbers. For that reason,
most embedded setups use the busybox hack to populate /dev. Recent
kernels have a devfs again, and there is no reason today to continue
any static /dev experiments -- unless someone is going over the entire
tree and fixes all the dynamic assignments, which is unlikely to
happen ever.

Kay
