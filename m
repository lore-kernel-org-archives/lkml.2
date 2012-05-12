Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2ELRWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 13:22:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:48448 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab2ELRWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 13:22:41 -0400
Message-ID: <4FAE9C59.4030108@mev.co.uk>
Date: Sat, 12 May 2012 18:22:33 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
References: <201205111007.46754.hartleys@visionengravers.com> <4FAD4D20.1010302@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net> <4FAD4F7F.1060603@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net> <4FAD5703.7080504@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698A17ECA@AUSP01VMBX24.collaborationhost.net> <20120511215943.GA27371@kroah.com>
In-Reply-To: <20120511215943.GA27371@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 22:59, gregkh@linuxfoundation.org wrote:
> On Fri, May 11, 2012 at 01:26:37PM -0500, H Hartley Sweeten wrote:
>> How about doing this in the register function:
>>
>> 	If (!pci_driver->name)
>> 		pci_driver->name = comedi_driver->driver_name;
>>
>> This way all the drivers that still need to be refactored will still work.
>>
>> After all the drivers have been updated, those two lines can be
>> removed.
>>
>> So we have this patch and one big patch updating all the refactored
>> drivers. Some number of patches refactoring the remaining drivers
>> and using the module_comedi_pci_driver macro. Then one last
>> patch removing the check above.
>>
>> How does that sound?
>
> That sounds reasonable to me.

Sounds reasonable to me too.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
