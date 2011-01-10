Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1AJRCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:02:06 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59430 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1AJRCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nYTTD8okzq8X444E3MVMh6eRuBVQS7ahzB00c+bv2ECCmbaDbyVwmZr6BXIc2qvDH8
         u1wCkrWIi2+R37q0w6WJf1X92cBrpwx6Sw/cn7O+aRcSWS1X43rvr8tUtd1//CjXKWaZ
         jEtTzXHDrks2AETYHphAvT4q2B++GJfcGkJe0=
MIME-Version: 1.0
In-Reply-To: <77BC89B5-DFC2-4908-8875-59BCD00DC10F@marvell.com>
References: <cover.1294588491.git.tardyp@gmail.com>
	<6191610532f25d7cda435781ce9b83bfdb677b5a.1294588491.git.tardyp@gmail.com>
	<77BC89B5-DFC2-4908-8875-59BCD00DC10F@marvell.com>
Date: Mon, 10 Jan 2011 18:02:02 +0100
Message-ID: <AANLkTinKp6-eR9zK4pddqnBTKoawiaoq4zfEUKk2Qr=u@mail.gmail.com>
Subject: Re: [PATCH 1/3] mmc: add per device quirk placeholder
From: Pierre Tardy <tardyp@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pierre Tardy <pierre.tardy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +     for (f = mmc_fixup_methods; f->hook; f++) {
>> +             if ((f->vendor == card->cis.vendor
>> +                  || f->vendor == (u16) SDIO_ANY_ID) &&
>> +                 (f->device == card->cis.device
>> +                  || f->device == (u16) SDIO_ANY_ID)) {
>> +                     dev_dbg(&card->dev, "calling %pF\n", f->hook);
>> +                     f->hook(card, f->data);
>
>
> hook is not a very nice name ---  something more meaningful:  vendor_fixup  ?
I just copied the pci/quirks.c way of doing. I think is more coherent
to keep is this way, this name will forever appear only in 4 lines
inside the kernel, so I dont care that much.
I'll change that if you really do care. :-)

Waiting for a few more comments to do all in a row.

Thanks,
-- 
Pierre
