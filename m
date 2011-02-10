Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1BJRO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:14:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34580 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BJRO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w3tECb7bGMRy5ELgRJT7p+yVXnA84qtq+MlBd1+wWJaGpYIytqPtOh9fYIMuZEUTlD
         3Lur8ZtnoCop/VHTLf9eapCzvRB97DaIeu6h+NoS7zWJtw2eUuEt+pLZePcugo+SDroo
         SVcOboW2SeGIR3uE3ISrhCD9zddud9fyLfnHQ=
MIME-Version: 1.0
In-Reply-To: <4D53F4ED.10903@ru.mvista.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<4D53F4ED.10903@ru.mvista.com>
Date: Thu, 10 Feb 2011 18:14:54 +0100
Message-ID: <AANLkTinPYo+mhiRwsNpdNgqADQbk7bvQX=RcZoiN0pbS@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 10, 2011 at 3:23 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:
> [...]
>
>> We may need to set SITRE before programming slave_data.
>
>> This makes pata_efar match the behavior of IDE's slc90e66 host driver
>> and also of libata's ata_piix one.
>
>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>
> [...]
>
>> diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
>> index 1e2ff7d..7f564d7 100644
>> --- a/drivers/ata/pata_efar.c
>> +++ b/drivers/ata/pata_efar.c
>> @@ -74,10 +74,12 @@ static void efar_set_timings(struct ata_port *ap,
>> struct ata_device *adev,
>>                             u8 pio, bool use_mwdma)
>>  {
>>        struct pci_dev *dev     = to_pci_dev(ap->host->dev);
>> +       unsigned int is_slave   = (adev->devno != 0);
>
>   What's the point of this variable? To save one pointer dereference? :-)

Make code more similar to ata_piix.c and thus easier for comparisons
through 'diff -ub'.

In reality it doesn't matter now that much as pata_efar (same for
pata_oldpiix) vanishes completely at the end of the patch series.. :-)

Thanks,
Bartlomiej
