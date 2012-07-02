Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2GBIy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:54:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:40216 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab2GBIyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:54:25 -0400
Message-ID: <4FF161BC.8010104@mev.co.uk>
Date: Mon, 2 Jul 2012 09:54:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Devendra Naga <devendra.aaru@gmail.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] staging/comedi/drivers: free allocated priv and
 release resources if comedi_alloc_subdevices
References: <1341150127-13162-1-git-send-email-devendra.aaru@gmail.com> <20120701153218.GB4462@mwanda>
In-Reply-To: <20120701153218.GB4462@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-01 16:32, Dan Carpenter wrote:
> On Sun, Jul 01, 2012 at 07:12:07PM +0530, Devendra Naga wrote:
>> as comedi_alloc_subdevices may fail, we leak out the memory allocated by alloc_private,
>> and also the I/O regions we requested.
>>
>> free out the private data pointer of the driver, and release the I/O regions.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> This breaks the build.
>
> Also Hartley and Ian, what's the point of alloc_private()?  It's
> just hiding stuff which we need to know about and use later on
> anyway.

Granted, it was more useful before we got kzalloc()!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


