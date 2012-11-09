Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2KIP6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:58:37 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:19430
	"EHLO na01-bl2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754383Ab2KIP6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:58:35 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.244.37;KIP:(null);UIP:(null);(null);H:CH1PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
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
Subject: RE: [PATCH 3/3] tools/hv: Fix permissions of created directory and
 files
Thread-Topic: [PATCH 3/3] tools/hv: Fix permissions of created directory and
 files
Thread-Index: AQHNvoMQyMnEVewl5EiCUA9D+G/hnpfhqMPQ
Date: Fri, 9 Nov 2012 15:57:35 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930E2237A@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <1352469681-4432-1-git-send-email-thozza@redhat.com>
 <1352469681-4432-3-git-send-email-thozza@redhat.com>
In-Reply-To: <1352469681-4432-3-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.192.70.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: CH1PRD0310HT005.namprd03.prod.outlook.com
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
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464001)(377454001)(33656001)(31966008)(74662001)(50466001)(6806001)(46102001)(50986001)(47776002)(47736001)(4396001)(51856001)(46406002)(47976001)(44976002)(16676001)(47446002)(5343635001)(54316001)(49866001)(53806001)(76482001)(23726001)(54356001)(74502001)(55846005);DIR:OUT;SFP:;LANG:en;
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
> Subject: [PATCH 3/3] tools/hv: Fix permissions of created directory and files
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> It's silly to create directories without execute permission, or to
> give permissions to 'other' but not the group-owner.
> 
> Write the permissions in octal and 'ls -l' format since these are much
> easier to read than the named macros.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 573b9aa..9609858 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -236,7 +236,7 @@ static int kvp_file_init(void)
>  	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
> 
>  	if (access("/var/lib/hyperv", F_OK)) {
> -		if (mkdir("/var/lib/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
> +		if (mkdir("/var/lib/hyperv", 0755 /* rwxr-xr-x */)) {
>  			syslog(LOG_ERR, " Failed to create /var/lib/hyperv");
>  			exit(EXIT_FAILURE);
>  		}
> @@ -247,7 +247,7 @@ static int kvp_file_init(void)
>  		records_read = 0;
>  		num_blocks = 1;
>  		sprintf(fname, "/var/lib/hyperv/.kvp_pool_%d", i);
> -		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR |
> S_IROTH);
> +		fd = open(fname, O_RDWR | O_CREAT, 0644 /* rw-r--r-- */);
> 
>  		if (fd == -1)
>  			return 1;
> --
> 1.7.11.7
> 
> 


