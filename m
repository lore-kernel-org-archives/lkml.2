Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2KUR3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:29:37 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:48425 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2KUR3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:29:36 -0500
Date: Wed, 21 Nov 2012 10:29:29 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter.Huewe@infineon.com
Cc: key@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH resend] TPM: Issue TPM_STARTUP at driver load if the TPM
 has not been started
Message-ID: <20121121172929.GA6406@obsidianresearch.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
 <74A44E99E3274B4CB570415926B37D440EC19C@MUCSE501.eu.infineon.com>
 <20121121071015.GD19837@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440F7675@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440F7675@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 08:59:24AM +0000, Peter.Huewe@infineon.com wrote:

> I just gave the new version a run on my beagleboard with our Infineon SLB9635 TT 1.2 Soft I2C TPM
> and it seems to work as expected. (Tested with and without previous startup).
> 
> Tested-by: Peter Huewe <peter.huewe@infineon.com>

Great, I'll send an updated version, thanks!
 
> >+++ b/drivers/char/tpm/tpm.c
> >+#define TPM_ORD_STARTUP cpu_to_be32(153)
> >+#define TPM_ST_CLEAR cpu_to_be16(1)
> >+#define TPM_ST_STATE cpu_to_be16(2)
> >+#define TPM_ST_DEACTIVATED cpu_to_be16(3)
> >+static const struct tpm_input_header tpm_startup_header = {
> >+	.tag = TPM_TAG_RQU_COMMAND,
> >+	.length = cpu_to_be32(12),
> >+	.ordinal = TPM_ORD_STARTUP
> >+};
> >+
> > ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
> > 		   const char *desc)
> > {

> Purely cosmetic question, but why did you define this before the
> tpm_getcap and not tpm_startup?  All the other definitions are made
> before they are used - so this should perhaps better be moved
> directly before tpm_startup.  (Maybe we should move out these
> definitions to a common location? Header?)

Hmm, When I first read through this I thought all these definitions were
being grouped together, easy to move.

> >+struct tpm_startup_in {
> >+	__be16	startup_type;
> >+} __packed;
> 
> 
> All the other user
> __attribute__((packed));
> Care to change to be consistent?

I used to __packed to avoid a checkpatch warning, they should probably
all be changed?

Jason
