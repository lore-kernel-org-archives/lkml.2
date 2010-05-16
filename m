Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0EQCTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:19:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:43217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab0EQCTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:19:34 -0400
Subject: Re: SCSI: Support HW reset for EH and polling scheme for scsi
 device
From: James Bottomley <James.Bottomley@suse.de>
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <526DD6EFED664E3099CBA023DA71B89E@areca4e4f859d4>
References: <526DD6EFED664E3099CBA023DA71B89E@areca4e4f859d4>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 May 2010 18:14:31 -0400
Message-ID: <1274048071.14187.127.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 11:13 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSI device existing by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

This still fails to compile with SCSI_ARCMSR_AER:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c:175: error: ‘arcmsr_pci_error_handlers’
undeclared here (not in a function)
make[1]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make: *** [drivers/scsi/arcmsr/arcmsr.ko] Error 2

Making the patch set bisectable means that ordered patches must compile
in the order sent in with all possible configurations.  So patch 1/4
needs to compile on its own ... patch 2/4 needs to compile with patch
1/4 applied and so on.

James


