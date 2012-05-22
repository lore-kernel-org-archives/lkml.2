Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab2EVKPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:15:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59397 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2EVKPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:15:17 -0400
Message-ID: <4FBB6730.10802@mev.co.uk>
Date: Tue, 22 May 2012 11:15:12 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: iobase and ioaddr are void
 __iomem *
References: <201205211810.07454.hartleys@visionengravers.com> <20120522081150.GE4637@mwanda>
In-Reply-To: <20120522081150.GE4637@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-22 09:11, Dan Carpenter wrote:
> On Mon, May 21, 2012 at 06:10:07PM -0700, H Hartley Sweeten wrote:
>> @@ -210,7 +210,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
>>   	if (ret<  0)
>>   		return ret;
>>
>> -	devpriv->ioaddr = (void *)(unsigned long)it->options[0];
>> +	devpriv->ioaddr = (void __iomem *)(unsigned long)it->options[0];
>
>
> Obviously, your patch is fine, but I was wondering if it was a
> problem that it->options was only a 32 bit?  Seems like it would
> deserve a comment.

Yes, it's a bit of a strange driver, this one.  It's a driver for a 
module sitting on a PCI card, but there is no driver I know of for the 
PCI card, and I've no idea what's actually ioremap'ing the memory!

Maybe we should quietly drop it and see if anyone complains?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
