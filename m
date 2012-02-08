Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BHR0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:26:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41698 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BHR0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <4F32AECE.4010308@zytor.com>
References: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com> <4F32AECE.4010308@zytor.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Feb 2012 18:25:51 +0100
Message-ID: <CAPXgP10OcEc1J4VkCfbMowYR=Ou_F+SqKdDA5kaUAUgjfeiBsw@mail.gmail.com>
Subject: Re: No /dev/root with devtmpfs?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Parsons <lost.distance@yahoo.com>, Kirill Smelkov <kirr@mns.spb.ru>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 18:20, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/08/2012 08:44 AM, Paul Parsons wrote:
>>
>> Could you simply use /etc/fstab to identify the root partition?
>>
>
> That's not a very good thing, as it is much more likely to be wrong.
>
> It would be a good thing to have the /dev/root symlink *IF* a valid root
> device exists (defined as a device node appearing which has the same
> device number as reported by stat on the root directory), if nothing
> else because we have had one available for a very long time and this is
> needless breakage.
>
> Obviously, if such a device doesn't exist (btrfs, NFS, tmpfs) then don't.

Tools should just do the equivalent of:
  $ ls -l /sys/dev/block/$(mountpoint -d /)
  /sys/dev/block/8:1 ->
../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1

and all is fine. I'm convinced, that determining the root device is a
job for *running code* not to expect a symlink to be around.

Kay
