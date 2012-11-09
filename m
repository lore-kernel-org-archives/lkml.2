Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2KIP46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:56:58 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.28]:13091
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606Ab2KIP44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:56:56 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>
Subject: RE: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Topic: [PATCH 1/3] tools/hv: Fix /var subdirectory
Thread-Index: AQHNvoM3NhwpZHL+HEaRDr+rRQLm1Jfhp+kw
Date: Fri, 9 Nov 2012 15:56:14 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1352469681-4432-1-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.192.70.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT002.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464001)(377454001)(51704002)(46102001)(50466001)(51856001)(47776002)(5343635001)(54316001)(53806001)(31966008)(54356001)(16676001)(74662001)(47446002)(6806001)(49866001)(33656001)(50986001)(46406002)(47736001)(44976002)(74502001)(23726001)(47976001)(76482001)(4396001)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06607E485E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Friday, November 09, 2012 9:01 AM
> To: olaf@aepfle.de; KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; apw@canonical.com;
> jasowang@redhat.com; ben@decadent.org.uk
> Cc: Tomas Hozza
> Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
> 
> Initial patch by Ben Hutchings <ben@decadent.org.uk>
> 
> We will install this in /usr, so it must use /var/lib for its state.
> Only programs installed under /opt should use /var/opt.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 54ecb95..d9b3a74 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -98,7 +98,7 @@ static struct utsname uts_buf;
>   * The location of the interface configuration file.
>   */
> 
> -#define KVP_CONFIG_LOC	"/var/opt/"
> +#define KVP_CONFIG_LOC	"/var/lib/"
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
> +	if (access("/var/lib/hyperv", F_OK)) {
> +		if (mkdir("/var/lib/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
> +			syslog(LOG_ERR, " Failed to create /var/lib/hyperv");

Why don't you use the macro defined earlier for the path for /var/lib. Why
not include the hyperv directory as well in the macro.

Regards,

K. Y
>  			exit(EXIT_FAILURE);
>  		}
>  	}
> @@ -246,7 +246,7 @@ static int kvp_file_init(void)
>  		fname = kvp_file_info[i].fname;
>  		records_read = 0;
>  		num_blocks = 1;
> -		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
> +		sprintf(fname, "/var/lib/hyperv/.kvp_pool_%d", i);
>  		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR |
> S_IROTH);
> 
>  		if (fd == -1)
> --
> 1.7.11.7
> 
> 


