Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0DSK0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:26:45 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:54056 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0DSK0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZTlLF5dg+IwpCO4YwRRBoxbfPHMM2GTDI6i8/Ktn7xCeoRCpk/pgCy/NkGcqJC+6xe
         4fc7/3XZRh2eVSP8LbrH+/wMdn5oXmr1h/85JPnHHGqNcwxXotoEoXSsGYdhAoIB6MXR
         g2VRVLOjaLUVVzVWI+GicXgYMDu5Ul7f3jvOU=
MIME-Version: 1.0
In-Reply-To: <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
References: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
	 <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
Date: Mon, 19 Apr 2010 15:56:43 +0530
Message-ID: <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
Subject: Re: Dmaengine query
From: rd bairva <rbairva@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Apr 15, 2010 at 6:00 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Apr 13, 2010 at 11:26 PM, rd bairva <rbairva@gmail.com> wrote:
>> Hi Dan,
>>
>>        I am currently writing dmaengine compatible DMA driver for our ARM
>> based architecture, But I am facing some performance issues doing
>> that.
>>
>> 1. dmaengine says callback should run in tasklet, and next transfer
>> cannot be scheduled from the callback.
>>
>> Due to these restrictions I am getting some performance issue while
>> playing sound in our architecture.
>>
>>
>> Can callback call in DMA driver be placed out of spin_lock to submit
>> new operations from callback? (only in asynchronous case)
>>
>> is this Ok? please comment.
>
> Other dma driver authors are dropping the lock across the call to the
> callback in the mem-to-io case.  The compliance points in the
> documentation are primarily targeted at the expectations of the
> async_tx api.  In the mem-to-io (slave dma) model you are not using
> the async_tx api.
>
> --
> Dan
>

    My DMA controller supports device to device DMA transfers and we
need it in some of our drivers. Existing DMA engine framework doesn't
have support for device to device transfers.

Do you have any plans for device to device support in DMA engine?

Can you suggest me some other suggestion for doing this?


Regards
Ramdayal
