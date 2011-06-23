Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1FWENl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:13:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1FWENk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kX7A2gFwYyhNs1Pp497QeoT5Z5mqJacofTnWc5Zk/++RkFKOCv6ihfwSrEgJ04fUX5
         BWDgTI5m3ZsdzZWcR6a2S6eu9AjVceHh2H4ZUi+ZAzSihj9KDl1OTXiqKErG0AH/71LM
         7ow8KlNMhRdGZ5X0N/t7m5u6/Xv8kXNKJCGys=
Message-ID: <4E02BD72.8040007@gmail.com>
Date: Wed, 22 Jun 2011 21:13:38 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 06/11] spi-dw: Force error on out of range chip select.
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-7-git-send-email-dirk.brandewie@gmail.com> <BANLkTin5CFVm6rVM_c6RRranJEor_jPF=Q@mail.gmail.com>
In-Reply-To: <BANLkTin5CFVm6rVM_c6RRranJEor_jPF=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 08:51 PM, Grant Likely wrote:
> On Wed, Jun 22, 2011 at 8:00 PM,<dirk.brandewie@gmail.com>  wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> BUG_ON() if the selected chip select is out of range.
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> ---
>>   drivers/spi/spi-dw.h |    3 +--
>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
>> index 860bc34..3fa4c13 100644
>> --- a/drivers/spi/spi-dw.h
>> +++ b/drivers/spi/spi-dw.h
>> @@ -178,8 +178,7 @@ static inline void spi_dw_set_clk(struct spi_dw *dws, u16 div)
>>
>>   static inline void spi_dw_chip_sel(struct spi_dw *dws, u16 cs)
>>   {
>> -       if (cs>  dws->num_cs)
>> -               return;
>> +       BUG_ON(cs>= dws->master->num_chipselect);
>
> BUG is rather an over-reaction.  The transfer should be rejected if
> the cs# is invalid, and a warning message is appropriate, but BUG() is
> too extreme.

This is extreme I agree, the current driver will fail silently if an out of 
range chip select is requested.

We can drop this one for now and I will put a proper check in probe/init so we 
won't get here.



>
> g.

