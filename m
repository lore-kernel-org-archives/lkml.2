Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2BMTbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:31:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57327 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab2BMTa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <4F395AFE.9010802@zytor.com>
References: <20120210090425.GA3997@tugrik.mns.mnsspb.ru> <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com>
 <20120213082539.GA5930@tugrik.mns.mnsspb.ru> <4F395AFE.9010802@zytor.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 13 Feb 2012 20:30:37 +0100
Message-ID: <CAPXgP12W8mTOX5-86sBCJtLACMJWo3ovAiH91VF4JoBq9kxnQA@mail.gmail.com>
Subject: Re: No /dev/root with devtmpfs?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, Paul Parsons <lost.distance@yahoo.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 19:48, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/13/2012 12:25 AM, Kirill Smelkov wrote:
>>>
>>> The bootloader might pass the root partition to the kernel via the
>>> "root=" kernel parameter; these can be read at /proc/cmdline.
>>> For example, on an HP iPAQ hx4700: root=/dev/mtdblock2
>>
>> This does not work universally either, for example for
>>
>>     root=PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF
>>
>>
>> the kernel scans partitions and finds one for root by partition uuid
>> (see name_to_dev_t() in init/do_mounts.c).
>>
>> That's exactly my situation - I have universal flash image which can
>> bee booted via CF slot (on several boards, thus will have different
>> /dev/hd? or /dev/sd?) and via usb/cardreader (again different /dev/
>> entry), and root is mounted by partition id.
>>
>> The kernel has no problem finding root partition and mounting it. I just
>> needed a sane and robust way to know its choice.
>
> In this case it's not the kernel, but the initramfs which does this
> lookup.

root=PARTUUID= is in-kernel mount GTP support, which works without an initramfs.

> In that case the initramfs could/should create /dev/root.

We dropped all that in initramfs for the earlier in this thread
mentioned reasons.

/dev/root is not what we want, or what tools should expect to be there
today; it will not work with modern filesystems, which have no
single-device relationship.

Kay
