Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab2C3KFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:05:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758850Ab2C3KFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:05:14 -0400
Message-ID: <4F758554.1060907@canonical.com>
Date: Fri, 30 Mar 2012 11:05:08 +0100
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Andy Whitcroft <robobotbotbot@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>
Subject: Re: [PATCH] PCI: Allow pcie_aspm=force to work even when FADT indicates
 it is unsupported
References: <1332434985-11522-1-git-send-email-colin.king@canonical.com> <CAAq6er0DUGcT_PuL3gOBNdcEVDxhW8EuP1dfFa_Sa9vNZmhfQA@mail.gmail.com>
In-Reply-To: <CAAq6er0DUGcT_PuL3gOBNdcEVDxhW8EuP1dfFa_Sa9vNZmhfQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/12 10:55, Andy Whitcroft wrote:
> On Thu, Mar 22, 2012 at 4:49 PM, Colin King<colin.king@canonical.com>  wrote:
>> From: Colin Ian King<colin.king@canonical.com>
>>
>> Right now using pcie_aspm=force will not enable ASPM if the FADT indicates
>> ASPM is unsupported.  However, the semantics of force should probably allow
>> for this, especially as they did before the ASPM disable rework with commit
>> 3c076351c4027a56d5005a39a0b518a4ba393ce2
>>
>> This patch just skips the clearing of any ASPM setup that the firmware has
>> carried out on this bus if pcie_aspm=force is being used.
>>
>> BugLink: https://bugs.launchpad.net/ubuntu/+bug/962038
>>
>> Signed-off-by: Colin Ian King<colin.king@canonical.com>
>> ---
>>   drivers/pci/pcie/aspm.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
>> index 24f049e..e406429 100644
>> --- a/drivers/pci/pcie/aspm.c
>> +++ b/drivers/pci/pcie/aspm.c
>> @@ -783,6 +783,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
>>   {
>>         struct pci_dev *child;
>>
>> +       if (aspm_force)
>> +               return;
>> +
>>         /*
>>          * Clear any ASPM setup that the firmware has carried out on this bus
>>          */
>> --
>> 1.7.9.1
> Andrew, I believe the above is also needed to fix some additional
> regressions with the new ASPM code.  If you are picking up the one
> below this probably should go with it:
>
>      + aspm-fix-pcie-devices-with-non-pcie-children.patch added to -mm tree
Just to add, I have tested this on a variety of modern SNB i3 based 
laptops (Dell, Lenovo) and also user has tested this and has confirmed 
it works.

Colin
