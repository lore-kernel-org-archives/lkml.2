Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab0FQQTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:19:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:40665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab0FQQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:19:38 -0400
Subject: Re: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset
 (OCR): Add and initialize the OCR relaed variable
From: James Bottomley <James.Bottomley@suse.de>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 11:19:30 -0500
Message-ID: <1276791570.7398.12.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 21:54 -0600, Yang, Bo wrote:
> To support online controller reset, driver need to define some
> instance based variable and initialize them.

This doesn't compile:

  CC [M]  drivers/scsi/megaraid/megaraid_sas.o
drivers/scsi/megaraid/megaraid_sas.c: In function
‘megasas_deplete_reply_queue’:
drivers/scsi/megaraid/megaraid_sas.c:2090: warning: unused variable
‘fw_state’
drivers/scsi/megaraid/megaraid_sas.c: In function ‘megasas_init_mfi’:
drivers/scsi/megaraid/megaraid_sas.c:3023: error: ‘struct
megasas_ctrl_prop’ has no member named ‘OnOffProperties’
drivers/scsi/megaraid/megaraid_sas.c: In function ‘megasas_probe_one’:
drivers/scsi/megaraid/megaraid_sas.c:3486: error:
‘process_fw_state_change_wq’ undeclared (first use in this function)
drivers/scsi/megaraid/megaraid_sas.c:3486: error: (Each undeclared
identifier is reported only once
drivers/scsi/megaraid/megaraid_sas.c:3486: error: for each function it
appears in.)

Because OnOffProperties structure is defined in patch 6/12 as is the
process_fw_state_change_wq function.

I've got 1-4 ... please resubmit 5-12 so they actually build in the
order submitted.

Thanks,

James


