Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0GYSww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 14:52:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0GYSwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 14:52:51 -0400
Message-ID: <4C4C87EF.5080605@zytor.com>
Date: Sun, 25 Jul 2010 11:52:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org> <4C4BF0D2.1070503@zytor.com> <4C4BF3C2.1020009@kernel.org>
In-Reply-To: <4C4BF3C2.1020009@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 01:20 AM, Tejun Heo wrote:
> Hello,
> 
> On 07/25/2010 10:07 AM, H. Peter Anvin wrote:
>> Syslinux 4 supports it with full 64-bit capabilities.  SeaBIOS (used in
>> Qemu/KVM) supports it, and I know at least some hardware/firmware RAID
>> solutions support it; I recently got access to a 3 TB SATA drive but due
>> to NDA requirements I can't reveal the results of that testing.
> 
> Hmmm... doesn't sound too bad then.  Is there an easy to test whether
> 64bit LBA works?  I have a 2.5TiB drive and can test the machines I
> have and probably publish the result too.
> 

If you can set up the disk with GPT then just set up a bootable
partition beyond the 2 TiB mark and install Syslinux 4 on it.  (Note:
there is a bug in current versions of gdisk: attribute 2 is the legacy
BIOS bootable attribute, but the author got the bit order wrong and so
you have to set "attribute 61".  parted doesn't support the legacy BIOS
bootable attribute yet.)

If you don't want tomodify the contents of the disk then it can still be
tested, but I don't have a ready-made test for you.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

