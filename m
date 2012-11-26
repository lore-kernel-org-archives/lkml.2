Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2KZUnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:43:00 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:50747
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354Ab2KZUm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:42:59 -0500
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h683h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h15d0l1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Topic: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Index: AQHNvoM3NhwpZHL+HEaRDr+rRQLm1Jfhp+kwgARB4ACAFsZWIA==
Date: Mon, 26 Nov 2012 20:42:40 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E5A907@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
 <1352710506-12590-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1352710506-12590-1-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PRD0310HT004.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Monday, November 12, 2012 3:55 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; ben@decadent.org.uk
> Cc: Tomas Hozza
> Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
> 
> Initial patch by Ben Hutchings <ben@decadent.org.uk>
> 
> We will install this in /usr, so it must use /var/lib for its state.
> Only programs installed under /opt should use /var/opt.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>


> ---
>  tools/hv/hv_kvp_daemon.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 54ecb95..d80a612 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -98,7 +98,7 @@ static struct utsname uts_buf;
>   * The location of the interface configuration file.
>   */
> 
> -#define KVP_CONFIG_LOC	"/var/opt/"
> +#define KVP_CONFIG_LOC	"/var/lib/hyperv"
> 
>  #define MAX_FILE_NAME 100
>  #define ENTRIES_PER_BLOCK 50
> @@ -235,9 +235,9 @@ static int kvp_file_init(void)
>  	int i;
>  	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
> 
> -	if (access("/var/opt/hyperv", F_OK)) {
> -		if (mkdir("/var/opt/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
> -			syslog(LOG_ERR, " Failed to create /var/opt/hyperv");
> +	if (access(KVP_CONFIG_LOC, F_OK)) {
> +		if (mkdir(KVP_CONFIG_LOC, S_IRUSR | S_IWUSR | S_IROTH)) {
> +			syslog(LOG_ERR, " Failed to create %s",
> KVP_CONFIG_LOC);
>  			exit(EXIT_FAILURE);
>  		}
>  	}
> @@ -246,7 +246,7 @@ static int kvp_file_init(void)
>  		fname = kvp_file_info[i].fname;
>  		records_read = 0;
>  		num_blocks = 1;
> -		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
> +		sprintf(fname, "%s/.kvp_pool_%d", KVP_CONFIG_LOC, i);
>  		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR |
> S_IROTH);
> 
>  		if (fd == -1)
> @@ -1263,7 +1263,7 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	 */
> 
>  	snprintf(if_file, sizeof(if_file), "%s%s%s", KVP_CONFIG_LOC,
> -		"hyperv/ifcfg-", if_name);
> +		"/ifcfg-", if_name);
> 
>  	file = fopen(if_file, "w");
> 
> --
> 1.7.11.7



