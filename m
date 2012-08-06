Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2HFQMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:12:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46494 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2HFQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120806141248.GN4352@mwanda>
References: <1344100872-19640-1-git-send-email-develkernel412222@gmail.com>
	<20120806141248.GN4352@mwanda>
Date: Mon, 6 Aug 2012 21:57:52 +0545
Message-ID: <CA+C2MxQ1327Y+Fn+pFwE_bizOmT5WN2EericQL9dmPEeckuM+g@mail.gmail.com>
Subject: Re: [PATCH] staging: sm7xxfb: copy name of the device before calling smtc_alloc_fb_info
From: Devendra Naga <develkernel412222@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:57 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Aug 04, 2012 at 11:06:12PM +0545, Devendra Naga wrote:
>> as we do a strcpy(smdrv_ptr->fb_struct->fix->id, name), and the name here in
>> sm7xxx_probe is not having any assignment, and which leads to copying of the garbage value
>> into the id field of the fix struct of fb interface struct. fix it by copying the name before
>> calling alloc_fbinfo
>>
>> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
>> ---
>>  Only compile tested
>>  This patch is not tested using the hardware... if any one is having this hardware, i request them to
>> please test this
>>  drivers/staging/sm7xxfb/sm7xxfb.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
>> index 1c1780c..d3957ef 100644
>> --- a/drivers/staging/sm7xxfb/sm7xxfb.c
>> +++ b/drivers/staging/sm7xxfb/sm7xxfb.c
>> @@ -798,16 +798,17 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
>>       if (err)
>>               return err;
>>
>> +     sprintf(name, "sm%Xfb", ent->device);
>> +
>>       sfb = smtc_alloc_fb_info(pdev, name);
>>
>> +     sfb->chip_id = ent->device;
>> +
>>       if (!sfb) {
>
> Thanks for fixing this, and well done for spotting the bug.
>
Thanks Dan...

> There is a dereference before the check here, but I see you resent
> this in another thread.  Next time could you respond to the
> original with a message which says to not apply it.
>
Sure but i have a doubt.

since we do V++ after every change to the sent patch , do we really
need to say that please dont apply this patch and there's one more
patch coming with fix?

> regards,
> dan carpenter
>
>

Thanks,
