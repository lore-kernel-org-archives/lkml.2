Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2K3Bxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:53:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2K3Bxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:53:49 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4gJ6l1g9Zg8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=D-SQa_yzUHkA:10 a=zFBsKnK20XNvy2LhON8A:9 a=PUjeQqilurYA:10 a=-lNqdChQBFne4Esp:21 a=iyFjtaJlwE_U-uTh:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354240427.6276.134.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] aerdrv: Enhanced AER logging
From: Steven Rostedt <rostedt@goodmis.org>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 20:53:47 -0500
In-Reply-To: <20121129215450.5483.26562.stgit@grignak.americas.hpqcorp.net>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
	 <20121129215450.5483.26562.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 14:54 -0700, Lance Ortiz wrote:

> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -23,6 +23,10 @@
>  
>  #include "aerdrv.h"
>  
> +#define CREATE_TRACE_POINTS
> +#define TRACE_INCLUDE_PATH ../../../../include/ras
> +#include <ras/aer_event.h>
> +

Yuck yuck yuck!

This header should be in the same directory, and you should have in that
same header:

#undef TRACE_INCLUDE_PATH
#define TRACE_INCLUDE_PATH .

and remove the definition here.

-- Steve

>  #define AER_AGENT_RECEIVER		0
>  #define AER_AGENT_REQUESTER		1
>  #define AER_AGENT_COMPLETER		2
> @@ -194,6 +198,8 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  	if (info->id && info->error_dev_num > 1 && info->id == id)
>  		printk("%s""  Error of this Agent(%04x) is reported first\n",
>  			prefix, id);
> +	trace_aer_event(dev_name(&dev->dev), (info->status & ~info->mask),
> +			info->severity);
>  }
>  


