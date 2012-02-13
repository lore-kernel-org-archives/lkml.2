Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2BMSsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:48:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425Ab2BMSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:48:49 -0500
Message-ID: <4F395AFE.9010802@zytor.com>
Date: Mon, 13 Feb 2012 10:48:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Kirill Smelkov <kirr@mns.spb.ru>
CC: Paul Parsons <lost.distance@yahoo.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
References: <20120210090425.GA3997@tugrik.mns.mnsspb.ru> <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com> <20120213082539.GA5930@tugrik.mns.mnsspb.ru>
In-Reply-To: <20120213082539.GA5930@tugrik.mns.mnsspb.ru>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 12:25 AM, Kirill Smelkov wrote:
>>
>> The bootloader might pass the root partition to the kernel via the
>> "root=" kernel parameter; these can be read at /proc/cmdline.
>> For example, on an HP iPAQ hx4700: root=/dev/mtdblock2
> 
> This does not work universally either, for example for
> 
>     root=PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF
> 
> 
> the kernel scans partitions and finds one for root by partition uuid
> (see name_to_dev_t() in init/do_mounts.c).
> 
> That's exactly my situation - I have universal flash image which can
> bee booted via CF slot (on several boards, thus will have different
> /dev/hd? or /dev/sd?) and via usb/cardreader (again different /dev/
> entry), and root is mounted by partition id.
> 
> The kernel has no problem finding root partition and mounting it. I just
> needed a sane and robust way to know its choice.
> 

In this case it's not the kernel, but the initramfs which does this
lookup.  In that case the initramfs could/should create /dev/root.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

