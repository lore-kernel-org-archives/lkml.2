Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab0ECNSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:18:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45233 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab0ECNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:18:04 -0400
Reply-To: <nick.cheng@areca.com.tw>
From: "Nick Cheng" <nick.cheng@areca.com.tw>
To: "'James Bottomley'" <James.Bottomley@suse.de>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4> <1272891585.4369.15.camel@mulgrave.site>
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme for scsi device(This is correct revision, please ignore last one)
Date: Mon, 3 May 2010 21:17:52 +0800
Organization: Areca Technology
Message-ID: <543391074648471F8A10624BAC48E286@areca4e4f859d4>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1272891585.4369.15.camel@mulgrave.site>
Thread-Index: AcrqwIUIBjCMIbZ6T8Gkh9Ewg7MhhwAAfjFw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,
It seems you set CONFIG_SCSI_ARCMSR_AER.
Could you undefine it?
I will remove this section.
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, May 03, 2010 9:00 PM
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
for scsi device(This is correct revision, please ignore last one)

On Mon, 2010-05-03 at 15:45 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSI device existing by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

This patch still isn't compiling:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_pci_slot_reset':
drivers/scsi/arcmsr/arcmsr_hba.c:2733: error: too few arguments to
function 'arcmsr_get_firmware_spec'
make[1]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make: *** [drivers/scsi/arcmsr/arcmsr.ko] Error 2

It looks like you missed converting one of the
arcmsr_get_firmware_spec() to the two argument prototype.

James


