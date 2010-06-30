Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0F3UDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:03:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38398 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab0F3UDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:03:49 -0400
Date: Wed, 30 Jun 2010 16:03:25 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-ide@vger.kernel.org, sr@denx.de,
       Rupjyoti Sarmah <rsarmah@apm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>
Message-ID: <20100630200325.GD7756@zod.rchland.ibm.com>
References: <201006241327.o5ODRY6m032299@amcc.com> <20100630115808.2D9241524EC@gemini.denx.de> <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com> <20100630184728.C02D014EBF9@gemini.denx.de> <4C2B9831.9020801@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2B9831.9020801@pobox.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 03:17:05PM -0400, Jeff Garzik wrote:
> On 06/30/2010 02:47 PM, Wolfgang Denk wrote:
>> Dear Rupjyoti Sarmah,
>>
>> In message<3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com>  you wrote:
>>>
>>> I took the mainline kernel v2.6.35-rc3 and downloaded using the git
>>> download link.
>>> I created the patch on 6/24/2010 after doing a git pull.
>>
>> I don;t think that you used v2.6.35-rc3; using this version, I still
>> get this:
>>
>> drivers/ata/sata_dwc_460ex.c:43:1: warning: "DRV_NAME" redefined
>> In file included from drivers/ata/sata_dwc_460ex.c:38:
>> drivers/ata/libata.h:31:1: warning: this is the location of the previous definition
>> drivers/ata/sata_dwc_460ex.c:44:1: warning: "DRV_VERSION" redefined
>> drivers/ata/libata.h:32:1: warning: this is the location of the previous definition
>> drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_read':
>> drivers/ata/sata_dwc_460ex.c:777: error: 'struct ata_port' has no member named 'ioaddr'
>> drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_write':
>> drivers/ata/sata_dwc_460ex.c:793: error: 'struct ata_port' has no member named 'ioaddr'
>> drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_error_intr':
>> drivers/ata/sata_dwc_460ex.c:844: error: 'struct ata_port_operations' has no member named 'sff_check_status'
>
> It looks like -your- build config is missing CONFIG_ATA_SFF or similar.
>
> If you actually look at include/linux/libata.h, you see that struct  
> ata_port_operations most definitely has a member named sff_check_status,  
> for example.  Ditto ata_port and member ioaddr, etc.

The driver doesn't depend on CONFIG_ATA_SFF in it's Kconfig file, but seems to
require it at build time.  Isn't that something that needs fixing in the
driver?

josh
