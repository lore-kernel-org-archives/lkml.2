Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0F3L6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:58:14 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:32874 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0F3L6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:58:13 -0400
X-Auth-Info: AHOtIsXN/jIL7LzxtQpwQNcWE2iFAAC0Ld/Bq2y82ek=
To: Rupjyoti Sarmah <rsarmah@amcc.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, rsarmah@apm.com, linuxppc-dev@ozlabs.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <201006241327.o5ODRY6m032299@amcc.com>
References: <201006241327.o5ODRY6m032299@amcc.com>
Comments: In-reply-to Rupjyoti Sarmah <rsarmah@amcc.com>
   message dated "Thu, 24 Jun 2010 18:57:34 +0530."
Date: Wed, 30 Jun 2010 13:58:08 +0200
Message-Id: <20100630115808.2D9241524EC@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rupjyoti Sarmah,

In message <201006241327.o5ODRY6m032299@amcc.com> you wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> 
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
> 
> ---
> This patch incorporates the changes advised in the mailing list. The device
> tree changes were submitted as a seperate patch. 

Which kernel is this patch supposed to be applied to?

Using current mainline (v2.6.35-rc3-262-g984bc96) the patch applies
without problems, but when I enable it in the kernel configuration I
get this:

drivers/ata/sata_dwc_460ex.c:43:1: warning: "DRV_NAME" redefined
In file included from drivers/ata/sata_dwc_460ex.c:38:
drivers/ata/libata.h:31:1: warning: this is the location of the previous definition
drivers/ata/sata_dwc_460ex.c:44:1: warning: "DRV_VERSION" redefined
drivers/ata/libata.h:32:1: warning: this is the location of the previous definition
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_read':
drivers/ata/sata_dwc_460ex.c:777: error: 'struct ata_port' has no member named 'ioaddr'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_scr_write':
drivers/ata/sata_dwc_460ex.c:793: error: 'struct ata_port' has no member named 'ioaddr'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_error_intr':
drivers/ata/sata_dwc_460ex.c:844: error: 'struct ata_port_operations' has no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_isr':
drivers/ata/sata_dwc_460ex.c:953: error: 'struct ata_port_operations' has no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c:957: error: 'struct ata_port_operations' has no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c:991: error: implicit declaration of function 'ata_sff_hsm_move'
drivers/ata/sata_dwc_460ex.c:1030: error: 'struct ata_port_operations' has no member named 'sff_check_status'
drivers/ata/sata_dwc_460ex.c: At top level:
drivers/ata/sata_dwc_460ex.c:1213: warning: 'struct ata_ioports' declared inside parameter list
drivers/ata/sata_dwc_460ex.c:1213: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_setup_port':
drivers/ata/sata_dwc_460ex.c:1215: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1216: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1218: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1219: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1221: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1223: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1224: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1225: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1227: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1228: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1229: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1231: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c:1232: error: dereferencing pointer to incomplete type
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_port_start':
drivers/ata/sata_dwc_460ex.c:1273: error: 'struct ata_port' has no member named 'bmdma_prd'
drivers/ata/sata_dwc_460ex.c:1274: error: 'struct ata_port' has no member named 'bmdma_prd_dma'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_exec_command_by_tag':
drivers/ata/sata_dwc_460ex.c:1356: warning: passing argument 1 of 'ata_get_cmd_descript' makes integer from pointer without a cast
drivers/ata/sata_dwc_460ex.c:1369: error: implicit declaration of function 'ata_sff_exec_command'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_qc_issue':
drivers/ata/sata_dwc_460ex.c:1512: error: 'struct ata_port_operations' has no member named 'sff_tf_load'
drivers/ata/sata_dwc_460ex.c:1516: error: implicit declaration of function 'ata_sff_qc_issue'
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_error_handler':
drivers/ata/sata_dwc_460ex.c:1545: error: implicit declaration of function 'ata_sff_error_handler'
drivers/ata/sata_dwc_460ex.c: At top level:
drivers/ata/sata_dwc_460ex.c:1564: error: 'ata_sff_port_ops' undeclared here (not in a function)
drivers/ata/sata_dwc_460ex.c:1577: error: unknown field 'bmdma_setup' specified in initializer
drivers/ata/sata_dwc_460ex.c:1577: warning: initialization from incompatible pointer type
drivers/ata/sata_dwc_460ex.c:1578: error: unknown field 'bmdma_start' specified in initializer
drivers/ata/sata_dwc_460ex.c:1578: warning: initialization from incompatible pointer type
drivers/ata/sata_dwc_460ex.c: In function 'sata_dwc_probe':
drivers/ata/sata_dwc_460ex.c:1638: error: 'struct ata_port' has no member named 'ioaddr'
drivers/ata/sata_dwc_460ex.c:1639: error: 'struct ata_port' has no member named 'ioaddr'
drivers/ata/sata_dwc_460ex.c:1641: error: 'struct ata_port' has no member named 'ioaddr'
make[2]: *** [drivers/ata/sata_dwc_460ex.o] Error 1
make[1]: *** [drivers/ata] Error 2
make: *** [drivers] Error 2


Does this require any specific kernel version?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
A direct quote from the Boss: "We passed over a lot of good people to
get the ones we hired."
