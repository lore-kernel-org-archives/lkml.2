Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab1LPNHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:07:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49998 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1LPNHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <201112152053.10535.rjw@sisk.pl>
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
	<1323954769-3918-2-git-send-email-ming.m.lin@intel.com>
	<201112152053.10535.rjw@sisk.pl>
Date: Fri, 16 Dec 2011 21:07:23 +0800
X-Google-Sender-Auth: Vwa_5g2y2AHzaehM4NRGOZMMSTg
Message-ID: <CAF1ivSYcvw0jpERewg=5+hW2aMrf-QzgASX-_1+GGK66o1Giww@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] ahci: port legacy pm interface to struct dev_pm_ops
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/16 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, December 15, 2011, Lin Ming wrote:
>> So we can add runtime pm callbacks later.
>>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>> ---
>>  drivers/ata/ahci.c |   61 +++++++++++++++++++++++++++++++++++-----------------
>>  1 files changed, 41 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index cf26222..c745603 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -84,8 +84,9 @@ static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
>>  static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
>>                               unsigned long deadline);
>>  #ifdef CONFIG_PM
>> -static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
>> -static int ahci_pci_device_resume(struct pci_dev *pdev);
>> +static int ahci_pci_device_suspend(struct device *dev);
>> +static int ahci_pci_device_hibernate(struct device *dev);
>> +static int ahci_pci_device_resume(struct device *dev);
>>  #endif
>>
>>  static struct scsi_host_template ahci_sht = {
>> @@ -400,6 +401,11 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>>       { }     /* terminate list */
>>  };
>>
>> +static struct dev_pm_ops ahci_pci_pm_ops = {
>> +     .suspend                = ahci_pci_device_suspend,
>> +     .resume                 = ahci_pci_device_resume,
>> +     .poweroff               = ahci_pci_device_hibernate,
>> +};
>
> So seem to have forgotten about .restore().  Please define it at least or
> resume from hibernation will be broken.

Will add it.

>
> Also, are .freeze() and .thaw() callbacks really unnecessary?

I'm not sure for now.
Will test hibernation.

Thanks for the comments.

Lin Ming

>
> Rafael
