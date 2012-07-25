Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2GYOSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:18:24 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45395 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933089Ab2GYOSX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:18:23 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Izz1202hzz8275bh186Mz2fh2a8h683h839h944hd25hf0ah107ah)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Topic: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Thread-Index: AQHNae+sL9Mcy5ytHkK/2crRs+eVQZc6C+ng
Date: Wed, 25 Jul 2012 14:18:03 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF9236A8B9A@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1343171518-15189-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1343171518-15189-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.24.39.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.OSDL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch I sent out yesterday for Linux to clean up the guest ID mess. For FreeBSD, you can use the following constant:

HV_FREEBSD_VENDOR_ID		0x8200

and use the function to generate the ID appropriately. Larry, I will forward you the proposal for guest ID in a separate email.

Regards.

K. Y

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, July 24, 2012 7:12 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; olaf@aepfle.de;
> apw@canonical.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
> 
> The current guest ID string in use in vmbus driver does not conform
> to the MSFT guidelines on guest ID. MSFT currently does not specify
> Linux specific guidelines. MSFT however has plans to publish Linux
> specific guidelines. This implementation conforms to the yet unpublished
> Linux specific guidelines for guest ID. This implementation also broadly
> conforms to the current guidelines as well.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/hv.c           |    9 +++++--
>  drivers/hv/hyperv_vmbus.h |   48
> +++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 86f8885..771e24f 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -26,6 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/hyperv.h>
> +#include <linux/version.h>
>  #include <asm/hyperv.h>
>  #include "hyperv_vmbus.h"
> 
> @@ -164,9 +165,11 @@ int hv_init(void)
> 
>  	max_leaf = query_hypervisor_info();
> 
> -	/* Write our OS info */
> -	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
> -	hv_context.guestid = HV_LINUX_GUEST_ID;
> +	/*
> +	 * Write our OS ID.
> +	 */
> +	hv_context.guestid = generate_guest_id(0, LINUX_VERSION_CODE, 0);
> +	wrmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
> 
>  	/* See if the hypercall page is already set */
>  	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 0614ff3..108a441 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -410,10 +410,50 @@ enum {
> 
>  #define HV_PRESENT_BIT			0x80000000
> 
> -#define HV_LINUX_GUEST_ID_LO		0x00000000
> -#define HV_LINUX_GUEST_ID_HI		2976579765
> -#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) |
> \
> -					   HV_LINUX_GUEST_ID_LO)
> +/*
> + * The guest OS needs to register the guest ID with the hypervisor.
> + * The guest ID is a 64 bit entity and the structure of this ID is
> + * specified in the Hyper-V specification:
> + *
> + * http://msdn.microsoft.com/en-us/library/windows/
> + * hardware/ff542653%28v=vs.85%29.aspx
> + *
> + * While the current guideline does not specify how Linux guest ID(s)
> + * need to be generated, our plan is to publish the guidelines for
> + * Linux and other guest operating systems that currently are hosted
> + * on Hyper-V. The implementation here conforms to this yet
> + * unpublished guidelines.
> + *
> + *
> + * Bit(s)
> + * 63 - Indicates if the OS is Open Source or not; 1 is Open Source
> + * 62:56 - Os Type; Linux is 0x100
> + * 55:48 - Distro specific identification
> + * 47:16 - Linux kernel version number
> + * 15:0  - Distro specific identification
> + *
> + *
> + */
> +
> +#define HV_LINUX_VENDOR_ID		0x8100
> +
> +/*
> + * Generate the guest ID based on the guideline described above.
> + */
> +
> +static inline  __u64 generate_guest_id(__u8 d_info1, __u32 kernel_version,
> +					__u16 d_info2)
> +{
> +	__u64 guest_id = 0;
> +
> +	guest_id = (((__u64)HV_LINUX_VENDOR_ID) << 48);
> +	guest_id |= (((__u64)(d_info1)) << 48);
> +	guest_id |= (((__u64)(kernel_version)) << 16);
> +	guest_id |= ((__u64)(d_info2));
> +
> +	return guest_id;
> +}
> +
> 
>  #define HV_CPU_POWER_MANAGEMENT		(1 << 0)
>  #define HV_RECOMMENDATIONS_MAX		4
> --
> 1.7.4.1
> 
> 
> 



