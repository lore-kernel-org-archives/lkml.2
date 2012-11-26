Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2KZUoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:44:10 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:13361
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756375Ab2KZUoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:44:08 -0500
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h683h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH] Tools: hv: Fix for long file names from readdir
Thread-Topic: [PATCH] Tools: hv: Fix for long file names from readdir
Thread-Index: AQHNvbtZhEJZkpkrY0yrW3KCP0es1Jff/KWAgAAJToCAAA+cYIABX7KAgBs8tiA=
Date: Mon, 26 Nov 2012 20:43:40 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5A917@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E0242D@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1352465241-31001-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1352465241-31001-1-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Friday, November 09, 2012 7:47 AM
> To: olaf@aepfle.de; KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> Tomas Hozza
> Subject: [PATCH] Tools: hv: Fix for long file names from readdir
> 
> kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
> sized buffers which could be too small to store really long names.
> 
> Buffer sizes have been changed to PATH_MAX, include "limits.h" where
> PATH_MAX is defined was added and length checks ware added via snprintf.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 13c2a14..54ecb95 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -44,6 +44,7 @@
>  #include <fcntl.h>
>  #include <dirent.h>
>  #include <net/if.h>
> +#include <limits.h>
> 
>  /*
>   * KVP protocol: The user mode component first registers with the
> @@ -592,26 +593,22 @@ static char *kvp_get_if_name(char *guid)
>  	DIR *dir;
>  	struct dirent *entry;
>  	FILE    *file;
> -	char    *p, *q, *x;
> +	char    *p, *x;
>  	char    *if_name = NULL;
>  	char    buf[256];
>  	char *kvp_net_dir = "/sys/class/net/";
> -	char dev_id[256];
> +	char dev_id[PATH_MAX];
> 
>  	dir = opendir(kvp_net_dir);
>  	if (dir == NULL)
>  		return NULL;
> 
> -	snprintf(dev_id, sizeof(dev_id), "%s", kvp_net_dir);
> -	q = dev_id + strlen(kvp_net_dir);
> -
>  	while ((entry = readdir(dir)) != NULL) {
>  		/*
>  		 * Set the state for the next pass.
>  		 */
> -		*q = '\0';
> -		strcat(dev_id, entry->d_name);
> -		strcat(dev_id, "/device/device_id");
> +		snprintf(dev_id, sizeof(dev_id), "%s%s/device/device_id",
> kvp_net_dir,
> +				entry->d_name);
> 
>  		file = fopen(dev_id, "r");
>  		if (file == NULL)
> @@ -684,28 +681,23 @@ static char *kvp_mac_to_if_name(char *mac)
>  	DIR *dir;
>  	struct dirent *entry;
>  	FILE    *file;
> -	char    *p, *q, *x;
> +	char    *p, *x;
>  	char    *if_name = NULL;
>  	char    buf[256];
>  	char *kvp_net_dir = "/sys/class/net/";
> -	char dev_id[256];
> +	char dev_id[PATH_MAX];
>  	int i;
> 
>  	dir = opendir(kvp_net_dir);
>  	if (dir == NULL)
>  		return NULL;
> 
> -	snprintf(dev_id, sizeof(dev_id), kvp_net_dir);
> -	q = dev_id + strlen(kvp_net_dir);
> -
>  	while ((entry = readdir(dir)) != NULL) {
>  		/*
>  		 * Set the state for the next pass.
>  		 */
> -		*q = '\0';
> -
> -		strcat(dev_id, entry->d_name);
> -		strcat(dev_id, "/address");
> +		snprintf(dev_id, sizeof(dev_id), "%s%s/address", kvp_net_dir,
> +                entry->d_name);
> 
>  		file = fopen(dev_id, "r");
>  		if (file == NULL)
> --
> 1.7.11.7



