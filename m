Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab0ECM7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:59:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868Ab0ECM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:59:51 -0400
Subject: Re: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
 for scsi device(This is correct revision, please ignore last one)
From: James Bottomley <James.Bottomley@suse.de>
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 08:59:45 -0400
Message-ID: <1272891585.4369.15.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
drivers/scsi/arcmsr/arcmsr_hba.c: In function ‘arcmsr_pci_slot_reset’:
drivers/scsi/arcmsr/arcmsr_hba.c:2733: error: too few arguments to
function ‘arcmsr_get_firmware_spec’
make[1]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make: *** [drivers/scsi/arcmsr/arcmsr.ko] Error 2

It looks like you missed converting one of the
arcmsr_get_firmware_spec() to the two argument prototype.

James


