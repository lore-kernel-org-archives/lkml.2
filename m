Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2KZUYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:24:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46318 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab2KZUYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:24:50 -0500
Date: Mon, 26 Nov 2012 14:23:56 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Switch to __packed instead of
 __attribute__((packed))
Message-ID: <20121126202356.GC12737@ennui.austin.ibm.com>
References: <20121121205645.GB15285@obsidianresearch.com>
 <201211212350.24836.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211212350.24836.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112620-7182-0000-0000-0000035A5CCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:50:24PM +0100, Peter Huewe wrote:
> Am Mittwoch, 21. November 2012, 21:56:45 schrieb Jason Gunthorpe:
> > This seems to be preferred these days.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Looks good to me
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Applied. I also rolled in an update to tpm_acpi.c to this commit:

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 56051d0..64420b3 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -33,13 +33,13 @@ struct acpi_tcpa {
 	u16 platform_class;
 	union {
 		struct client_hdr {
-			u32 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
+			u32 log_max_len __packed;
+			u64 log_start_addr __packed;
 		} client;
 		struct server_hdr {
 			u16 reserved;
-			u64 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
+			u64 log_max_len __packed;
+			u64 log_start_addr __packed;
 		} server;
 	};
 };

Thanks,
Kent

> Thanks,
> Peter
> 

