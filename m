Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1AGS1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:27:55 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:3787 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1AGS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:27:54 -0500
Date: Fri, 7 Jan 2011 21:27:53 +0300
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: Re: [RESEND PATCH 1/2] init: Add support for root devices to be
 specified by partition name
Message-ID: <20110107182753.GA12012@landau.phys.spbu.ru>
References: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
 <AANLkTindW3TnuP8VA0co-bLT7r2M-jrxTR_sYYQj1rE9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTindW3TnuP8VA0co-bLT7r2M-jrxTR_sYYQj1rE9@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 04:13:27PM +0100, Kay Sievers wrote:
> On Fri, Jan 7, 2011 at 12:42, Kirill Smelkov <kirr@landau.phys.spbu.ru> wrote:
> >  [ In follow-up to b5af921e ]
> >
> > Besides GUIDs, there are also partition names stored in an EFI GPT
> > partition table. So let's add support for root to be located not only by
> > GUID, but also by partition names, like this:
> >
> >    root=PARTNAME=<partition-name>
> 
> Are you sure about this? What's your use case?
>
> Generally, we really don't recommend ever to use any simple labels for
> critical stuff -- not from filesystems, not from partitions.
> 
> I know that some distros did that, but this is pretty misguided, and I
> think, should not be extended to any new facility, unless there is a
> good use case for that.
> 
> Labels are not unique and in the general case absolutely not useful to
> uniquely identify data on a disk. They only make sense for humans, or
> interfaces that visualize things -- they should usually not be used in
> any environment that reliably needs to identify a certain partition.
> We have the uuids  for a reason.

I'm regularly rebuilding flash image for one product and at present in
bootloader we have 

    kernel      /boot/vmlinuz root=LABEL=NAVY-root ...


which requires loading initrd which I've tried to avoid with
root=PARTNAME=... We needed this stuff in the first place so that
device could be booted over compact-flash or usb or whatever.

Yes, this could be changed to using root filesystem uuid (although
labels as you say are easier for humans to understand), and I see your
point about reliability. So sorry for the noise coming from "misguided"
heritage.

Thanks,
Kirill

