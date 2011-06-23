Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1FWEUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:20:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39675 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1FWEUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rg2+c/r059+4Px5NqkwIe3lTb6EO2LqcXgqIvqRjBe/t/oftPST1Uv4M/z0t2YPWia
         PtW8fmg6VmkAt/iV0qreoeCLpqfijA4Ijsd35l5I8mfKTZvjt9Ik/HICs3CLCawrKfSP
         OXf7VftYj3CMEszEVL7IQJ2Ho5vOmFYRxQpPA=
Message-ID: <4E02BEFB.2030508@gmail.com>
Date: Wed, 22 Jun 2011 21:20:11 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 08/11] spi-dw: Ensure fifo lenght is set.
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com> <BANLkTi=Jv2aVuHqVXh77aGxMFV_Q_wXQCg@mail.gmail.com>
In-Reply-To: <BANLkTi=Jv2aVuHqVXh77aGxMFV_Q_wXQCg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 08:55 PM, Grant Likely wrote:
> On Wed, Jun 22, 2011 at 8:00 PM,<dirk.brandewie@gmail.com>  wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> Bug on fifo_len not being set.  The fifo sizing routine does not work
>> since the txfltr register can not be written while the controller is
>> enabled. The max value of txfltr can be larger than the fifo.  The
>> register allows values upto 0x3f (63) the fifo depth on the Intel
>> SOC's if 40
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> ---
>>   drivers/spi/spi-dw.c |   18 ++----------------
>>   1 files changed, 2 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
>> index ad92826..cc38aa0 100644
>> --- a/drivers/spi/spi-dw.c
>> +++ b/drivers/spi/spi-dw.c
>> @@ -776,25 +776,11 @@ static int destroy_queue(struct spi_dw *dws)
>>   /* Restart the controller, disable all interrupts, clean rx fifo */
>>   static void spi_dw_hw_init(struct spi_dw *dws)
>>   {
>> +       BUG_ON(!dws->fifo_len);
>> +
>
> Ditto here.  BUG is too big a reaction.  Fail to initialize the
> device, sure, and print a warning, but don't BUG.

Ack,  I was trying to make sure the bug got caught while I was working towards 
getting the rest of my changes in.

--Dirk

