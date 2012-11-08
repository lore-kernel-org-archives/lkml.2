Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2KHNTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:19:04 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.31]:22052
	"EHLO na01-by2-obe.mail.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752108Ab2KHNTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:19:02 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.234.5;KIP:(null);UIP:(null);(null);H:SN2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0l1155h)
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH] tools: hv: Netlink source address validation allows DoS
Thread-Topic: [PATCH] tools: hv: Netlink source address validation allows DoS
Thread-Index: AQHNvZcZsR9QAfSilE6p0XX7e3nVfpff6s6Q
Date: Thu, 8 Nov 2012 13:18:08 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DFC341@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1352368409-18809-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1352368409-18809-1-git-send-email-thozza@redhat.com>
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(13464001)(31966008)(16676001)(44976002)(53806001)(74502001)(6806001)(51856001)(47776002)(4396001)(76482001)(54316001)(5343635001)(23726001)(33656001)(46102001)(74662001)(47736001)(47446002)(49866001)(50986001)(50466001)(47976001)(54356001)(46406002)(55846005);DIR:OUT;SFP:;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 06592CCE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Thursday, November 08, 2012 4:53 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan
> Cc: Tomas Hozza
> Subject: [PATCH] tools: hv: Netlink source address validation allows DoS
> 
> The source code without this patch caused hypervkvpd to exit when it processed
> a spoofed Netlink packet which has been sent from an untrusted local user.
> Now Netlink messages with a non-zero nl_pid source address are ignored
> and a warning is printed into the syslog.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 13c2a14..c1d9102 100755
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1486,13 +1486,19 @@ int main(void)
>  		len = recvfrom(fd, kvp_recv_buffer, sizeof(kvp_recv_buffer), 0,
>  				addr_p, &addr_l);
> 
> -		if (len < 0 || addr.nl_pid) {
> +		if (len < 0) {
>  			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
>  					addr.nl_pid, errno, strerror(errno));
>  			close(fd);
>  			return -1;
>  		}
> 
> +		if (addr.nl_pid) {
> +			syslog(LOG_WARNING, "Received packet from untrusted
> pid:%u",
> +					addr.nl_pid);
> +			continue;
> +		}
> +
>  		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
>  		incoming_cn_msg = (struct cn_msg
> *)NLMSG_DATA(incoming_msg);
>  		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
> --
> 1.7.11.7
> 
> 


