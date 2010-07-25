Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0GYHuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 03:50:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0GYHuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 03:50:13 -0400
Message-ID: <4C4BECA2.3090709@kernel.org>
Date: Sun, 25 Jul 2010 09:49:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Greg Freemyer <greg.freemyer@gmail.com>,
        Yuhong Bao <yuhongbao_386@hotmail.com>, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com> <20100724232247.GA2129@khazad-dum.debian.net>
In-Reply-To: <20100724232247.GA2129@khazad-dum.debian.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 25 Jul 2010 07:49:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/25/2010 01:22 AM, Henrique de Moraes Holschuh wrote:
> On Sat, 24 Jul 2010, Greg Freemyer wrote:
>> Secondly, if you look at the table on the right of
>> http://en.wikipedia.org/wiki/Master_boot_record#Disk_partitioning you
>> see that the starting sector of a partition is defined with a 32-bit
>> value.
>>
>> ie. 2TB with 512 byte sectors.
>>
>> The normal solution is to move to a GPT which requires EFI if you want
>> to boot from it.
> 
> Can't one have a GPT with a guard boot sector which can read the real
> partition table?

Yeah, parted already does that although there seem to be some bugs and
they sometimes are inconsistent.  In principle, BIOSes don't really
care about the partition table (they look at it primarily to figure
out geometry and stuff) and can boot as long as the initial boot
sector is accessible.

> I think Tejun must mean some big problem at the BIOS APIs required for the
> bootloader.  Tejun, what exactly croaks at the 2TB boundary (with 512KiB
> sectors)?
	
The 2TiB limit is coming from BIOS software interrupt for disk access
using 32bit for addressing.  If there's 64bit extension to BIOS disk
access, everything should work but still locating boot partition under
2TiB is pretty much required at this point, I think.

Thanks.

-- 
tejun
