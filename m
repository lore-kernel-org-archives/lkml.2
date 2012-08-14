Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2HNI7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:59:00 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36653 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab2HNI67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:58:59 -0400
Message-ID: <502A134C.4000406@mev.co.uk>
Date: Tue, 14 Aug 2012 09:58:52 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120728 Thunderbird/14.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
References: <201208031028.18759.hartleys@visionengravers.com> <20120814012949.GA11859@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206AAE977F3@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AAE977F3@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-14 02:36, H Hartley Sweeten wrote:
> On Monday, August 13, 2012 6:30 PM, Greg KH wrote:
>> On Fri, Aug 03, 2012 at 10:28:18AM -0700, H Hartley Sweeten wrote:
>>> Currently the ADLink PCI-7230 and PCI-7432 Isolated Digital
>>> I/O Boards are supported using two drivers (adl_pci7230 and
>>> adl_pci7432). These drivers are very similar and only differ
>>> in the total number of di/do channels provided.
>>>
>>> This driver combines the support for both boards into one
>>> common driver. In addition, it adds PCI PnP support for the
>>> other boards in the ADLink PCI-723x and PCI-743x series.
>>>
>>> This driver only supports the comedi PCI auto config attach
>>> mechanism. The legacy attach using the comedi_config utility
>>> is not supported or required by this driver.
>>
>> I now get the following build warnings on my box with this patch
>> applied:
>>
>> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function ‘adl_pci7x3x_do_insn_bits’:
>> drivers/staging/comedi/drivers/adl_pci7x3x.c:124:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function ‘adl_pci7x3x_di_insn_bits’:
>> drivers/staging/comedi/drivers/adl_pci7x3x.c:150:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>
> Hmm.. My build does not have the [-Wpointer-to-int-cast] for some reason
> so I didn't see this. I was trying to save having to allocate any private data but
> I guess it's cleaner if I do.  BTW, there is another comedi driver that does this
> but I can't recall which one of the top of my head...

You could always cast to unsigned long as that is the same size as a 
pointer, at least in the Linux kernel.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

