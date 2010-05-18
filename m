Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0ERVwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:52:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38712 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0ERVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:52:52 -0400
Message-ID: <4BF30BF8.8080202@oracle.com>
Date: Tue, 18 May 2010 14:51:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: lenb@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -v5 05/14] ACPI, APEI, Document for APEI
References: <1274164524-6092-1-git-send-email-ying.huang@intel.com> <1274164524-6092-6-git-send-email-ying.huang@intel.com>
In-Reply-To: <1274164524-6092-6-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BF30C2A.003E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Add document for APEI, including kernel parameters and EINJ debug file
> sytem interface.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/acpi/apei/einj.txt    |   49 ++++++++++++++++++++++++++++++++++++
>  Documentation/kernel-parameters.txt |    5 +++
>  2 files changed, 54 insertions(+)
>  create mode 100644 Documentation/acpi/apei/einj.txt
> 
> --- /dev/null
> +++ b/Documentation/acpi/apei/einj.txt
> @@ -0,0 +1,49 @@
> +			APEI Error INJection
> +			~~~~~~~~~~~~~~~~~~~~
> +
> +EINJ provides a hardware error injection mechanism, it is very useful

                                                     ; [or . + new sentence]

> +for debugging and testing of other APEI and RAS features.
> +
> +To use EINJ, make the following is enabled in your kernel

                make sure the following are enabled

> +configuration:
> +
> +CONFIG_DEBUG_FS
> +CONFIG_ACPI_APEI
> +CONFIG_ACPI_APEI_EINJ
> +
> +The user interface of EINJ is in debug file system, under the

                              is the debug file system,
[or "is in the debug file system"]

> +directory apei/einj. The following files are provided.
> +
> +- available_error_type
> +  Read this file will return the error injection capability of the

     Reading this file returns ...

> +  platform, that is, which error types are supported. The error type
> +  definition is as follow, the left field is the error type value, the
> +  right field is error description.
> +
> +    0x00000001	Processor Correctable
> +    0x00000002	Processor Uncorrectable non-fatal
> +    0x00000004	Processor Uncorrectable fatal
> +    0x00000008  Memory Correctable
> +    0x00000010  Memory Uncorrectable non-fatal
> +    0x00000020  Memory Uncorrectable fatal
> +    0x00000040	PCI Express Correctable
> +    0x00000080	PCI Express Uncorrectable fatal
> +    0x00000100	PCI Express Uncorrectable non-fatal
> +    0x00000200	Platform Correctable
> +    0x00000400	Platform Uncorrectable non-fatal
> +    0x00000800	Platform Uncorrectable fatal
> +
> +  The format of file contents are as above, except there are only the
> +  available error type lines.
> +
> +- error_type
> +  This file is used to set the error type value. The error type value
> +  is defined in "available_error_type" description.
> +
> +- error_inject
> +  Write any integer to this file to trigger the error
> +  injection. Before this, please specify all necessary error
> +  parameters.
> +
> +For more information about EINJ, please refer to ACPI specification
> +version 4.0, section 17.5.
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -843,6 +843,11 @@ and is between 256 and 4096 characters.
>  	hd=		[EIDE] (E)IDE hard drive subsystem geometry
>  			Format: <cyl>,<head>,<sect>
>  
> +	hest_disable	[ACPI]
> +			Disable Hardware Error Source Table (HEST) support,

s/,/;/

> +			corresponding firmware-first mode error processing
> +			logic will be disabled.
> +
>  	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
>  			size of <nn>. This works even on boxes that have no
>  			highmem otherwise. This also works to reduce highmem
> --

