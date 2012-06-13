Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2FMR7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:59:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:62468 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab2FMR67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:58:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157212651"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 1/1] hda_intel: switch Intel chipsets to COMBO
 position_fix
Thread-Topic: [PATCH 1/1] hda_intel: switch Intel chipsets to COMBO
 position_fix
Thread-Index: AQHNSPQnAQ6WnVOgV0aFN9pBiC6dUJb4QkAAgABCW5A=
Date: Wed, 13 Jun 2012 17:58:57 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A459FAAF9@ORSMSX101.amr.corp.intel.com>
References: <1339543800-10834-1-git-send-email-seth.heasley@intel.com>
 <s5hsjdzww89.wl%tiwai@suse.de>
In-Reply-To: <s5hsjdzww89.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch implements the COMBO position_fix for recent Intel client
>chipsets.
>>
>> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>
>Thanks for the patch.
>But could you give a bit more context why this change is needed?

The COMBO method was recommended for Intel chipsets by a certain audio maintainer. ;)  It was also tested on the most recent Intel chips because we were seeing warning messages when using DMA positioning ("Invalid position buffer, using LPIB read method instead.").

>> ---
>>  sound/pci/hda/hda_intel.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
>> index 2b6392b..466a88c 100644
>> --- a/sound/pci/hda/hda_intel.c
>> +++ b/sound/pci/hda/hda_intel.c
>> @@ -535,6 +535,7 @@ enum {
>>  #define AZX_DCAPS_BUFSIZE	(1 << 21)	/* no buffer size
>alignment */
>>  #define AZX_DCAPS_ALIGN_BUFSIZE	(1 << 22)	/* buffer size
>alignment */
>>  #define AZX_DCAPS_4K_BDLE_BOUNDARY (1 << 23)	/* BDLE in 4k boundary
>*/
>> +#define AZX_DCAPS_POSFIX_COMBO  (1 << 24)	/* Use COMBO as
>default */
>>
>>  /* quirks for ATI SB / AMD Hudson */
>>  #define AZX_DCAPS_PRESET_ATI_SB \
>> @@ -2728,6 +2729,10 @@ static int __devinit check_position_fix(struct azx
>*chip, int fix)
>>  		snd_printd(SFX "Using LPIB position fix\n");
>>  		return POS_FIX_LPIB;
>>  	}
>> +	if (chip->driver_caps & AZX_DCAPS_POSFIX_COMBO) {
>> +		snd_printd(SFX "Using COMBO position fix\n");
>> +		return POS_FIX_COMBO;
>> +	}
>>  	return POS_FIX_AUTO;
>>  }
>>
>> @@ -3240,7 +3245,7 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
>>  	/* CPT */
>>  	{ PCI_DEVICE(0x8086, 0x1c20),
>>  	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
>> -	  AZX_DCAPS_BUFSIZE },
>> +	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
>>  	/* PBG */
>>  	{ PCI_DEVICE(0x8086, 0x1d20),
>>  	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP | @@ -
>3248,11
>> +3253,11 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
>>  	/* Panther Point */
>>  	{ PCI_DEVICE(0x8086, 0x1e20),
>>  	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
>> -	  AZX_DCAPS_BUFSIZE},
>> +	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
>>  	/* Lynx Point */
>>  	{ PCI_DEVICE(0x8086, 0x8c20),
>>  	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
>> -	  AZX_DCAPS_BUFSIZE},
>> +	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
>>  	/* SCH */
>>  	{ PCI_DEVICE(0x8086, 0x811b),
>>  	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
>> --
>> 1.7.4.4
>>
