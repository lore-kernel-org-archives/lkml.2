Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1H2BPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 21:15:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:63557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1H2BP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 21:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,294,1312182000"; 
   d="scan'208";a="45804801"
Message-ID: <4E5AE82E.6000807@intel.com>
Date: Mon, 29 Aug 2011 09:15:26 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com> <4E571D66.1070302@intel.com> <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
In-Reply-To: <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000501030502050709070308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000501030502050709070308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, Pavel,

On 08/27/2011 11:28 AM, Pavel Ivanov wrote:
> Huang,
> 
> I can confirm that new patch got rid of the old error message but
> introduced a new one:
> 
> ERST: Failed to get Error Log Address Range

Please try the attached patch to find why there is the error message.

> Also I noticed there's another suspicious message in dmesg and it was
> there earlier too (although it's not shown on console):
> 
> GHES: Failed to enable APEI firmware first mode
> 
> Is it bad? What does it mean?

It means you may receive a unknown NMI without GHES error record for
some detected hardware error.

Best Regards,
Huang Ying

--------------000501030502050709070308
Content-Type: text/x-patch;
 name="dbg_erst_erange.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dbg_erst_erange.patch"

---
 drivers/acpi/apei/erst.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -387,14 +387,17 @@ static int erst_get_erange(struct erst_e
 
 	erst_exec_ctx_init(&ctx);
 	rc = apei_exec_run(&ctx, ACPI_ERST_GET_ERROR_RANGE);
+	pr_info(ERST_PFX "get erange: %d\n", rc);
 	if (rc)
 		return rc;
 	range->base = apei_exec_ctx_get_output(&ctx);
 	rc = apei_exec_run(&ctx, ACPI_ERST_GET_ERROR_LENGTH);
+	pr_info(ERST_PFX "get erange length: %d\n", rc);
 	if (rc)
 		return rc;
 	range->size = apei_exec_ctx_get_output(&ctx);
 	rc = apei_exec_run(&ctx, ACPI_ERST_GET_ERROR_ATTRIBUTES);
+	pr_info(ERST_PFX "get erange attributes: %d\n", rc);
 	if (rc)
 		return rc;
 	range->attr = apei_exec_ctx_get_output(&ctx);

--------------000501030502050709070308--
