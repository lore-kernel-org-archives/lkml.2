Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab1FWW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab1FWW4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:56:15 -0400
Message-ID: <4E03C487.7030108@redhat.com>
Date: Thu, 23 Jun 2011 18:56:07 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 05/35] drivers/ata changes for SMBIOS and System Firmware
References: <20110623172240.27628.71518.sendpatchset@prarit.bos.redhat.com> <4E03B110.7060708@garzik.org>
In-Reply-To: <4E03B110.7060708@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/23/2011 05:33 PM, Jeff Garzik wrote:
> On 06/23/2011 01:22 PM, Prarit Bhargava wrote:
>> drivers/ata changes for SMBIOS and System Firmware
>>
>> As part of the new SMBIOS and System Firmware code:
>>
>> - Replace old dmi* structures and functions with new sysfw* and smbios*
>> structures and functions in individual drivers
>> - cleanup sysfw_id lookup tables
>> - cleanup of includes for dmi.h and mod_devicetable.h which were
>> included in
>> some files that did not need them
>>
>> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
>> ---
>>   drivers/ata/acard-ahci.c  |    1 -
>>   drivers/ata/ahci.c        |  177
>> +++++++++++++++++++++++----------------------
>>   drivers/ata/ata_piix.c    |  156
>> +++++++++++++++++++++++-----------------
>>   drivers/ata/pata_ali.c    |   18 +++---
>>   drivers/ata/pata_cs5530.c |   12 ++--
>>   drivers/ata/pata_rdc.c    |    1 -
>>   drivers/ata/pata_sch.c    |    1 -
>>   drivers/ata/pata_via.c    |   14 ++--
>>   drivers/ata/sata_sil.c    |   19 +++---
>>   9 files changed, 210 insertions(+), 189 deletions(-)
>
>
>
>>   #ifdef CONFIG_PM
>> +bool sysfw_match(int field, const char *str)
>> +{
>> +    const char *info = sysfw_lookup(field);
>> +
>> +    if (info == NULL || str == NULL)
>> +        return info == str;
>> +
>> +    return !strcmp(info, str);
>> +}
>
> It is surprising that nobody else needed this.  I would rather that
> this sort of thing go into the generic code, where it lived prior to
> this change.

Jeff,

I took a closer look at this and, in fact, this isn't needed globally
AFAICT.

The issue is that the code really should do sysfw_callback with a
sysfw_id (which currently is a dmi_system_id).  The dmi_system_id struct
only has 4 matches/struct.  I *could* expand that to 8 but it seems like
a waste of space to do so.

But I see your point -- sysfw_match() implies a global function.  I'll
rework this to include a manual strcmp() instead of sysfw_match().  It
seems more appropriate IMO.

I'll post a [v2] shortly.

P.
